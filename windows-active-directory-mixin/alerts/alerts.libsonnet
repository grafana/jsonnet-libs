{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'windows-active-directory-alerts',
        rules: [
          {
            alert: 'WindowsActiveDirectoryHighPendingReplicationOperations',
            expr: |||
              windows_ad_replication_pending_operations >= %(alertsHighPendingReplicationOperations)s 
            ||| % $._config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of pending replication operations in Active Directory. A high number of pending operations sustained over a period of time can indicate a problem with replication.',
              description:
                (
                  'The number of pending replication operations on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is above the threshold of %(alertsHighPendingReplicationOperations)s.'
                ) % $._config,
            },
          },
          {
            alert: 'WindowsActiveDirectoryHighReplicationSyncRequestFailures',
            expr: |||
              increase(windows_ad_replication_sync_requests_schema_mismatch_failure_total[5m]) > %(alertsHighReplicationSyncRequestFailures)s 
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a number of replication synchronization request failures. These can cause authentication failures, outdated information being propagated across domain controllers, and potentially data loss or inconsistencies.',
              description:
                (
                  'The number of replication sync request failures on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is above the threshold of %(alertsHighReplicationSyncRequestFailures)s.'
                ) % $._config,
            },
          },
          {
            alert: 'WindowsActiveDirectoryHighPasswordChanges',
            expr: |||
              increase(windows_ad_sam_password_changes_total[5m]) > %(alertsHighPasswordChanges)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of password changes. This may indicate unauthorized changes or attacks.',
              description:
                (
                  'The number of password changes on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighPasswordChanges)s'
                ) % $._config,
            },
          },
          {
            alert: 'WindowsActiveDirectoryMetricsDown',
            expr: |||
              up{job="%(alertsMetricsDownJobName)s"} == 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Windows Active Directory metrics are down.',
              description:
                (
                  'Grafana is no longer receiving metrics for the Windows Active Directory integration from instance {{$labels.instance}}.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
