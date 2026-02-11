{
  new(this): {
    groups+: [
      {
        name: 'ApacheCassandraAlerts',
        rules: [
          {
            alert: 'HighReadLatency',
            expr: |||
              sum(cassandra_table_readlatency_seconds_sum{%(filteringSelector)s}) by (instance) / sum(cassandra_table_readlatency_seconds_count{%(filteringSelector)s}) by (instance) * 1000 > %(alertsCriticalReadLatency5m)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'HighWriteLatency',
            expr: |||
              sum(cassandra_keyspace_writelatency_seconds_sum{%(filteringSelector)s}) by (instance) / sum(cassandra_keyspace_writelatency_seconds_count{%(filteringSelector)s}) by (instance) * 1000 > %(alertsCriticalWriteLatency5m)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'HighPendingCompactionTasks',
            expr: |||
              cassandra_compaction_pendingtasks{%(filteringSelector)s} > %(alertsWarningPendingCompactionTasks15m)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'BlockedCompactionTasksFound',
            expr: |||
              cassandra_threadpools_currentlyblockedtasks_count{%(blockedCompactionSelector)s} > %(alertsCriticalBlockedCompactionTasks5m)s
            ||| % this.config { blockedCompactionSelector: if this.config.filteringSelector != '' then 'threadpools="CompactionExecutor", path="internal", ' + this.config.filteringSelector else 'threadpools="CompactionExecutor", path="internal"' },
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
                ) % this.config,
            },
          },
          {
            alert: 'HintsStoredOnNode',
            expr: |||
              increase(cassandra_storage_totalhints_count{%(filteringSelector)s}[5m]) > %(alertsWarningHintsStored1m)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'UnavailableWriteRequestsFound',
            expr: |||
              sum  without (cassandra_cluster) (cassandra_clientrequest_unavailables_count{%(unavailableWriteSelector)s}) > %(alertsCriticalUnavailableWriteRequests5m)s
            ||| % this.config { unavailableWriteSelector: if this.config.filteringSelector != '' then 'clientrequest="Write", ' + this.config.filteringSelector else 'clientrequest="Write"' },
            'for': '5m',
            labels: { severity: 'critical' },
            annotations: { summary: 'Unavailable exceptions have been encountered while performing writes in this cluster.', description: ('{{ printf "%%.0f" $value }} unavailable write requests have been found over the last 5 minutes on {{$labels.instance}}, ' + 'which is above the threshold of %(alertsCriticalUnavailableWriteRequests5m)s. ') % this.config },
          },
          {
            alert: 'HighCpuUsage',
            expr: |||
              jvm_process_cpu_load{%(filteringSelector)s} * 100 > %(alertsCriticalHighCpuUsage5m)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'HighMemoryUsage',
            expr: |||
              sum by (instance) (jvm_memory_usage_used_bytes{%(heapSelector)s}) / sum by (instance) (jvm_physical_memory_size{%(filteringSelector)s}) * 100 > %(alertsCriticalHighMemoryUsage5m)s
            ||| % this.config { heapSelector: if this.config.filteringSelector != '' then this.config.filteringSelector + ', area="Heap"' else 'area="Heap"' },
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
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
