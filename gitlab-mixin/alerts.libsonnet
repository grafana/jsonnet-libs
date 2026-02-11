{
  new(this): {
    groups+: [
      {
        name: 'GitLabAlerts',
        rules: [
          {
            alert: 'GitLabHighJobRegistrationFailures',
            expr: |||
              100 * rate(job_register_attempts_failed_total{%(filteringSelector)s}[5m]) / rate(job_register_attempts_total{%(filteringSelector)s}[5m]) 
              > %(alertsWarningRegistrationFailures)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Large percentage of failed attempts to register a job.',
              description:
                ('{{ printf "%%.2f" $value }}%% of job registrations have failed on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsWarningRegistrationFailures)s%%.') % this.config,
            },
          },
          {
            alert: 'GitLabHighRunnerAuthFailure',
            expr: |||
              100 * sum by (instance) (rate(gitlab_ci_runner_authentication_failure_total{%(filteringSelector)s}[5m]))  / 
              (sum by (instance) (rate(gitlab_ci_runner_authentication_success_total{%(filteringSelector)s}[5m]))  + sum by (instance) (rate(gitlab_ci_runner_authentication_failure_total{%(filteringSelector)s}[5m])))
              > %(alertsWarningRunnerAuthFailures)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Large percentage of runner authentication failures.',
              description:
                ('{{ printf "%%.2f" $value }}%% of GitLab runner authentication attempts are failing on {{$labels.instance}}, ' +
                 'which is above the threshold of %(alertsWarningRunnerAuthFailures)s%%.') % this.config,
            },
          },
          {
            alert: 'GitLabHigh5xxResponses',
            expr: |||
              100 * sum by (instance, status) (rate(http_requests_total{%(filteringSelector5xx)s}[5m])) / sum by (instance) (rate(http_requests_total{%(filteringSelector)s}[5m])) 
              > %(alertsCritical5xxResponses)s
            ||| % this.config { filteringSelector5xx: if this.config.filteringSelector != '' then this.config.filteringSelector + ',status=~"5[0-9][0-9]"' else 'status=~"5[0-9][0-9]"' },
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Large rate of HTTP 5XX errors.',
              description:
                ('{{ printf "%%.2f" $value }}%% of all requests returned 5XX HTTP responses, ' +
                 'which is above the threshold %(alertsCritical5xxResponses)s%%, ' +
                 'indicating a system issue on {{$labels.instance}}.') % this.config,
            },
          },
          {
            alert: 'GitLabHigh4xxResponses',
            expr: |||
              100 * sum by (instance, status) (rate(http_requests_total{%(filteringSelector4xx)s}[5m])) / sum by (instance) (rate(http_requests_total{%(filteringSelector)s}[5m]))
              > %(alertsWarning4xxResponses)s
            ||| % this.config { filteringSelector4xx: if this.config.filteringSelector != '' then this.config.filteringSelector + ',status=~"4[0-9][0-9]"' else 'status=~"4[0-9][0-9]"' },
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Large rate of HTTP 4XX errors.',
              description:
                ('{{ printf "%%.2f" $value }}%% of all requests returned 4XX HTTP responses, ' +
                 'which is above the threshold %(alertsWarning4xxResponses)s%%, ' +
                 'indicating many failed requests on {{$labels.instance}}.') % this.config,
            },
          },
        ],
      },
    ],
  },
}
