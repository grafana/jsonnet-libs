{
  new(this): {

    groups: [
      {
        name: this.config.uid,
        rules: [
          {
            alert: 'PGBouncerHighNumberWaitingConnections',
            expr: |||
              pgbouncer_pools_client_waiting_connections{%(filteringSelector)s} > %(alertsHighClientWaitingConnections)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'May indicate a bottleneck in connection pooling where too many clients are waiting for available server connections.',
              description: |||
                The number of clients waiting for connections on {{ $labels.instance }} is now above %(alertsHighClientWaitingConnections)s. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
          {
            alert: 'PGBouncerHighWaitTime',
            expr: |||
              pgbouncer_pools_client_maxwait_seconds{%(filteringSelector)s} > %(alertsHighClientWaitTime)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Clients are experiencing significant delays, which could indicate issues with connection pool saturation or server performance.',
              description: |||
                The wait time for user connections on {{ $labels.instance }}, is above %(alertsHighClientWaitTime)s. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
          {
            alert: 'PGBouncerServerSaturationWarning',
            expr: |||
              100 * (sum without (database, user) (pgbouncer_pools_server_active_connections{%(filteringSelector)s} + pgbouncer_pools_server_idle_connections{%(filteringSelector)s} + pgbouncer_pools_server_used_connections{%(filteringSelector)s}) / clamp_min(pgbouncer_config_max_user_connections{%(filteringSelector)s},1)) > %(alertsHighServerConnectionSaturationWarning)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'PGBouncer is nearing user connection capacity.',
              description: |||
                User connection capacity on {{ $labels.instance }}, is above %(alertsHighServerConnectionSaturationWarning)s%%. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
          {
            alert: 'PGBouncerHighSaturationCritical',
            expr: |||
              100 * (sum without (database, user) (pgbouncer_pools_server_active_connections{%(filteringSelector)s} + pgbouncer_pools_server_idle_connections{%(filteringSelector)s} + pgbouncer_pools_server_used_connections{%(filteringSelector)s}) / clamp_min(pgbouncer_config_max_user_connections{%(filteringSelector)s},1)) > %(alertsHighServerConnectionSaturationCritical)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'PGBouncer is nearing critical levels of user connection capacity.',
              description: |||
                User connection capacity on {{ $labels.instance }}, is above %(alertsHighServerConnectionSaturationCritical)s%%. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
        ],
      },
    ],
  },
}
