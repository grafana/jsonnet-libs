{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ApacheTomcatAlerts',
        rules: [
          {
            alert: 'ApacheTomcatAlertsHighCpuUsage',
            expr: |||
              sum by (job, instance) (jvm_process_cpu_load) > %(ApacheTomcatAlertsCriticalCpuUsage)s
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
                  'which is above the threshold of %(ApacheTomcatAlertsCriticalCpuUsage)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheTomcatAlertsHighMemoryUsage',
            expr: |||
              sum(jvm_memory_usage_used_bytes) by (job, instance) / sum(jvm_physical_memory_bytes) by (job, instance) * 100 > %(ApacheTomcatAlertsCriticalMemoryUsage)s
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
                  'which is above the threshold of %(ApacheTomcatAlertsCriticalMemoryUsage)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheTomcatAlertsHighRequestErrorPercent',
            expr: |||
              sum by (job, instance) (increase(tomcat_errorcount_total[5m]) / increase(tomcat_requestcount_total[5m]) * 100) > %(ApacheTomcatAlertsCriticalRequestErrorPercentage)s
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
                  'which is above the threshold of %(ApacheTomcatAlertsCriticalRequestErrorPercentage)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheTomcatAlertsModeratelyHighProcessingTime',
            expr: |||
              sum by (job, instance) (increase(tomcat_processingtime_total[5m]) / increase(tomcat_requestcount_total[5m])) > %(ApacheTomcatAlertsWarningProcessingTime)s
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
                  'which is above the threshold of %(ApacheTomcatAlertsWarningProcessingTime)sms.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
