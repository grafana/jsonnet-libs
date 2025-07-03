{
  new(this): {
    local config = this.config,
    local signals = this.signals,
    local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet',
    local instanceLabel = xtd.array.slice(config.instanceLabels, -1)[0],
    local ADAlerts = [
      {
        alert: 'WindowsActiveDirectoryHighPendingReplicationOperations',
        expr: |||
          (%s) >= %s
        ||| % [
          signals.activeDirectory.replicationPendingOperations.asRuleExpression(),
          config.alertsHighPendingReplicationOperations,
        ],
        'for': '10m',
        keep_firing_for: '5m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'There is a high number of pending replication operations in Active Directory. A high number of pending operations sustained over a period of time can indicate a problem with replication.',
          description: |||
            The number of pending replication operations on {{$labels.%s}} is {{ printf "%%.2f" $value }} which is above the threshold of %s.
          ||| % [instanceLabel, config.alertsHighPendingReplicationOperations],
        },
      },
      {
        alert: 'WindowsActiveDirectoryHighReplicationSyncRequestFailures',
        expr: |||
          (%s) > %s
        ||| % [
          signals.activeDirectory.adReplicationSyncRequestFailures.asRuleExpression(),
          config.alertsHighReplicationSyncRequestFailures,
        ],
        'for': '5m',
        keep_firing_for: '5m',
        labels: {
          severity: 'critical',
        },
        annotations: {
          summary: 'There are a number of replication synchronization request failures. These can cause authentication failures, outdated information being propagated across domain controllers, and potentially data loss or inconsistencies.',
          description: |||
            The number of replication sync request failures on {{$labels.%s}} is {{ printf "%%.2f" $value }} which is above the threshold of %s.
          ||| % [instanceLabel, config.alertsHighReplicationSyncRequestFailures],
        },
      },
      {
        alert: 'WindowsActiveDirectoryHighPasswordChanges',
        expr: |||
          (%s) > %s
        ||| % [
          signals.activeDirectory.adPasswordChanges.asRuleExpression(),
          config.alertsHighPasswordChanges,
        ],
        'for': '5m',
        labels: {
          severity: 'warning',
          keep_firing_for: '24h',
        },
        annotations: {
          summary: 'There is a high number of password changes. This may indicate unauthorized changes or attacks.',
          description: |||
            The number of password changes on {{$labels.%s}} is {{ printf "%%.2f" $value }} which is greater than the threshold of %s. This alert would resolve itself if no new anomalies are detected within 24 hours.
          ||| % [instanceLabel, config.alertsHighPasswordChanges],
        },
      },
      {
        alert: 'WindowsActiveDirectoryMetricsDown',
        expr: |||
          (%s) == 0
        ||| % [
          signals.activeDirectory.adMetricsDown.asRuleExpression(),
        ],
        'for': '5m',
        labels: {
          severity: 'critical',
        },
        annotations: {
          summary: 'Windows Active Directory metrics are down.',
          description: 'There are no available metrics for Windows Active Directory integration from instance {{$labels.%s}}.' % instanceLabel,
        },
      },
    ],
    groups: [
      {
        name: 'windows-alerts-' + config.uid,
        rules: [
                 {
                   alert: 'WindowsCPUHighUsage',
                   expr: |||
                     (%s) > %s
                   ||| % [
                     signals.cpu.cpuUsage.asRuleExpression(),
                     config.alertsCPUThresholdWarning,
                   ],
                   'for': '15m',
                   keep_firing_for: '5m',
                   labels: {
                     severity: 'warning',
                   },
                   annotations: {
                     summary: 'High CPU usage on Windows host.',
                     description: |||
                       CPU usage on host {{ $labels.%s }} is above %s%%. The current value is {{ $value | printf "%%.2f" }}%%.
                     ||| % [instanceLabel, config.alertsCPUThresholdWarning],
                   },
                 },
                 {
                   alert: 'WindowsMemoryHighUtilization',
                   expr: |||
                     (%s) > %s
                   ||| % [
                     signals.memory.memoryUsagePercent.asRuleExpression(),
                     config.alertMemoryUsageThresholdCritical,
                   ],
                   'for': '15m',
                   keep_firing_for: '5m',
                   labels: {
                     severity: 'critical',
                   },
                   annotations: {
                     summary: 'High memory usage on Windows host.',
                     description: |||
                       Memory usage on host {{ $labels.%(instanceLabel)s }} is critically high, with {{ printf "%%.2f" $value }}%% of total memory used.
                       This exceeds the threshold of %(threshold)s%%.
                       Current memory free: {{ with printf `%(memoryFree)s` | query | first | value | humanize }}{{ . }}{{ end }}.
                       Total memory: {{ with printf `%(memoryTotal)s` | query | first | value | humanize }}{{ . }}{{ end }}.
                       Consider investigating processes consuming high memory or increasing available memory.
                     ||| % {
                       instanceLabel: instanceLabel,
                       threshold: config.alertMemoryUsageThresholdCritical,
                       memoryFree: signals.memory.memoryFree.asRuleExpression(),
                       memoryTotal: signals.memory.memoryTotal.asRuleExpression(),
                     },
                   },
                 },
                 {
                   alert: 'WindowsDiskAlmostOutOfSpace',
                   expr: |||
                     (%s) > %s
                   ||| % [
                     signals.disk.diskUsagePercent.asRuleExpression(),
                     config.alertDiskUsageThresholdCritical,
                   ],
                   'for': '15m',
                   keep_firing_for: '5m',
                   labels: {
                     severity: 'critical',
                   },
                   annotations: {
                     summary: 'Disk is almost full on Windows host.',
                     description: |||
                       Disk space on volume {{ $labels.volume }} of host {{ $labels.%s }} is critically low, with {{ printf "%%.2f" $value }}%% of total space used.
                       This exceeds the threshold of %s%%.
                       Current disk free: {{ with printf `windows_logical_disk_free_bytes{volume="%%s", %s}` $labels.volume | query | first | value | humanize }}{{ . }}{{ end }}.
                       Total disk size: {{ with printf `windows_logical_disk_size_bytes{volume="%%s", %s}` $labels.volume | query | first | value | humanize }}{{ . }}{{ end }}.
                       Consider cleaning up unnecessary files or increasing disk capacity.
                     ||| % [instanceLabel, config.alertDiskUsageThresholdCritical, config.filteringSelector, config.filteringSelector],
                   },
                 },
                 {
                   alert: 'WindowsDiskDriveNotHealthy',
                   expr: |||
                     (%s) != 1
                   ||| % [
                     signals.disk.diskDriveStatus.withFilteringSelectorMixin('status="OK"').asRuleExpression(),
                   ],
                   'for': '5m',
                   labels: {
                     severity: 'critical',
                   },
                   annotations: {
                     summary: 'Windows physical disk is not healthy.',
                     description: "Windows disk {{ $labels.name }} is not in healthy state, currently in '{{ $labels.status }}' status.",
                   },
                 },
                 {
                   alert: 'WindowsNTPClientDelay',
                   expr: |||
                     (%s) > 1
                   ||| % [
                     signals.services.ntpDelay.asRuleExpression(),
                   ],
                   'for': '5m',
                   keep_firing_for: '5m',
                   labels: {
                     severity: 'warning',
                   },
                   annotations: {
                     summary: 'NTP client delay.',
                     description: 'Round-trip time of NTP client on instance {{ $labels.%s }} is greater than 1 second. Delay is {{ printf "%%.2f" $value }} sec.' % instanceLabel,
                   },
                 },
                 {
                   alert: 'WindowsNTPTimeOffset',
                   expr: |||
                     (%s) > 1
                   ||| % [
                     signals.services.ntpTimeOffset.asRuleExpression(),
                   ],
                   'for': '5m',
                   keep_firing_for: '5m',
                   labels: {
                     severity: 'warning',
                   },
                   annotations: {
                     summary: 'NTP time offset is too large.',
                     description: 'NTP time offset for instance {{ $labels.%s }} is greater than 1 second. Offset is {{ $value }} sec.' % instanceLabel,
                   },
                 },
                 {
                   alert: 'WindowsNodeHasRebooted',
                   expr: |||
                     (%s) < 600
                     and
                     (%s) > 600
                   ||| % [
                     signals.system.uptime.asRuleExpression(),
                     signals.system.uptime.withOffset('10m').asRuleExpression(),
                   ],
                   labels: {
                     severity: 'info',
                   },
                   annotations: {
                     summary: 'Node has rebooted.',
                     description: 'Node {{ $labels.%s }} has rebooted {{ $value | humanize }} seconds ago.' % instanceLabel,
                   },
                 },
               ]
               + if std.member(config.metricsSource, 'prometheus_pre_0_30') then
                 [
                   {
                     alert: 'WindowsServiceNotHealthy',
                     expr: |||
                       (%s) > 0
                     ||| % [
                       signals.services.serviceNotHealthy.asRuleExpression(),
                     ],
                     'for': '5m',
                     labels: {
                       severity: 'critical',
                     },
                     annotations: {
                       summary: 'Windows service is not healthy.',
                       description: "Windows service {{ $labels.name }} is not in healthy state, currently in '{{ $labels.status }}'.",
                     },
                   },
                 ] else []
                        + if config.enableADDashboard then ADAlerts else [],
      },
    ],
  },
}
