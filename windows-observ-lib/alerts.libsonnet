{
  new(this): {
    // TODO: add scheduled tasks failed alerts,
    // time alerts, ntp delay alerts, disk running out of space predict alerts
    groups: [
      {
        name: 'windows-alerts-' + this.config.uid,
        rules: [
          {
            alert: 'WindowsCPUHigh',
            expr: |||
              100 - (avg without (mode, core) (rate(windows_cpu_time_total{%(filteringSelector)s, mode="idle"}[2m])) * 100) > %(alertsCPUThresholdWarning)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High CPU usage on Windows host.',
              description: |||
                CPU usage on host {{ $labels.instance }} is above %(alertsCPUThresholdWarning)s%%. The currect value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'WindowsMemoryHigh',
            expr: |||
              100 - ((windows_os_physical_memory_free_bytes{%(filteringSelector)s}
              /
              windows_cs_physical_memory_bytes{%(filteringSelector)s}) * 100) > %(alertMemoryUsageThresholdCritical)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'High memory usage on Windows host.',
              description: |||
                Memory usage on host {{ $labels.instance }} is above %(alertMemoryUsageThresholdCritical)s%%. The currect value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'WindowsDiskUsageHigh',
            expr: |||
              100 - ((windows_logical_disk_free_bytes{%(filteringSelector)s} ) / (windows_logical_disk_size_bytes{%(filteringSelector)s})) * 100  > %(alertDiskUsageThresholdCritical)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Disk is almost full on Windows host.',
              description: |||
                Volume {{ $labels.volume }} is almost full on host {{ $labels.instance }}, more than %(alertDiskUsageThresholdCritical)s%% of space is used. The currect volume utilization is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'WindowsServiceNotHealthy',
            expr: |||
              windows_service_status{%(filteringSelector)s, status!~"starting|stopping|ok"} > 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Windows service is not healthy.',
              description: |||
                Windows service {{ $labels.name }} is not in healthy state, currently in '{{ $labels.status }}'.
              ||| % this.config,
            },
          },
        ],
      },
    ],
  },
}
