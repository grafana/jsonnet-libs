{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'windows-active-directory-alerts',
        rules: [
          {
            alert: 'WindowsActiveDirectoryHighBindOperationsWarning',
            expr: |||
              sum without (bind_method, agent_hostname) (increase(windows_ad_binds_total[5m])) / clamp_min(sum without (bind_method, agent_hostname) (increase(windows_ad_binds_total[10m])), 1) * 100 > %(alertsWarningHighBindOperations)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high percentage of bind operations. This may indicate brute force attacks or configuration issues.',
              description:
                (
                  'The number of bind operations on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is above the threshold of %(alertsWarningHighBindOperations)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'WindowsActiveDirectoryHighPasswordChangesWarning',
            expr: |||
              increase(windows_ad_sam_password_changes_total[5m]) > %(alertsWarningHighPasswordChanges)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of password changes. This may indicate unauthorized changes or attacks.',
              description:
                (
                  'The number of password changes on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsWarningHighPasswordChanges)s'
                ) % $._config,
            },
          },
          {
            alert: 'WindowsActiveDirectoryMetricsDown',
            expr: |||
              up{job="%(alertsCriticalMetricsDownJobName)s"} == 0
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
