{
  new(this): {
    groups+: [
      {
        name: this.config.uid,
        rules:
          [
            {
              alert: 'AzureVMHighCpuUtilization',
              expr: 'avg by (%s) (%s) > 85' %
                    [
                      std.join(',', this.config.groupLabels + this.config.instanceLabels),
                      this.signals.azurevm.cpuUtilization.asRuleExpression(),
                    ],
              'for': '5m',
              keep_firing_for: '10m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'CPU utilization is too high',
                description: 'The VM {{$labels.resourceName}} is under heavy load and may become unresponsive.',
              },
            },
            {
              alert: 'AzureVMUnavailable',
              expr: 'avg by (%s) (%s) != 1' %
                    [
                      std.join(',', this.config.groupLabels + this.config.instanceLabels),
                      this.signals.azurevmOverview.vmAvailability.asRuleExpression(),
                    ],
              'for': '5m',
              keep_firing_for: '10m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'VM unavailable',
                description: 'The VM {{$labels.resourceName}} is not functioning or crashed, which may require immediate action.',
              },
            },
          ],
      },
    ],
  },
}
