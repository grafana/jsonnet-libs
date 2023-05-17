{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'squid',
        rules: [
          {
            alert: 'SquidHighPercentageOfHTTPServerRequestErrors',
            expr: |||
              rate(squid_server_http_errors_total[5m]) / clamp_min(rate(squid_server_http_requests_total[5m]),1) * 100 > %(alertsCriticalHighPercentageRequestErrors)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of HTTP server errors.',
              description: |||
                The percentage of HTTP server request errors is {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} which is above the threshold of %(alertsCriticalHighPercentageRequestErrors)s.
              ||| % $._config,
            },
          },
          {
            alert: 'SquidHighPercentageOfFTPServerRequestErrors',
            expr: |||
              rate(squid_server_ftp_errors_total[5m]) / clamp_min(rate(squid_server_ftp_requests_total[5m]),1) * 100 > %(alertsCriticalHighPercentageRequestErrors)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of FTP server request errors.',
              description: |||
                The percentage of FTP server request errors is {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} which is above the threshold of %(alertsCriticalHighPercentageRequestErrors)s.
              ||| % $._config,
            },
          },
          {
            alert: 'SquidHighPercentageOfOtherServerRequestErrors',
            expr: |||
              rate(squid_server_other_errors_total[5m]) / clamp_min(rate(squid_server_other_requests_total[5m]),1) * 100 > %(alertsCriticalHighPercentageRequestErrors)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of other server request errors.',
              description: |||
                The percentage of other server request errors is {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} which is above the threshold of %(alertsCriticalHighPercentageRequestErrors)s.
              ||| % $._config,
            },
          },
          {
            alert: 'SquidHighPercentageOfClientRequestErrors',
            expr: |||
              rate(squid_client_http_errors_total[5m]) / clamp_min(rate(squid_client_http_requests_total[5m]),1) * 100 > %(alertsCriticalHighPercentageRequestErrors)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of HTTP client request errors.',
              description: |||
                The percentage of HTTP client request errors is {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} which is above the threshold of %(alertsCriticalHighPercentageRequestErrors)s.
              ||| % $._config,
            },
          },
          {
            alert: 'SquidLowCacheHitRatio',
            expr: |||
              rate(squid_client_http_hits_total[10m]) / clamp_min(rate(Squid_client_http_requests_total[10m]),1) * 100 < %(alertsWarningLowCacheHitRatio)s
            ||| % $._config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The cache hit ratio has fallen below the configured threshold (%).',
              description: |||
                The cache hit ratio is {{ printf "%%.0f" $value }} over the last 10m on {{ $labels.instance }} which is below the threshold of %(alertsWarningLowCacheHitRatio)s.
              ||| % $._config,
            },
          },
        ],
      },
    ],
  },
}
