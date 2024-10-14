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
                service: 'Azure Virtual Machines',
                namespace: 'cloud-provider-' + this.config.uid,
              },
              annotations: {
                summary: 'CPU utilization is too high',
                description: 'The VM {{$labels.resourceName}} is under heavy load and may become unresponsive.',
                dashboard_uid: '58f33c50e66c911b0ad8a25aa438a96e',
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
                service: 'Azure Virtual Machines',
                namespace: 'cloud-provider-' + this.config.uid,
              },
              annotations: {
                summary: 'VM unavailable',
                description: 'The VM {{$labels.resourceName}} is not functioning or crashed, which may require immediate action.',
                dashboard_uid: '58f33c50e66c911b0ad8a25aa438a96e',
              },
            },
            {
              alert: 'GcpCEHighCpuUtilization',
              expr: 'avg by (%s) (%s) > 85' %
                    [
                      std.join(',', this.config.groupLabels + this.config.instanceLabels),
                      this.signals.gcpceOverview.tableCpuUtilization.asRuleExpression(),
                    ],
              'for': '5m',
              keep_firing_for: '10m',
              labels: {
                severity: 'critical',
                service: 'Compute Engine',
                namespace: 'cloud-provider-' + this.config.uid,
              },
              annotations: {
                summary: 'CPU utilization is too high',
                description: 'The VM {{$labels.instance_name}} is under heavy load and may become unresponsive.',
                dashboard_uid: 'f115fe73641347c43415535d77e2dc0f',
              },
            },
          ],
      },
    ],
  },
}
