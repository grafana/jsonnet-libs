local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

{
  new(this): {
    local instanceLabel = xtd.array.slice(this.config.instanceLabels, -1)[0],
    local groupLabel = xtd.array.slice(this.config.groupLabels, -1)[0],
    groups+: [
      {
        name: this.config.uid + '-snmp-alerts',
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
                description: 'SNMP node {{ %s }} has rebooted {{ $value | humanize }} seconds ago.' % instanceLabel,
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
                      and (%s) != 1
                    |||
                    % [
                      this.signals.interface.ifOperStatus.withFilteringSelectorMixin(this.config.alertInterfaceDownSelector).asRuleExpression(),
                      this.signals.interface.ifAdminStatus.asRuleExpression(),
                    ],
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Network interface is down on SNMP device.',
                description: |||
                  Network interface {{$labels.ifName}} ({{$labels.ifAlias}}) on {{$labels.%s}} is down. 
                  Only interfaces with ifAdminStatus = `up` and matching `%s` are being checked.'
                ||| % [instanceLabel, this.config.alertInterfaceDownSelector],
              },
              'for': '5m',
              keep_firing_for: '3m',
            },
            {
              alert: 'SNMPInterfaceDrops',
              expr: |||
                      (%s) > 0
                      or
                      (%s) > 0
                    |||
                    % [
                      this.signals.interface.networkInDroppedPerSec.asRuleExpression(),
                      this.signals.interface.networkOutDroppedPerSec.asRuleExpression(),
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
              keep_firing_for: '3m',
            },
            {
              alert: 'SNMPInterfaceErrors',
              expr: |||
                      (%s) > 0
                      or
                      (%s) > 0
                    |||
                    % [
                      this.signals.interface.networkInErrorsPerSec.asRuleExpression(),
                      this.signals.interface.networkOutErrorsPerSec.asRuleExpression(),
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
              keep_firing_for: '3m',
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
              keep_firing_for: '3m',
            },
          ] +
          (
            if this.config.filteringSelector != '' then
              [
                {
                  alert: 'SNMPNodeDown',
                  expr: 'up{%s} == 0' % this.config.filteringSelector,
                  labels: {
                    severity: 'critical',
                  },
                  annotations: {
                    summary: 'SNMP target is down.',
                    description: |||
                      Failed to scrape metrics from SNMP node {{$labels.%s}}.
                      If device is available, please check network connectivity and SNMP authentication settings.
                    ||| % instanceLabel,
                  },
                  'for': '5m',
                },
              ]
            else []
          ),
      },
    ],
  },
}
