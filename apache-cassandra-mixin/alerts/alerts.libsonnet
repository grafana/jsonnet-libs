{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ApacheCassandraAlerts',
        rules: [
          {
            alert: 'HighReadLatency',
            expr: |||
              sum(cassandra_table_readlatency_seconds_sum) by (instance) / sum(cassandra_table_readlatency_seconds_count) by (instance) * 1000 > %(alertsCriticalReadLatency5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high level of read latency within the node.',
              description:
                (
                  'An average of {{ printf "%%.0f" $value }}ms of read latency has occurred over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalReadLatency5m)sms. '
                ) % $._config,
            },
          },
          {
            alert: 'HighWriteLatency',
            expr: |||
              sum(cassandra_keyspace_writelatency_seconds_sum) by (instance) / sum(cassandra_keyspace_writelatency_seconds_count) by (instance) * 1000 > %(alertsCriticalWriteLatency5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high level of write latency within the node.',
              description:
                (
                  'An average of {{ printf "%%.0f" $value }}ms of write latency has occurred over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalWriteLatency5m)sms. '
                ) % $._config,
            },
          },
          {
            alert: 'HighPendingCompactionTasks',
            expr: |||
              cassandra_compaction_pendingtasks > %(alertsWarningPendingCompactionTasks15m)s
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Compaction task queue is filling up.',
              description:
                (
                  '{{ printf "%%.0f" $value }} compaction tasks have been pending over the last 15 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningPendingCompactionTasks15m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'BlockedCompactionTasksFound',
            expr: |||
              cassandra_threadpools_currentlyblockedtasks_count{threadpools="CompactionExecutor", path="internal"} > %(alertsCriticalBlockedCompactionTasks5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Compaction task queue is full.',
              description:
                (
                  '{{ printf "%%.0f" $value }} compaction tasks have been blocked over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalBlockedCompactionTasks5m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'HintsStoredOnNode',
            expr: |||
              cassandra_storage_totalhints_count > %(alertsWarningHintsStored1m)s
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Hints have been recently written to this node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} hints have been written to the node over the last minute on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningHintsStored1m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'UnavailableWriteRequestsFound',
            expr: |||
              sum(cassandra_clientrequest_unavailables_count{clientrequest="Write"}) by (cassandra_cluster) > %(alertsCriticalUnavailableWriteRequests5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Unavailable exceptions have been encountered while performing writes in this cluster.',
              description:
                (
                  '{{ printf "%%.0f" $value }} unavailable write requests have been found over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalUnavailableWriteRequests5m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'HighCpuUsage',
            expr: |||
              jvm_process_cpu_load * 100 > %(alertsCriticalHighCpuUsage5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A node has a CPU usage higher than the configured threshold.',
              description:
                (
                  'Cpu usage is at {{ printf "%%.0f" $value }} percent over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalHighCpuUsage5m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'HighMemoryUsage',
            expr: |||
              sum(jvm_memory_usage_used_bytes{area="Heap"}) / sum(jvm_physical_memory_size) * 100 > %(alertsCriticalHighMemoryUsage5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A node has a higher memory utilization than the configured threshold.',
              description:
                (
                  'Memory usage is at {{ printf "%%.0f" $value }} percent over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalHighMemoryUsage5m)s }}. '
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
