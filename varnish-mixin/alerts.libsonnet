{
  new(this): {
    local config = this.config,

    groups: [
      {
        name: 'varnish-cache',
        rules: [
          {
            alert: 'VarnishCacheLowCacheHitRate',
            expr: |||
              increase(varnish_main_cache_hit{%(filteringSelector)s}[10m]) / (clamp_min((increase(varnish_main_cache_hit{%(filteringSelector)s}[10m]) + increase(varnish_main_cache_miss{%(filteringSelector)s}[10m])), 1)) * 100 < %(alertsWarningCacheHitRate)s and (increase(varnish_main_cache_hit{%(filteringSelector)s}[10m]) + increase(varnish_main_cache_miss{%(filteringSelector)s}[10m]) > 0)
            ||| % config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Cache is not answering a sufficient percentage of read requests.',
              description:
                (
                  'The Cache hit rate is {{ printf "%%.0f" $value }} percent over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is below the threshold of %(alertsWarningCacheHitRate)s percent.'
                ) % config,
            },
          },
          {
            alert: 'VarnishCacheHighMemoryUsage',
            expr: |||
              (varnish_sma_g_bytes{%(filteringSelector)s,type="s0"} / (varnish_sma_g_bytes{%(filteringSelector)s,type="s0"} + varnish_sma_g_space{%(filteringSelector)s,type="s0"})) * 100 > %(alertsWarningHighMemoryUsage)s
            ||| % config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Varnish Cache is running low on available memory.',
              description:
                (
                  'Current Memory Usage is {{ printf "%%.0f" $value }} percent on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningHighMemoryUsage)s percent.'
                ) % config,
            },
          },
          {
            alert: 'VarnishCacheHighCacheEvictionRate',
            expr: |||
              increase(varnish_main_n_lru_nuked{%(filteringSelector)s}[5m]) > %(alertsCriticalCacheEviction)s
            ||| % config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The cache is evicting too many objects.',
              description:
                (
                  'The Cache has evicted {{ printf "%%.0f" $value }} objects over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalCacheEviction)s.'
                ) % config,
            },
          },
          {
            alert: 'VarnishCacheHighSaturation',
            expr: |||
              varnish_main_thread_queue_len{%(filteringSelector)s} > %(alertsWarningHighSaturation)s
            ||| % config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are too many threads in queue, Varnish is saturated and responses are slowed.',
              description:
                (
                  'The thread queue length is {{ printf "%%.0f" $value }} over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningHighSaturation)s.'
                ) % config,
            },
          },
          {
            alert: 'VarnishCacheSessionsDropping',
            expr: |||
              increase(varnish_main_sessions{%(filteringSelector)s,type="dropped"}[5m]) > %(alertsCriticalSessionsDropped)s
            ||| % config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Incoming requests are being dropped due to a lack of free worker threads.',
              description:
                (
                  'The amount of sessions dropped is {{ printf "%%.0f" $value }} over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalSessionsDropped)s.'
                ) % config,
            },
          },
          {
            alert: 'VarnishCacheBackendUnhealthy',
            expr: |||
              increase(varnish_main_backend_unhealthy{%(filteringSelector)s}[5m]) > %(alertsCriticalBackendUnhealthy)s
            ||| % config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Backend has been marked as unhealthy due to slow 200 responses.',
              description:
                (
                  'The amount of unhealthy backend statuses detected is {{ printf "%%.0f" $value }} over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalBackendUnhealthy)s.'
                ) % config,
            },
          },
        ],
      },
    ],
  },
}
