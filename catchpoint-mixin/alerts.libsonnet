{
  new(this): {

    groups: [
      {
        name: this.config.uid,
        rules: [
          {
            alert: 'CatchpointHighServerResponseTime',
            expr: |||
              catchpoint_wait_time{%(filteringSelector)s} > %(alertsHighServerResponseTime)s
              or
              catchpoint_wait_time{%(filteringSelector)s} > avg_over_time(catchpoint_wait_time{%(filteringSelector)s}[15m]) * %(alertsHighServerResponseTimePercent)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High server response time.',
              description: |||
                High server response times can lead to slow user experiences. The current value is {{ $value | printf "%%.2f" }} milliseconds.
              ||| % this.config,
            },
          },
          {
            alert: 'CatchpointTotalTimeExceeded',
            expr: |||
              catchpoint_total_time{%(filteringSelector)s} > %(alertsTotalTimeExceeded)s
              or
              catchpoint_total_time{%(filteringSelector)s} > avg_over_time(catchpoint_total_time{%(filteringSelector)s}[15m]) * %(alertsTotalTimeExceededPercent)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Total time exceeded.',
              description: |||
                Webpage takes too long to load, potentially indicating issues with server response, network latency, or resource-heavy pages. The current value is {{ $value | printf "%%.2f" }} milliseconds.
              ||| % this.config,
            },
          },
          {
            alert: 'CatchpointHighDNSResolutionTime',
            expr: |||
              catchpoint_dns_time{%(filteringSelector)s} > %(alertsHighDNSResolutionTime)s
              or
              catchpoint_dns_time{%(filteringSelector)s} > avg_over_time(catchpoint_dns_time{%(filteringSelector)s}[15m]) * %(alertsHighDNSResolutionTimePercent)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High DNS resolution time.',
              description: |||
                DNS resolution time is high, which could indicate DNS server issues or misconfigurations affecting website accessibility. The current value is {{ $value | printf "%%.2f" }} milliseconds.
              ||| % this.config,
            },
          },
          {
            alert: 'CatchpointContentLoadingDelays',
            expr: |||
              catchpoint_content_load_time{%(filteringSelector)s} > %(alertsContentLoadingDelay)s
              or
              catchpoint_content_load_time{%(filteringSelector)s} > avg_over_time(catchpoint_content_load_time{%(filteringSelector)s}[15m]) * %(alertsContentLoadingDelayPercent)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Content loading delays.',
              description: |||
                Significant delays in content loading could impact user experience and webpage usability. The current value is {{ $value | printf "%%.2f" }} milliseconds.
              ||| % this.config,
            },
          },
          {
            alert: 'CatchpointHighFailedRequestRatio',
            expr: |||
              (catchpoint_failed_requests_count{%(filteringSelector)s} / clamp_min(catchpoint_requests_count{%(filteringSelector)s}, 1)) > %(alertsHighFailedRequestRatioPercent)s
            ||| % this.config,
            'for': '30m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'High failed request ratio.',
              description: |||
                Monitors the ratio of failed requests to total requests to quickly identify deteriorations in service quality, which could affect user experience and compliance with SLA. The current value is {{ $value | printf "%%.2f" }} percent.
              ||| % this.config,
            },
          },
        ],
      },
    ],
  },
}
