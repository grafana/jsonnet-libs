local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

{
  new(this): {
    local instanceLabel = xtd.array.slice(this.config.instanceLabels, -1)[0],
    local groupLabel = xtd.array.slice(this.config.groupLabels, -1)[0],
    groups+: [
      {
        name: this.config.uid + '-fc-alerts',
        rules:
          [
            {
              alert: 'SNMPInterfaceFCerrors',
              expr: |||
                      (%s) > 0
                    |||
                    % [
                      this.signals.fiber.fcIfFramesDiscard.asRuleExpression(),
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Too many packets with errors (fcIfFramesDiscard) on the FC network interface.',
                description: |||
                  Too many packets with errors (fcIfFramesDiscard) on {{ $labels.%s }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (15m).
                ||| % [instanceLabel],
              },
              'for': '15m',
              keep_firing_for: '5m',
            },
            {
              alert: 'SNMPInterfaceFCerrors',
              expr: |||
                      (%s) > 0
                    |||
                    % [
                      this.signals.fiber.fcIfInvalidCrcs.asRuleExpression(),
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Too many packets with errors (fcIfInvalidCrcs) on the FC network interface.',
                description: |||
                  Too many packets with errors (fcIfInvalidCrcs) on {{ $labels.%s }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (15m).
                ||| % [instanceLabel],
              },
              'for': '15m',
              keep_firing_for: '5m',
            },
            {
              alert: 'SNMPInterfaceFCerrors',
              expr: |||
                      (%s) > 0
                    |||
                    % [
                      this.signals.fiber.fcIfInvalidTxWords.asRuleExpression(),
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Too many packets with errors (fcIfInvalidTxWords) on the FC network interface.',
                description: |||
                  Too many packets with errors (fcIfInvalidTxWords) on {{ $labels.%s }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (15m).
                ||| % [instanceLabel],
              },
              'for': '15m',
              keep_firing_for: '5m',
            },
          ],
      },
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
            },
            {
              alert: 'SNMPFRUComponentProblem',
              expr: |||
                (%s) == 1
              ||| % [
                this.signals.system.fruOperStatus.withFilteringSelectorMixin('cefcFRUPowerOperStatus!="on"').asRuleExpression(),
              ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'SNMP FRU component is not on.',
                description: 'SNMP field replaceable unit is in {{ $labels.cefcFRUPowerOperStatus }} status on {{ $labels.%(instanceLabel)s }}.'
                             % this.config { instanceLabel: instanceLabel },
              },
            },
            {
              alert: 'SNMPNodeCPUHighUsage',
              expr: |||
                avg by (%s) (%s) > %s
              ||| % [
                std.join(',', this.config.groupLabels + this.config.instanceLabels),
                this.signals.cpu.cpuUsage.asRuleExpression(),
                this.config.alertsCPUThresholdWarning,
              ],
              'for': '15m',
              keep_firing_for: '5m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'High CPU usage on SNMP node.',
                description: |||
                  CPU usage on SNMP node {{ $labels.%(instanceLabel)s }} is above %(alertsCPUThresholdWarning)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
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
                this.config.alertMemoryUsageThresholdCritical,
              ],
              labels: {
                severity: 'info',
              },
              annotations: {
                summary: 'High memory usage on SNMP node.',
                description: |||
                  Memory usage on SNMP node {{ $labels.%(instanceLabel)s }} is above %(alertMemoryUsageThresholdCritical)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
                ||| % this.config { instanceLabel: instanceLabel },
              },
            },
            {
              alert: 'SNMPInterfaceDown',
              expr: |||
                      (%s) == 2
                      # only alert if interface is adminatratively up:
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
                      # only alert if interface is adminatratively up:
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
              alert: 'SNMPInterfaceDrops',
              expr: |||
                      (%s) > %s
                      or
                      (%s) > %s
                    |||
                    % [
                      this.signals.interface.networkInDroppedPerSec.asRuleExpression(),
                      this.config.alertsPacketsDroppedPerSecThresholdWarning,
                      this.signals.interface.networkOutDroppedPerSec.asRuleExpression(),
                      this.config.alertsPacketsDroppedPerSecThresholdWarning,
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Too many packets discarded on the network interface.',
                description: |||
                  Too many packets discarded on {{ $labels.%s }}, interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (30m).
                ||| % [instanceLabel],
              },
              'for': '30m',
              keep_firing_for: '5m',
            },
            {
              alert: 'SNMPInterfaceErrors',
              expr: |||
                      (%s) > %s
                      or
                      (%s) > %s
                    |||
                    % [
                      this.signals.interface.networkInErrorsPerSec.asRuleExpression(),
                      this.config.alertsErrorsPerSecThresholdWarning,
                      this.signals.interface.networkOutErrorsPerSec.asRuleExpression(),
                      this.config.alertsErrorsPerSecThresholdWarning,
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Too many packets with errors on the network interface.',
                description: |||
                  Too many packets with errors on {{ $labels.%s }}, interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (15m).
                ||| % [instanceLabel],
              },
              'for': '15m',
              keep_firing_for: '5m',
            },
            {
              alert: 'SNMPInterfaceIsFlapping',
              expr: |||
                      changes(%s[5m]) > 5
                    |||
                    % [
                      this.signals.interface.ifOperStatus.asRuleExpression(),
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Network interface is flapping.',
                description: |||
                  Network interface {{ $labels.ifName }} ({{$labels.ifAlias}}) is flapping on {{ $labels.%s }}. It has changed its status more than 5 times in the last 5 minutes.
                ||| % [instanceLabel],
              },
              'for': '0',
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
              expr: 'snmp_scrape_pdus_returned{%s} <= 1' % this.config.filteringSelector,
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'SNMP exporter returns an empty response.',
                description: |||
                  SNMP exporter returns an empty response for node {{ $labels.%s }} and module {{ $labels.module}}. Please check that target support {{ $labels.module }} module as well as authentication and other SNMP settings.
                ||| % instanceLabel,
              },
              'for': '10m',
              keep_firing_for: '5m',
            },
            {
              alert: 'SNMPExporterSlowScrape',
              expr: 'min_over_time(snmp_scrape_duration_seconds{%s}[5m]) > %s' % [this.config.filteringSelector, this.config.alertsSlowScrapeThresholdInfo],
              labels: {
                severity: 'info',
              },
              annotations: {
                summary: 'SNMP exporter scrape is slow.',
                description: |||
                  SNMP exporter scrape of {{ $labels.%s }} is taking more than %s seconds. Please check SNMP modules polled and that snmp_exporter is located on the same network as the SNMP target.
                ||| % [instanceLabel, this.config.alertsSlowScrapeThresholdInfo],
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
                  expr: 'up{%s} == 0' % this.config.filteringSelector,
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
