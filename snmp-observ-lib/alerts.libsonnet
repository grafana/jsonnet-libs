local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

{
  new(this): {
    local instanceLabel = xtd.array.slice(this.config.instanceLabels, -1)[0],
    local groupLabel = xtd.array.slice(this.config.groupLabels, -1)[0],
    local interface = this.signals.interface,
    // Inbound packet counts leave out errored and discarded packets, and outbound counts include them (RFC 2863).
    // An interface that reports no inbound packet counts would read 100% on its first inbound error.
    local percentOfPackets(counter, unicast, multicast, broadcast, inbound) =
      local rated(signal) = '(%s)' % signal.withRangeFunction('rate').asRuleExpression();
      '100 * %(c)s / (((%(u)s or %(c)s * 0) + (%(m)s or %(c)s * 0) + (%(b)s or %(c)s * 0)%(total)s) > 0)%(reported)s' % {
        total: if inbound then ' + %s' % rated(counter) else '',
        reported: if inbound then ' and (%s)' % std.join(' or ', [
          '%s{%s}' % [metric, this.config.filteringSelector]
          for metric in ['ifHCInUcastPkts', 'ifHCInMulticastPkts', 'ifHCInBroadcastPkts']
        ]) else '',
        c: rated(counter),
        u: rated(unicast),
        m: rated(multicast),
        b: rated(broadcast),
      },
    // A signal with no source in metricsSource is a stub, whose rule expression is an empty object.
    local hasSource(signal) = std.isString(signal.asRuleExpression()),
    local fiber = this.signals.fiber,
    local fruOperStatus = this.signals.system.fruOperStatus,
    groups+: (
      if std.all(std.map(hasSource, [fiber.fcIfFramesDiscard, fiber.fcIfInvalidCrcs, fiber.fcIfInvalidTxWords])) then [
        {
          name: this.config.uid + '-fc-alerts',
          rules:
            [
              {
                local rule = self,
                alert: 'SNMPInterfaceFCerrors',
                expr: |||
                        (%s) > %s
                      |||
                      % [
                        fiber.fcIfFramesDiscard.asRuleExpression(),
                        this.config.alertsInterfaceFCErrorsWarning,
                      ],
                labels: {
                  severity: 'warning',
                },
                annotations: {
                  summary: 'Too many packets with errors (fcIfFramesDiscard) on the FC network interface.',
                  description: |||
                    Too many packets with errors (fcIfFramesDiscard) on {{ $labels.%s }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}): above %s per second for extended period of time (%s).
                  ||| % [instanceLabel, this.config.alertsInterfaceFCErrorsWarning, rule['for']],
                },
                'for': '15m',
                keep_firing_for: '5m',
              },
              {
                local rule = self,
                alert: 'SNMPInterfaceFCerrors',
                expr: |||
                        (%s) > %s
                      |||
                      % [
                        fiber.fcIfInvalidCrcs.asRuleExpression(),
                        this.config.alertsInterfaceFCErrorsWarning,
                      ],
                labels: {
                  severity: 'warning',
                },
                annotations: {
                  summary: 'Too many packets with errors (fcIfInvalidCrcs) on the FC network interface.',
                  description: |||
                    Too many packets with errors (fcIfInvalidCrcs) on {{ $labels.%s }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}): above %s per second for extended period of time (%s).
                  ||| % [instanceLabel, this.config.alertsInterfaceFCErrorsWarning, rule['for']],
                },
                'for': '15m',
                keep_firing_for: '5m',
              },
              {
                local rule = self,
                alert: 'SNMPInterfaceFCerrors',
                expr: |||
                        (%s) > %s
                      |||
                      % [
                        fiber.fcIfInvalidTxWords.asRuleExpression(),
                        this.config.alertsInterfaceFCErrorsWarning,
                      ],
                labels: {
                  severity: 'warning',
                },
                annotations: {
                  summary: 'Too many packets with errors (fcIfInvalidTxWords) on the FC network interface.',
                  description: |||
                    Too many packets with errors (fcIfInvalidTxWords) on {{ $labels.%s }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}): above %s per second for extended period of time (%s).
                  ||| % [instanceLabel, this.config.alertsInterfaceFCErrorsWarning, rule['for']],
                },
                'for': '15m',
                keep_firing_for: '5m',
              },
            ],
        },
      ] else []
    ) + [
      {
        name: this.config.uid + '-alerts',
        rules:
          [
            {
              alert: 'SNMPNodeHasRebooted',
              expr: |||
                (%s) < 600 and (%s) > 600
              ||| % [
                this.signals.system.uptime.asRuleExpression(),
                this.signals.system.uptime.withOffset('10m').asRuleExpression(),
              ],
              labels: {
                severity: 'info',
              },
              annotations: {
                summary: 'SNMP node has rebooted.',
                description: 'SNMP node {{ $labels.%(instanceLabel)s }} has rebooted {{ $value | humanize }} seconds ago.'
                             % this.config { instanceLabel: instanceLabel },
              },
              'for': '5m',
            },
          ] + (if hasSource(fruOperStatus) then [
                 {
                   alert: 'SNMPFRUComponentProblem',
                   expr: |||
                     (%s) == 1
                   ||| % [
                     fruOperStatus.withFilteringSelectorMixin('cefcFRUPowerOperStatus!="on"').asRuleExpression(),
                   ],
                   labels: {
                     severity: 'warning',
                   },
                   annotations: {
                     summary: 'SNMP FRU component is not on.',
                     description: 'SNMP field replaceable unit is in {{ $labels.cefcFRUPowerOperStatus }} status on {{ $labels.%(instanceLabel)s }}.'
                                  % this.config { instanceLabel: instanceLabel },
                   },
                   'for': '5m',
                 },
               ] else []) + [
            {
              alert: 'SNMPNodeCPUHighUsage',
              expr: |||
                avg by (%s) (%s) > %s
              ||| % [
                std.join(',', this.config.groupLabels + this.config.instanceLabels),
                this.signals.cpu.cpuUsage.asRuleExpression(),
                this.config.alertsNodeCPUHighUsageWarning,
              ],
              'for': '15m',
              keep_firing_for: '5m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'High CPU usage on SNMP node.',
                description: |||
                  CPU usage on SNMP node {{ $labels.%(instanceLabel)s }} is above %(alertsNodeCPUHighUsageWarning)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
                ||| % this.config { instanceLabel: instanceLabel },
              },
            },
            {
              alert: 'SNMPNodeMemoryUtilization',
              expr: |||
                avg by (%s) (%s) > %s
              ||| % [
                std.join(',', this.config.groupLabels + this.config.instanceLabels),
                this.signals.memory.memoryUsage.asRuleExpression(),
                this.config.alertsNodeMemoryUtilizationInfo,
              ],
              labels: {
                severity: 'info',
              },
              annotations: {
                summary: 'High memory usage on SNMP node.',
                description: |||
                  Memory usage on SNMP node {{ $labels.%(instanceLabel)s }} is above %(alertsNodeMemoryUtilizationInfo)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
                ||| % this.config { instanceLabel: instanceLabel },
              },
              'for': '15m',
            },
            {
              alert: 'SNMPInterfaceDown',
              expr: |||
                      (%s) == 2
                      # only alert if interface is administratively up:
                      and (%s) != 2
                    |||
                    % [
                      this.signals.interface.ifOperStatus.withFilteringSelectorMixin(this.config.alertInterfaceDownSelectorCritical).asRuleExpression(),
                      this.signals.interface.ifAdminStatus.asRuleExpression(),
                    ],
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Critical network interface is down on SNMP device.',
                description: |||
                  A critical network interface {{$labels.ifName}} ({{$labels.ifAlias}}) on {{$labels.%s}} is down. 
                  Note that only interfaces with ifAdminStatus = `up` and matching `%s` are being checked and considered critical.
                ||| % [instanceLabel, this.config.alertInterfaceDownSelectorCritical],
              },
              'for': '5m',
              keep_firing_for: '5m',
            },
            {
              alert: 'SNMPInterfaceDown',
              expr: |||
                      (%s) == 2
                      # only alert if interface is administratively up:
                      and (%s) != 2
                    |||
                    % [
                      this.signals.interface.ifOperStatus.withFilteringSelectorMixin(this.config.alertInterfaceDownSelectorWarning).asRuleExpression(),
                      this.signals.interface.ifAdminStatus.asRuleExpression(),
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Network interface is down on SNMP device.',
                description: |||
                  Network interface {{$labels.ifName}} ({{$labels.ifAlias}}) on {{$labels.%s}} is down. 
                  Only interfaces with ifAdminStatus = `up` and matching `%s` are being checked.
                ||| % [instanceLabel, this.config.alertInterfaceDownSelectorWarning],
              },
              'for': '5m',
              keep_firing_for: '5m',
            },
            {
              local rule = self,
              alert: 'SNMPInterfaceDrops',
              expr: |||
                      (%s) > %s
                      or
                      (%s) > %s
                    |||
                    % [
                      percentOfPackets(interface.networkInDroppedPerSec, interface.networkInUnicastPacketsPerSec, interface.networkInMulticastPacketsPerSec, interface.networkInBroadcastPacketsPerSec, inbound=true),
                      this.config.alertsInterfaceDropsWarning,
                      percentOfPackets(interface.networkOutDroppedPerSec, interface.networkOutUnicastPacketsPerSec, interface.networkOutMulticastPacketsPerSec, interface.networkOutBroadcastPacketsPerSec, inbound=false),
                      this.config.alertsInterfaceDropsWarning,
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Too many packets discarded on the network interface.',
                description: |||
                  Too many packets discarded on {{ $labels.%s }}, interface {{ $labels.ifName }} ({{$labels.ifAlias}}): above %s%% of packets for extended period of time (%s).
                ||| % [instanceLabel, this.config.alertsInterfaceDropsWarning, rule['for']],
              },
              'for': '30m',
              keep_firing_for: '5m',
            },
            {
              local rule = self,
              alert: 'SNMPInterfaceErrors',
              expr: |||
                      (%s) > %s
                      or
                      (%s) > %s
                    |||
                    % [
                      percentOfPackets(interface.networkInErrorsPerSec, interface.networkInUnicastPacketsPerSec, interface.networkInMulticastPacketsPerSec, interface.networkInBroadcastPacketsPerSec, inbound=true),
                      this.config.alertsInterfaceErrorsWarning,
                      percentOfPackets(interface.networkOutErrorsPerSec, interface.networkOutUnicastPacketsPerSec, interface.networkOutMulticastPacketsPerSec, interface.networkOutBroadcastPacketsPerSec, inbound=false),
                      this.config.alertsInterfaceErrorsWarning,
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Too many packets with errors on the network interface.',
                description: |||
                  Too many packets with errors on {{ $labels.%s }}, interface {{ $labels.ifName }} ({{$labels.ifAlias}}): above %s%% of packets for extended period of time (%s).
                ||| % [instanceLabel, this.config.alertsInterfaceErrorsWarning, rule['for']],
              },
              'for': '15m',
              keep_firing_for: '5m',
            },
            {
              local windowMinutes = 15,
              alert: 'SNMPInterfaceIsFlapping',
              expr: |||
                      changes(%s[%dm]) > 5
                    |||
                    % [
                      this.signals.interface.ifOperStatus.asRuleExpression(),
                      windowMinutes,
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Network interface is flapping.',
                description: |||
                  Network interface {{ $labels.ifName }} ({{$labels.ifAlias}}) is flapping on {{ $labels.%s }}. It has changed its status more than 5 times in the last %d minutes.
                ||| % [instanceLabel, windowMinutes],
              },
              'for': '5m',
              keep_firing_for: '5m',
            },
          ],
      },
      {
        name: this.config.uid + '-exporter-alerts',
        rules:
          [
            {
              alert: 'SNMPExporterEmptyResponse',
              expr: '%s <= 1' % this.signals.exporter.pdusReturned.asRuleExpression(),
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'SNMP exporter returns an empty response.',
                description: |||
                  SNMP exporter returns an empty response for node {{ $labels.%s }} and module {{ $labels.module}}. Please check that the target supports the {{ $labels.module }} module, and check its authentication and other SNMP settings.
                ||| % instanceLabel,
              },
              'for': '10m',
              keep_firing_for: '5m',
            },
            {
              alert: 'SNMPExporterSlowScrape',
              expr: 'min_over_time(%s[5m]) > %s' % [this.signals.exporter.scrapeDuration.asRuleExpression(), this.config.alertsExporterSlowScrapeInfo],
              labels: {
                severity: 'info',
              },
              annotations: {
                summary: 'SNMP exporter scrape is slow.',
                description: |||
                  SNMP exporter scrape of {{ $labels.%s }} is taking more than %s seconds. Please check SNMP modules polled and that snmp_exporter is located on the same network as the SNMP target.
                ||| % [instanceLabel, this.config.alertsExporterSlowScrapeInfo],
              },
              'for': '10m',
              keep_firing_for: '5m',
            },
          ]
          + (
            if this.config.filteringSelector != '' then
              [
                {
                  alert: 'SNMPExporterNoResponse',
                  expr: '%s == 0' % this.signals.exporter.up.asRuleExpression(),
                  labels: {
                    severity: 'warning',
                  },
                  annotations: {
                    summary: 'SNMP node is down.',
                    description: |||
                      SNMP exporter scrape of node {{ $labels.%s }} is not responding to SNMP walk.
                      Please check network connectivity and SNMP authentication settings.
                    ||| % instanceLabel,
                  },
                  'for': '10m',
                },
              ]
            else []
          ),
      },

    ],
  },
}
