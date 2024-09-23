{
  new(this): {
    groups+: [
      {
        name: this.config.uid,
        rules:
          [
            {
              alert: 'AzureVMAvailableMemoryLow',
              expr: |||
                sum by (%s) (%s) < this.config.alertAzureVMAvailableMemoryLowThreshold
              ||| % [
                std.join(',', this.config.groupLabels + this.config.instanceLabels),
                this.signals.azurevm.availableMemory.asRuleExpression(),
              ],
              'for': '5m',
              keep_firing_for: '10m',
              labels: {
                severity: this.config.alertAzureVMAvailableMemoryLowSeverity,
              },
              annotations: {
                summary: 'Available memory is too low',
                description: 'The available memory for the virtual machine: {{$labels.resourceName}} is too low and may struggle to allocate memory for processes, leading to slow performance, swapping, or even crashes.',
              },
            },
          ],
      },
    ],
  },
}
