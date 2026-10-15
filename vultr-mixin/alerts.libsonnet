{
  new(this): {
    groups: [
      {
        name: this.config.uid + '-alerts',
        rules: [
          {
            alert: 'VultrMetricsDown',
            expr: |||
              up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Vultr metrics are down.',
              description: 'Grafana is no longer receiving metrics for the Vultr integration from instance {{$labels.instance}}.',
            },
          },
          {
            alert: 'VultrInstanceHighCPUUsage',
            expr: 'vultr_instance_cpu_usage_percent{%(filteringSelector)s} > %(alertsCPUUsageWarning)s' % this.config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Vultr instance CPU usage is high.',
              description: 'CPU usage on Vultr instance {{ $labels.label }} in {{ $labels.region }} is {{ printf "%%.0f" $value }}%%, above the threshold of %(alertsCPUUsageWarning)s%%.' % this.config,
            },
          },
          {
            alert: 'VultrBandwidthAllowanceWarning',
            expr: '100 * sum by (job) (vultr_instance_bandwidth_tx_bytes_total{%(filteringSelector)s}) / (sum by (job) (vultr_instance_bandwidth_allowed_bytes{%(filteringSelector)s}) > 0) > %(alertsBandwidthUsageWarning)s' % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Vultr instances are close to their pooled bandwidth allowance.',
              description: 'Vultr instances have used {{ printf "%%.0f" $value }}%% of their pooled outbound bandwidth allowance this billing period, above the threshold of %(alertsBandwidthUsageWarning)s%%.' % this.config,
            },
          },
          {
            alert: 'VultrBandwidthAllowanceCritical',
            expr: '100 * sum by (job) (vultr_instance_bandwidth_tx_bytes_total{%(filteringSelector)s}) / (sum by (job) (vultr_instance_bandwidth_allowed_bytes{%(filteringSelector)s}) > 0) > %(alertsBandwidthUsageCritical)s' % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Vultr instances have nearly used their pooled bandwidth allowance.',
              description: 'Vultr instances have used {{ printf "%%.0f" $value }}%% of their pooled outbound bandwidth allowance this billing period, above the threshold of %(alertsBandwidthUsageCritical)s%%. Overage charges may apply.' % this.config,
            },
          },
          {
            alert: 'VultrInstanceGPUHighTemperature',
            expr: 'vultr_instance_gpu_temperature_celsius{%(filteringSelector)s} > %(alertsGPUTemperatureWarning)s' % this.config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Vultr instance GPU temperature is high.',
              description: 'GPU temperature on Vultr instance {{ $labels.label }} in {{ $labels.region }} is {{ printf "%%.0f" $value }}°C, above the threshold of %(alertsGPUTemperatureWarning)s°C.' % this.config,
            },
          },
        ],
      },
    ],
  },
}
