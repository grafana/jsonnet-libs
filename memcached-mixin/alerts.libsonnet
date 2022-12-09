{
  prometheusAlerts+: {
    groups+: [
      {
        name: 'memcached',
        rules: [
          {
            alert: 'MemcachedDown',
            expr: |||
              memcached_up == 0
            |||,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: |||
                Memcached Instance {{ $labels.job }} / {{ $labels.instance }} is down for more than 15mins.
              |||,
              description: 'Memcached Instance {{ $labels.job }} / {{ $labels.instance }} is down for more than 15mins.',
              summary: 'Memcached instance is down.'
            },
          },
          {
            alert: 'MemcachedConnectionLimitApproaching',
            expr: |||
              (memcached_current_connections / memcached_max_connections * 100) > 80
            |||,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: |||
                Memcached Instance {{ $labels.job }} / {{ $labels.instance }} connection usage is at {{ printf "%0.0f" $value }}% for at least 15m.
              |||,
              description: 'Memcached Instance {{ $labels.job }} / {{ $labels.instance }} connection usage is at {{ printf "%0.0f" $value }}% for at least 15m.',
              summary: 'Memcached max connection limit is approaching.'
            },
          },
          {
            alert: 'MemcachedConnectionLimitApproaching',
            expr: |||
              (memcached_current_connections / memcached_max_connections * 100) > 95
            |||,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: |||
                Memcached Instance {{ $labels.job }} / {{ $labels.instance }} connection usage is at {{ printf "%0.0f" $value }}% for at least 15m.
              |||,
              description: 'Memcached Instance {{ $labels.job }} / {{ $labels.instance }} connection usage is at {{ printf "%0.0f" $value }}% for at least 15m.',
              summary: 'Memcached connections at critical level.'
            },
          },
        ],
      },
    ],
  },
}
