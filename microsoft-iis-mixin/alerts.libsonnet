{
  new(this): {
    groups: [
      {
        name: 'MicrosoftIISAlerts',
        rules: [
          {
            alert: 'MicrosoftIISRejectedAsyncIORequests',
            expr: |||
              increase(windows_iis_rejected_async_io_requests_total{%(filteringSelector)s}[5m]) > %(alertsWarningHighRejectedAsyncIORequests)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are a high number of rejected async I/O requests for a site.',
              description:
                ('The number of rejected async IO requests is {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} - {{ $labels.site }}, ' +
                 'which is above the threshold of %(alertsWarningHighRejectedAsyncIORequests)s.') % this.config,
            },
          },
          {
            alert: 'MicrosoftIIS5xxRequestErrors',
            expr: |||
              sum without (pid, status_code)(increase(windows_iis_worker_request_errors_total{status_code=~"5.."%(filteringSelector)s}[5m])) > %(alertsCriticalHigh5xxRequests)s
            ||| % (this.config { filteringSelector: if this.config.filteringSelector != '' then ',' + this.config.filteringSelector else '' }),
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of 5xx request errors for an application.',
              description:
                ('The number of 5xx request errors is {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} - {{ $labels.app }}, ' +
                 'which is above the threshold of %(alertsCriticalHigh5xxRequests)s.') % this.config,
            },
          },
          {
            alert: 'MicrosoftIISSuccessRateForWebsocket',
            expr: |||
              sum without (pid)  (increase(windows_iis_worker_websocket_connection_accepted_total{%(filteringSelector)s}[5m]) / clamp_min(increase(windows_iis_worker_websocket_connection_attempts_total{%(filteringSelector)s}[5m]),1)) * 100 < %(alertsCriticalLowWebsocketConnectionSuccessRate)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a low success rate for websocket connections for an application.',
              description:
                ('The success rate for websocket connections is {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} - {{ $labels.app }}, ' +
                 'which is below the threshold of %(alertsCriticalLowWebsocketConnectionSuccessRate)s.') % this.config,
            },
          },
          {
            alert: 'MicrosoftIISThreadpoolUtilization',
            expr: |||
              sum without (pid, state)(windows_iis_worker_threads{%(filteringSelector)s} / windows_iis_worker_max_threads{%(filteringSelector)s}) * 100 > %(alertsCriticalHighThreadPoolUtilization)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The thread pool utilization is nearing max capacity.',
              description:
                ('The threadpool utilization is at {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} - {{ $labels.app }}, ' +
                 'which is above the threshold of %(alertsCriticalHighThreadPoolUtilization)s.') % this.config,
            },
          },
          {
            alert: 'MicrosoftIISWorkerProcessFailures',
            expr: |||
              increase(windows_iis_total_worker_process_failures{%(filteringSelector)s}[5m]) > %(alertsWarningHighWorkerProcessFailures)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are a high number of worker process failures for an application.',
              description:
                ('The number of worker process failures is at {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} - {{ $labels.app }}, ' +
                 'which is above the threshold of %(alertsWarningHighWorkerProcessFailures)s.') % this.config,
            },
          },
        ],
      },
    ],
  },
}
