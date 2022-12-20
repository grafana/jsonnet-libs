{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'windows-alerts',
        rules: [
          {
            alert: 'WindowsCPUHigh',
            expr: |||
              100 - (avg by (instance) (rate(windows_cpu_time_total{mode="idle"}[2m])) * 100) > %(alertsCPUThresholdWarning)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High CPU usage on Windows host.',
              description: |||
                CPU usage on host {{ $labels.instance }} is above %(alertsCPUThresholdWarning)s%%. The currect value is {{ $value | printf "%%.2f%%" }}%%.
              ||| % $._config,
            },
          },
          {
            alert: 'WindowsMemoryHigh',
            expr: |||
              100 - ((windows_os_physical_memory_free_bytes / windows_cs_physical_memory_bytes) * 100) > %(alertMemoryUsageThresholdCritical)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'High memory usage on Windows host.',
              description: |||
                Memory usage on host {{ $labels.instance }} is above %(alertMemoryUsageThresholdCritical)s%%. The currect value is {{ $value | printf "%%.2f%%" }}%%.
              ||| % $._config,
            },
          },
          {
            alert: 'WindowsDiskUsageHigh',
            expr: |||
              100 - ((windows_logical_disk_free_bytes ) / (windows_logical_disk_size_bytes)) * 100  > %(alertDiskUsageThresholdCritical)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Disk is almost full on Windows host.',
              description: |||
                Volume {{ $labels.volume }} is almost full on host {{ $labels.instance }}, more than %(alertDiskUsageThresholdCritical)s%% of space is used. The currect volume utilization is {{ $value | printf "%%.2f%%" }}%%.
              ||| % $._config,
            },
          },
          {
            alert: 'WindowsServiceNotHealthy',
            expr: |||
              windows_service_status{status!~"starting|stopping|ok"} > 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Windows service is not healthy.',
              description: |||
                Windows service {{ $labels.name }} is not in healthy state, currently in '{{ $labels.status }}'.
              ||| % $._config,
            },
          },
        ],
      },
    ],
  },
}
