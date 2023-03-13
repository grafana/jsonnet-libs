{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ApacheTomcatAlerts',
        rules: [
          {
            alert: 'HighCpuUsage',
            expr: |||
              jvm_process_cpu_load > %(alertsCriticalCpuUsage)s
            ||| % $._config,
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
                ) % $._config,
            },
          },
          {
            alert: 'HighMemoryUsage',
            expr: |||
              sum(jvm_memory_usage_used_bytes) by (job, instance) / sum(jvm_physical_memory_bytes) by (job, instance) * 100 > %(alertsCriticalMemoryUsage)s
            ||| % $._config,
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
                ) % $._config,
            },
          },
          {
            alert: 'HighRequestErrorPercent',
            expr: |||
              increase(tomcat_errorcount_total[5m]) / increase(tomcat_requestcount_total[5m]) * 100 > %(alertsCriticalRequestErrorPercentage)s
            ||| % $._config,
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
                ) % $._config,
            },
          },
          {
            alert: 'ModeratelyHighProcessingTime',
            expr: |||
              increase(tomcat_processingtime_total[5m]) / increase(tomcat_requestcount_total[5m]) > %(alertsWarningProcessingTime)s
            ||| % $._config,
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
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
