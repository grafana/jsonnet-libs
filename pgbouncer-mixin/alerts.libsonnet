{
  new(this): {

    groups: [
      {
        name: this.config.uid,
        rules: [
          {
            alert: 'HighNumberClientWaitingConnections',
            expr: |||
              pgbouncer_pools_client_waiting_connections > %(alertsHighClientWaitingConnections)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'May indicate a bottleneck in connection pooling, where too many clients are waiting for available server connections,',
              description: |||
                 The number of clients waiting connections on {{ $labels.instance }} is now above %(alertsHighClientWaitingConnections)s. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
          {
            alert: 'HighClientWaitTime',
            expr: |||
              pgbouncer_pools_client_maxwait_seconds > %(alertsHighClientWaitTime)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Clients are experiencing significant delays, which could indicate issues with connection pool saturation or server performance.',
              description: |||
                User connection capacity on {{ $labels.instance }}, is above %(alertsHighClientWaitTime)s. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
						{
            alert: 'HighServerConnectionSaturationWarning',
            expr: |||
              100 * (sum without (database, user) (pgbouncer_pools_server_active_connections + pgbouncer_pools_server_idle_connections + pgbouncer_pools_server_used_connections) / clamp_min(pgbouncer_config_max_user_connections,1)) > %(alertsHighServerConnectionSaturationWarning)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'PGBouncer is nearing user connection capacity.',
              description: |||
                 'User connection capacity on {{ $labels.instance }}, is above %(alertsHighServerConnectionSaturationWarning)s%%. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
					{
            alert: 'HighServerConnectionSaturationCritical',
            expr: |||
              100 * (sum without (database, user) (pgbouncer_pools_server_active_connections + pgbouncer_pools_server_idle_connections + pgbouncer_pools_server_used_connections) / clamp_min(pgbouncer_config_max_user_connections,1)) > %(alertsHighServerConnectionSaturationCritical)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'PGBouncer is nearing critical levels of user connection capacity.',
              description: |||
                'User connection capacity on {{ $labels.instance }}, is above %(alertsHighServerConnectionSaturationCritical)s%%. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
					{
            alert: 'HighNetworkTraffic',
            expr: ||| 
             100 * (increase(pgbouncer_stats_received_bytes_total[5m]) / 
clamp_min(avg_over_time(pgbouncer_stats_received_bytes_total[10m]),1)) > %(alertsHighNetworkTraffic)s
            ||| % this.config,
            'for': '10m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A significant spike over the average peak in network traffic may indicate unusual activity or an increase in load.',
              description: |||
                An increase in network traffic was detected on {{ $labels.instance }}, the increase is above %(alertsHighNetworkTraffic)s%% of the average in the past 10 minutes. The current increase detected is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          }
          },
        ],
      },
    ],
  },
}
