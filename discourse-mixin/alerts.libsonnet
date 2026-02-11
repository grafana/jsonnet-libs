{
  new(this): {
    groups: [
      {
        name: this.config.uid + '-alerts',
        rules: [
          {
            alert: 'DiscourseHigh5xxErrors',
            expr: |||
              100 * rate(discourse_http_requests{%(filteringSelector5xx)s}[5m]) / on() group_left() (sum(rate(discourse_http_requests[5m])) by (instance)) > %(alertsCritical5xxResponses)s
            ||| % this.config { filteringSelector5xx: if this.config.filteringSelector != '' then 'status=~"5..",' + this.config.filteringSelector else 'status=~"5.."' },
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'More than %(alertsCritical5xxResponses)s%% of all requests result in a 5XX.' % this.config,
              description:
                ('{{ printf "%%.2f" $value }}%% of all requests are resulting in 500 status codes, ' +
                 'which is above the threshold %(alertsCritical5xxResponses)s%%, ' +
                 'indicating a potentially larger issue for {{$labels.instance}}') % this.config,
            },
          },
          {
            alert: 'DiscourseHigh4xxErrors',
            expr: |||
              100 * rate(discourse_http_requests{%(filteringSelector4xx)s}[5m]) / on() group_left() (sum(rate(discourse_http_requests[5m])) by (instance)) > %(alertsWarning4xxResponses)s
            ||| % this.config { filteringSelector4xx: if this.config.filteringSelector != '' then 'status=~"4..",' + this.config.filteringSelector else 'status=~"4.."' },
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'More than %(alertsWarning4xxResponses)s%% of all requests result in a 4XX.' % this.config,
              description:
                ('{{ printf "%%.2f" $value }}%% of all requests are resulting in 400 status code, ' +
                 'which is above the threshold %(alertsWarning4xxResponses)s%%, ' +
                 'indicating a potentially larger issue for {{$labels.instance}}') % this.config,
            },
          },
        ],
      },
    ],
  },
}
