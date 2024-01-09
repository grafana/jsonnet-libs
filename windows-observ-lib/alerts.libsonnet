{
  new(this): {
    local ADAlerts = [
      {
        alert: 'WindowsActiveDirectoryHighPendingReplicationOperations',
        expr: |||
          windows_ad_replication_pending_operations{%(filteringSelector)s} >= %(alertsHighPendingReplicationOperations)s 
        ||| % this.config,
        'for': '10m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'There is a high number of pending replication operations in Active Directory. A high number of pending operations sustained over a period of time can indicate a problem with replication.',
          description:
            (
              'The number of pending replication operations on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is above the threshold of %(alertsHighPendingReplicationOperations)s.'
            ) % this.config,
        },
      },
      {
        alert: 'WindowsActiveDirectoryHighReplicationSyncRequestFailures',
        expr: |||
          increase(windows_ad_replication_sync_requests_schema_mismatch_failure_total{%(filteringSelector)s}[5m]) > %(alertsHighReplicationSyncRequestFailures)s 
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'critical',
        },
        annotations: {
          summary: 'There are a number of replication synchronization request failures. These can cause authentication failures, outdated information being propagated across domain controllers, and potentially data loss or inconsistencies.',
          description:
            (
              'The number of replication sync request failures on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is above the threshold of %(alertsHighReplicationSyncRequestFailures)s.'
            ) % this.config,
        },
      },
      {
        alert: 'WindowsActiveDirectoryHighPasswordChanges',
        expr: |||
          increase(windows_ad_sam_password_changes_total{%(filteringSelector)s}[5m]) > %(alertsHighPasswordChanges)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'There is a high number of password changes. This may indicate unauthorized changes or attacks.',
          description:
            (
              'The number of password changes on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighPasswordChanges)s'
            ) % this.config,
        },
      },
      {
        alert: 'WindowsActiveDirectoryMetricsDown',
        expr: |||
          up{job="%(alertsMetricsDownJobName)s"} == 0
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'critical',
        },
        annotations: {
          summary: 'Windows Active Directory metrics are down.',
          description:
            (
              'There are no available metrics for Windows Active Directory integration from instance {{$labels.instance}}.'
            ) % this.config,
        },
      },
    ],
    groups: [
      {
        name: 'windows-alerts-' + this.config.uid,
        rules: [
          {
            alert: 'WindowsCPUHighUsage',
            expr: |||
              100 - (avg without (mode, core) (rate(windows_cpu_time_total{%(filteringSelector)s, mode="idle"}[2m])) * 100) > %(alertsCPUThresholdWarning)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High CPU usage on Windows host.',
              description: |||
                CPU usage on host {{ $labels.instance }} is above %(alertsCPUThresholdWarning)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'WindowsMemoryHighUtilization',
            expr: |||
              100 - ((windows_os_physical_memory_free_bytes{%(filteringSelector)s}
              /
              windows_cs_physical_memory_bytes{%(filteringSelector)s}) * 100) > %(alertMemoryUsageThresholdCritical)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'High memory usage on Windows host.',
              description: |||
                Memory usage on host {{ $labels.instance }} is above %(alertMemoryUsageThresholdCritical)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'WindowsDiskAlmostOutOfSpace',
            expr: |||
              100 - ((windows_logical_disk_free_bytes{%(filteringSelector)s} ) / (windows_logical_disk_size_bytes{%(filteringSelector)s})) * 100  > %(alertDiskUsageThresholdCritical)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Disk is almost full on Windows host.',
              description: |||
                Volume {{ $labels.volume }} is almost full on host {{ $labels.instance }}, more than %(alertDiskUsageThresholdCritical)s%% of space is used. The current volume utilization is {{ $value | printf "%%.2f" }}%%.
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
          // enable diskdrive collector for this alert
          {
            alert: 'WindowsDiskDriveNotHealthy',
            expr: |||
              windows_disk_drive_status{%(filteringSelector)s, status="OK"} != 1
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Windows physical disk is not healthy.',
              description: |||
                Windows disk {{ $labels.name }} is not in healthy state, currently in '{{ $labels.status }}' status.
              ||| % this.config,
            },
          },
          {
            alert: 'WindowsNTPClientDelay',
            expr: |||
              windows_time_ntp_round_trip_delay_seconds{%(filteringSelector)s} > 1
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'NTP client delay.',
              description: |||
                'Round-trip time of NTP client on instance {{ $labels.instance }} is greater than 1 second. Delay is {{ $value }} sec.'
              ||| % this.config,
            },
          },
          {
            alert: 'WindowsNTPTimeOffset',
            expr: |||
              windows_time_computed_time_offset_seconds{%(filteringSelector)s} > 1
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'NTP time offset is too large.',
              description: |||
                'NTP time offset for instance {{ $labels.instance }} is greater than 1 second. Offset is {{ $value }} sec.'
              ||| % this.config,
            },
          },
        ] + if this.config.enableADDashboard then ADAlerts else [],
      },
    ],
  },
}
