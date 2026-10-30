local common = import './signals/common.libsonnet';
{
  new(this): {
    local config = this.config,
    local signals = this.signals,
    local by = std.join(', ', config.groupLabels + config.instanceLabels),
    local instanceLabel = config.instanceLabels[std.length(config.instanceLabels) - 1],

    // Hosts that reported system_uptime within the window, for whichever metric names are configured.
    local seenWithin(window) = std.join(' or ', [
      'max_over_time(%s{%s}[%s])' % [common.discoveryMetric[source], config.filteringSelector, window]
      for source in config.metricsSource
    ]),

    local coreRules = [
      // Availability
      {
        alert: 'HostmetricsHostDown',
        // Seen in the last hour but silent for the window. The alert resolves
        // an hour after a host goes away for good.
        expr: 'max by (%s) (%s) unless max by (%s) (%s)' % [by, seenWithin('1h'), by, seenWithin(config.alertsHostDownWindow)],
        'for': '5m',
        labels: { severity: config.alertsHostDownSeverity },
        annotations: {
          summary: 'No host metrics received.',
          description: 'No metrics have been received from {{ $labels.%s }} for %s.' % [instanceLabel, config.alertsHostDownWindow],
        },
      },
      // Saturation
      {
        alert: 'HostmetricsCPUHighUsage',
        expr: '(%s) > %s' % [signals.cpu.cpuUsage.asRuleExpression(), config.alertsCPUHighUsageThreshold],
        'for': '15m',
        labels: { severity: config.alertsCPUHighUsageSeverity },
        annotations: {
          summary: 'Host CPU usage is high.',
          description: 'CPU usage on {{ $labels.%s }} has been above %s%% for 15 minutes, currently {{ printf "%%.2f" $value }}%%.' % [instanceLabel, config.alertsCPUHighUsageThreshold],
        },
      },
      {
        alert: 'HostmetricsMemoryHighUtilization',
        expr: '(%s) > %s' % [signals.memory.memoryUsagePercent.asRuleExpression(), config.alertsMemoryHighUtilizationThreshold],
        'for': '15m',
        labels: { severity: config.alertsMemoryHighUtilizationSeverity },
        annotations: {
          summary: 'Host memory usage is high.',
          description: 'Memory usage on {{ $labels.%s }} has been above %s%% for 15 minutes, currently {{ printf "%%.2f" $value }}%%.' % [instanceLabel, config.alertsMemoryHighUtilizationThreshold],
        },
      },
      {
        alert: 'HostmetricsDiskSpaceLow',
        expr: '(%s) > %s' % [signals.filesystem.filesystemUsagePercent.asRuleExpression(), config.alertsDiskSpaceLowThresholdWarning],
        'for': '30m',
        labels: { severity: 'warning' },
        annotations: {
          summary: 'Filesystem is nearly full.',
          description: '{{ $labels.mountpoint }} on {{ $labels.%s }} is {{ printf "%%.2f" $value }}%% full, above the threshold of %s%%.' % [instanceLabel, config.alertsDiskSpaceLowThresholdWarning],
        },
      },
      {
        alert: 'HostmetricsDiskSpaceLow',
        expr: '(%s) > %s' % [signals.filesystem.filesystemUsagePercent.asRuleExpression(), config.alertsDiskSpaceLowThresholdCritical],
        'for': '15m',
        labels: { severity: 'critical' },
        annotations: {
          summary: 'Filesystem is critically full.',
          description: '{{ $labels.mountpoint }} on {{ $labels.%s }} is {{ printf "%%.2f" $value }}%% full, above the threshold of %s%%.' % [instanceLabel, config.alertsDiskSpaceLowThresholdCritical],
        },
      },
      {
        alert: 'HostmetricsSystemSaturation',
        expr: 'max by (%s) (%s) > max by (%s) (%s) * %s' % [
          by,
          signals.cpu.loadAverage5m.asRuleExpression(),
          by,
          signals.host.cpuCount.asRuleExpression(),
          config.alertsSystemSaturationPerCoreThreshold,
        ],
        'for': '15m',
        labels: { severity: config.alertsSystemSaturationSeverity },
        annotations: {
          summary: 'Host load average is high relative to core count.',
          description: '5 minute load average on {{ $labels.%s }} is more than %s times its logical core count.' % [instanceLabel, config.alertsSystemSaturationPerCoreThreshold],
        },
      },
      {
        alert: 'HostmetricsInodesLow',
        expr: '(%s) > %s' % [signals.filesystem.inodesUsagePercent.asRuleExpression(), config.alertsInodesLowThresholdWarning],
        'for': '30m',
        labels: { severity: 'warning' },
        annotations: {
          summary: 'Filesystem is running out of inodes.',
          description: '{{ $labels.mountpoint }} on {{ $labels.%s }} has used {{ printf "%%.2f" $value }}%% of its inodes, above the threshold of %s%%.' % [instanceLabel, config.alertsInodesLowThresholdWarning],
        },
      },
      {
        alert: 'HostmetricsInodesLow',
        expr: '(%s) > %s' % [signals.filesystem.inodesUsagePercent.asRuleExpression(), config.alertsInodesLowThresholdCritical],
        'for': '30m',
        labels: { severity: 'critical' },
        annotations: {
          summary: 'Filesystem is almost out of inodes.',
          description: '{{ $labels.mountpoint }} on {{ $labels.%s }} has used {{ printf "%%.2f" $value }}%% of its inodes, above the threshold of %s%%.' % [instanceLabel, config.alertsInodesLowThresholdCritical],
        },
      },
      {
        alert: 'HostmetricsDiskIOSaturation',
        expr: '(%s) > %s' % [signals.disk.diskQueue.asRuleExpression(), config.alertsDiskIOSaturationThreshold],
        'for': '30m',
        labels: { severity: config.alertsDiskIOSaturationSeverity },
        annotations: {
          summary: 'Disk I/O queue is high.',
          description: 'The average I/O queue of {{ $labels.device }} on {{ $labels.%s }} has been above %s for 30 minutes, currently {{ printf "%%.2f" $value }}.' % [instanceLabel, config.alertsDiskIOSaturationThreshold],
        },
      },
      {
        alert: 'HostmetricsProcessesHigh',
        expr: '(%s) > %s' % [signals.host.processesRunning.asRuleExpression(), config.alertsProcessesHighThreshold],
        'for': '5m',
        labels: { severity: config.alertsProcessesHighSeverity },
        annotations: {
          summary: 'Many processes are running.',
          description: '{{ $labels.%s }} has had more than %s running processes for 5 minutes, currently {{ $value }}.' % [instanceLabel, config.alertsProcessesHighThreshold],
        },
      },
      // Events
      {
        alert: 'HostmetricsHostRebooted',
        expr: '(%s) < %s and (%s) > %s' % [
          signals.host.uptime.asRuleExpression(),
          config.alertsHostRebootedThreshold,
          signals.host.uptime.withOffset('%ss' % config.alertsHostRebootedThreshold).asRuleExpression(),
          config.alertsHostRebootedThreshold,
        ],
        labels: { severity: config.alertsHostRebootedSeverity },
        annotations: {
          summary: 'Host has rebooted.',
          description: '{{ $labels.%s }} booted {{ $value | humanizeDuration }} ago.' % instanceLabel,
        },
      },
    ],

    local networkRules = if config.enableNetworkScraper then [
      {
        alert: 'HostmetricsNetworkErrors',
        expr: '100 * (%s) / (%s) > %s' % [
          signals.network.networkErrors.asRuleExpression(),
          signals.network.networkPackets.asRuleExpression(),
          config.alertsNetworkErrorsThreshold,
        ],
        'for': '1h',
        labels: { severity: config.alertsNetworkErrorsSeverity },
        annotations: {
          summary: 'Network interface has a high error rate.',
          description: '{{ $labels.direction }} errors on {{ $labels.device }} on {{ $labels.%s }} have been above %s%% of packets for an hour, currently {{ printf "%%.2f" $value }}%%.' % [instanceLabel, config.alertsNetworkErrorsThreshold],
        },
      },
      {
        alert: 'HostmetricsConntrackHighUsage',
        expr: '100 * (%s) / (%s) > %s' % [
          signals.network.conntrackCount.asRuleExpression(),
          signals.network.conntrackMax.asRuleExpression(),
          config.alertsConntrackHighUsageThreshold,
        ],
        labels: { severity: config.alertsConntrackHighUsageSeverity },
        annotations: {
          summary: 'Connection tracking table is filling up.',
          description: '{{ $labels.%s }} is using {{ printf "%%.2f" $value }}%% of its conntrack entries, above the threshold of %s%%.' % [instanceLabel, config.alertsConntrackHighUsageThreshold],
        },
      },
    ] else [],

    local pagingRules = if config.enablePagingScraper then [
      {
        alert: 'HostmetricsMemoryMajorPageFaults',
        expr: '(%s) > %s' % [signals.memory.majorPageFaults.asRuleExpression(), config.alertsMemoryMajorPageFaultsThreshold],
        'for': '15m',
        labels: { severity: config.alertsMemoryMajorPageFaultsSeverity },
        annotations: {
          summary: 'Memory major page faults are high.',
          description: '{{ $labels.%s }} has had more than %s major page faults per second for 15 minutes, currently {{ printf "%%.2f" $value }}.' % [instanceLabel, config.alertsMemoryMajorPageFaultsThreshold],
        },
      },
    ] else [],

    groups: [
      {
        name: this.config.uid + '-alerts',
        rules: std.map(
          function(rule) rule { keep_firing_for: config.alertsKeepFiringFor },
          coreRules + networkRules + pagingRules,
        ),
      },
    ],
  },
}
