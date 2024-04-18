{
  new(this): {

    groups: [
      {
        name: this.config.uid,
        rules: [
          {
            alert: 'VeleroBackupFailure',
            expr: |||
              increase(velero_backup_failure_total{%(filteringSelector)s}[5m]) > %(alertsHighBackupFailure)s

            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Velero backup failures detected.',
              description: |||
                Backup failures detected on {{ $labels.instance }}. This could lead to data loss or inability to recover in case of a disaster.
              ||| % this.config,
            },
          },
          {
            alert: 'VeleroHighBackupDuration',
            expr: |||
              histogram_quantile(0.5, sum(rate(velero_backup_duration_seconds_bucket{%(filteringSelector)s}[5m])) by (le)) > %(alertsHighBackupDuration)s * avg_over_time(histogram_quantile(0.5, sum(rate(velero_backup_duration_seconds_bucket{%(filteringSelector)s}[5m])) by (le))[48h:5m])
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Velero backups taking longer than usual.',
              description: |||
                Backup duration on {{ $labels.instance }} is higher than the average duration over the past 48 hours. This could indicate performance issues or network congestion. The current value is {{ $value | printf "%%.2f" }} seconds.
              ||| % this.config,
            },
          },
          {
            alert: 'VeleroHighRestoreFailureRate',
            expr: |||
              increase(velero_restore_failed_total{%(filteringSelector)s}[5m]) > %(alertsHighRestoreFailureRate)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Velero restore failures detected.',
              description: |||
                Restore failures detected on {{ $labels.instance }}. This could prevent timely data recovery and business continuity.
              ||| % this.config,
            },
          },
          {
            alert: 'VeleroUpStatus',
            expr: |||
              up{%(filteringSelector)s} != %(alertsVeleroUpStatus)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Velero is down.',
              description: |||
                Cannot find any metrics related to Velero on {{ $labels.instance }}. This may indicate further issues with Velero or the scraping agent. 
              ||| % this.config,
            },
          },
        ],
      },
    ],
  },
}
