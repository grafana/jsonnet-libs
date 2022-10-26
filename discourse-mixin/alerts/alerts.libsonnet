{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'DiscourseAlerts',
        rules: [
          {
            alert: 'DiscourseRequestsHigh5XXs',
            expr: |||
              100 * rate(discourse_http_requests{status="500"}[5m]) / on() group_left() (sum(rate(discourse_http_requests[5m])) by (instance)) > %(alertsCritical5xxResponses)s
            ||| % $._config,
            'for': '0',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'More than 10% of all requests result in a 5XX. Indicates an issue with the service.',
              description:
                ('{{ printf "%%.2f" $value }}%% of all requests are resulting in 400 status code.' +
                 'which is above the threshold %(alertsCritical5xxResponses)s%%,' +
                 'indicating a potentially larger issue for {{$labels.instance}}') % $._config,
            },
          },
          {
            alert: 'DiscourseRequestsHigh4XXs',
            expr: |||
              100 * rate(discourse_http_requests{status=~"^4.*"}[5m]) / on() group_left() (sum(rate(discourse_http_requests[5m])) by (instance)) > %(alertsError4xxResponses)s
            ||| % $._config,
            'for': '0',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'More than 30% of all requests result in a 4XX. Unusually high error rates.',
              description:
                ('{{ printf "%%.2f" $value }}%% of all requests are resulting in 400 status code.' +
                 'which is above the threshold %(alertsError4xxResponses)s%%,' +
                 'indicating a potentially larger issue for {{$labels.instance}}') % $._config,
            },
          },
        ],
      },
    ],
  },
}
