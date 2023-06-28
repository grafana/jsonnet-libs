{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'VarnishCacheAlerts',
        rules: [
          {
            alert: 'VarnishCacheAlertsLowCacheHitRate',
            expr: |||
              increase(varnish_main_cache_hit[10m]) / (clamp_min((increase(varnish_main_cache_hit[10m]) + increase(varnish_main_cache_miss[10m])), 1)) * 100 < %(VarnishCacheAlertsWarningCacheHitRate)s and (increase(varnish_main_cache_hit[10m]) + increase(varnish_main_cache_miss[10m]) > 0)
            ||| % $._config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Cache is not answering a sufficient percent of read requests.',
              description:
                (
                  'The Cache hit rate is {{ printf "%%.0f" $value }} percent over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(VarnishCacheAlertsWarningCacheHitRate)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'VarnishCacheAlertsHighCacheEvictionRate',
            expr: |||
              increase(varnish_main_n_lru_nuked[5m]) > %(VarnishCacheAlertsCriticalCacheEviction)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The cache is evicting objects too fast.',
              description:
                (
                  'The Cache has evicted {{ printf "%.0f" $value }} over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(VarnishCacheAlertsCriticalCacheEviction)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'VarnishCacheAlertsHighSaturation',
            expr: |||
              varnish_main_thread_queue_len > %(VarnishCacheAlertsCriticalSaturation)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are too many threads in queue, Varnish is saturated and responses are slowed.',
              description:
                (
                  'The thread queue length is {{ printf "%.0f" $value }} over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(VarnishCacheAlertsCriticalSaturation)s.'
                ) % $._config,
            },
          },
          {
            alert: 'VarnishCacheAlertsSessionsDropping',
            expr: |||
              increase(varnish_main_sessions{type="dropped"}[5m]) > %(VarnishCacheAlertsCriticalSessionsDropped)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Incoming requests are being dropped due to a lack of free worker threads.',
              description:
                (
                  'The amount of sessions dropped is {{ printf "%.0f" $value }} over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(VarnishCacheAlertsSessionsDropping)s.'
                ) % $._config,
            },
          },
          {
            alert: 'VarnishCacheAlertsBackendFailure',
            expr: |||
              increase(varnish_main_backend_fail[5m]) > %(VarnishCacheAlertsCriticalBackendFailure)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There was a failure to connect to the backend.',
              description:
                (
                  'Backend failure is {{ printf "%.0f" $value }} over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(VarnishCacheAlertsCriticalBackendFailure)s.'
                ) % $._config,
            },
          },
          {
            alert: 'VarnishCacheAlertsBackendUnhealthy',
            expr: |||
              increase(varnish_main_backend_unhealthy[5m]) > %(VarnishCacheAlertsCriticalBackendUnhealthy)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Backend has been marked as unhealthy due to slow 200 response.',
              description:
                (
                  'Unhealthy backend is {{ printf "%.0f" $value }} over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(VarnishCacheAlertsCriticalBackendUnhealthy)s.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
