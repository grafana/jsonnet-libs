{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'apache-activemq-alerts',
        rules: [
          {
            alert: 'ApacheActiveMQHighTopicMemoryUsage',
            expr: |||
              sum (activemq_topic_memory_percent_usage{destination!~"ActiveMQ.Advisory.*"}) > %(alertsHighTopicMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Topic destination memory usage is high, which may result in a reduction of the rate at which producers send messages.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of memory used by topics on {{$labels.instance}} in cluster {{$labels.activemq_cluster}}, ' +
                  'which is above the threshold of %(alertsHighTopicMemoryUsage)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheActiveMQHighQueueMemoryUsage',
            expr: |||
              sum (activemq_queue_memory_percent_usage) > %(alertsHighQueueMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Queue destination memory usage is high, which may result in a reduction of the rate at which producers send messages.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of memory used by queues on {{$labels.instance}} in cluster {{$labels.activemq_cluster}}, ' +
                  'which is above the threshold of %(alertsHighQueueMemoryUsage)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheActiveMQHighStoreMemoryUsage',
            expr: |||
              activemq_store_usage_ratio > %(alertsHighStoreMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Store memory usage is high, which may result in producers unable to send messages.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of store memory used on {{$labels.instance}} in cluster {{$labels.activemq_cluster}}, ' +
                  'which is above the threshold of %(alertsHighStoreMemoryUsage)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheActiveMQHighTemporaryMemoryUsage',
            expr: |||
              activemq_temp_usage_ratio > %(alertsHighTemporaryMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Temporary memory usage is high, which may result in saturation of messaging throughput.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of temporary memory used on {{$labels.instance}} in cluster {{$labels.activemq_cluster}}, ' +
                  'which is above the threshold of %(alertsHighTemporaryMemoryUsage)s percent.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
