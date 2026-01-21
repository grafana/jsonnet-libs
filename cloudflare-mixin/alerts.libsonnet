{
  new(this): {
    groups: [
      {
        name: 'cloudflare-alerts',
        rules: [
          {
            alert: 'CloudflareHighThreatCount',
            expr: |||
              sum without (instance) (increase(cloudflare_zone_threats_total{%(filteringSelector)s}[5m])) > %(alertsHighThreatCount)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are detected threats targeting the zone.',
              description: 'The number of detected threats targeting the zone {{$labels.zone}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighThreatCount)s.' % this.config,
            },
          },
          {
            alert: 'CloudflareHighRequestRate',
            expr: |||
              sum without (instance) (100 * (rate(cloudflare_zone_requests_total{%(filteringSelector)s}[10m]) / clamp_min(rate(cloudflare_zone_requests_total{%(filteringSelector)s}[50m] offset 10m), 1))) > %(alertsHighRequestRate)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A high spike in requests is occurring which may indicate an attack or unexpected load.',
              description: 'The rate of requests to {{$labels.zone}} is {{ printf "%%.0f" $value }}%% of the prior 50 minute baseline which is above the threshold of %(alertsHighRequestRate)s%%.' % this.config,
            },
          },
          {
            alert: 'CloudflareHighHTTPErrorCodes',
            expr: |||
              sum without (instance) (increase(cloudflare_zone_requests_status{%(filteringSelector)s}[5m])) > %(alertsHighHTTPErrorCodeCount)s
            ||| % (this.config { filteringSelector: if this.config.filteringSelector != '' then this.config.filteringSelector + ',status=~"4.*|5.*"' else 'status=~"4.*|5.*"' }),
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A high number of 4xx or 5xx HTTP status codes are occurring.',
              description: 'The number of {{$labels.status}} HTTP status codes occurring in the zone {{$labels.zone}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighHTTPErrorCodeCount)s.' % this.config,
            },
          },
          {
            alert: 'CloudflareUnhealthyPools',
            expr: |||
              sum without (instance, load_balancer_name) (cloudflare_zone_pool_health_status{%(filteringSelector)s}) == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are unhealthy pools.',
              description: 'The pool {{$labels.pool_name}} in zone {{$labels.zone}} is currently down and unhealthy.',
            },
          },
          {
            alert: 'CloudflareMetricsDown',
            expr: |||
              up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Cloudflare metrics are down.',
              description: 'Grafana is no longer receiving metrics for the Cloudflare integration from instance {{$labels.instance}}.',
            },
          },
        ],
      },
    ],
  },
}
