{
  new(this): {
    groups+: [
      {
        name: 'ApacheTomcatAlerts',
        rules: [
          {
            alert: 'ApacheTomcatAlertsHighCpuUsage',
            expr: |||
              sum by (%(agg)s) (jvm_process_cpu_load{%(filteringSelector)s}) > %(alertsCriticalCpuUsage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The instance has a CPU usage higher than the configured threshold.',
              description:
                (
                  'The CPU usage has been at {{ printf "%%.0f" $value }} percent over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalCpuUsage)s percent.'
                ) % this.config,
            },
          },
          {
            alert: 'ApacheTomcatAlertsHighMemoryUsage',
            expr: |||
              sum(jvm_memory_usage_used_bytes{%(filteringSelector)s}) by (%(agg)s) / sum(jvm_physical_memory_bytes{%(filteringSelector)s}) by (%(agg)s) * 100 > %(alertsCriticalMemoryUsage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The instance has a higher memory usage than the configured threshold.',
              description:
                (
                  'The memory usage has been at {{ printf "%%.0f" $value }} percent over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalMemoryUsage)s percent.'
                ) % this.config,
            },
          },
          {
            alert: 'ApacheTomcatAlertsRequestErrors',
            expr: |||
              sum by (%(agg)s) (increase(tomcat_errorcount_total{%(filteringSelector)s}[5m]) / increase(tomcat_requestcount_total{%(filteringSelector)s}[5m]) * 100) > %(alertsCriticalRequestErrorPercentage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of request errors.',
              description:
                (
                  'The percentage of request errors has been at {{ printf "%%.0f" $value }} percent over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalRequestErrorPercentage)s percent.'
                ) % this.config,
            },
          },
          {
            alert: 'ApacheTomcatAlertsHighProcessingTime',
            expr: |||
              sum by (%(agg)s) (increase(tomcat_processingtime_total{%(filteringSelector)s}[5m]) / increase(tomcat_requestcount_total{%(filteringSelector)s}[5m])) > %(alertsWarningProcessingTime)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The processing time has been moderately high.',
              description:
                (
                  'The processing time has been at {{ printf "%%.0f" $value }}ms over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningProcessingTime)sms.'
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
