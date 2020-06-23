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
            },
          },
        ],
      },
    ],
  },
}
