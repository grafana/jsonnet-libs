{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'cloudflare-alerts',
        rules: [
          {
            alert: 'CloudflareHighThreatCount',
            expr: |||
              sum without (instance) (increase(cloudflare_zone_threats_total[5m])) > %(alertsHighThreatCount)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are detected threats targeting the zone.',
              description:
                (
                  'The number of detected threats targeting the zone {{$labels.zone}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighThreatCount)s.'
                ) % $._config,
            },
          },
          {
            alert: 'CloudflareHighRequestRate',
            expr: |||
              sum without (instance) (100 * (rate(cloudflare_zone_requests_total[10m]) / clamp_min(rate(cloudflare_zone_requests_total[50m] offset 10m), 1))) > %(alertsHighRequestRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A high spike in requests is occurring which may indicate an attack or unexpected load.',
              description:
                (
                  'The rate of requests to {{$labels.zone}} is {{ printf "%%.0f" $value }}%%s of the prior 50 minute baseline which is above the threshold of %(alertsHighRequestRate)s%%s.'
                ) % $._config,
            },
          },
          {
            alert: 'CloudflareHighHTTPErrorCodes',
            expr: |||
              sum without (instance) (increase(cloudflare_zone_requests_status{status=~"4.*|5.*"}[5m])) > %(alertsHighHTTPErrorCodeCount)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A high number of 4xx or 5xx HTTP status codes are occurring.',
              description:
                (
                  'The number of {{$labels.status}} HTTP status codes occurring in the zone {{$labels.zone}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighHTTPErrorCodeCount)s.'
                ) % $._config,
            },
          },
          {
            alert: 'CloudflareUnhealthyPools',
            expr: |||
              sum without (instance, load_balancer_name) (cloudflare_zone_pool_health_status) == 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are unhealthy pools.',
              description:
                (
                  'The pool {{$labels.pool_name}} in zone {{$labels.zone}} is currently down and unhealthy.'
                ) % $._config,
            },
          },
          {
            alert: 'CloudflareMetricsDown',
            expr: |||
              up{job="integrations/cloudflare"} == 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Cloudflare metrics are down.',
              description:
                (
                  'Grafana is no longer receiving metrics for the Cloudflare integration.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
