{
  prometheusAlerts+:: {
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
              description: 'Memcached instance {{ $labels.job }} / {{ $labels.instance }} is down for more than 15 minutes.',
              summary: 'Memcached instance is down.',
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
              description: 'Memcached instance {{ $labels.job }} / {{ $labels.instance }} connection usage is at {{ printf "%0.0f" $value }}% for at least 15 minutes.',
              summary: 'Memcached max connection limit is approaching.',
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
              description: 'Memcached instance {{ $labels.job }} / {{ $labels.instance }} connection usage is at {{ printf "%0.0f" $value }}% for at least 15 minutes.',
              summary: 'Memcached connections at critical level.',
            },
          },
          {
            alert: 'MemcachedOutOfMemoryErrors',
            expr: |||
              sum without (slab) (rate(memcached_slab_items_outofmemory_total[5m])) > 0
            |||,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              description: 'Memcached instance {{ $labels.job }} / {{ $labels.instance }} has OutOfMemory errors for at least 15 minutes, current rate is {{ printf "%0.0f" $value }}',
              summary: 'Memcached has OutOfMemory errors.',
            },
          },
        ],
      },
    ],
  },
}
