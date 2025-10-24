function(this)
  local legendCustomTemplate = '{{ keyspace}}';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: 'cassandra_keyspace_pendingcompactions',
    signals: {
      keyspacesCount: {
        name: 'Keyspaces count',
        nameShort: 'Keyspaces',
        type: 'raw',
        description: 'The total count of the amount of keyspaces being reported.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'count(count by (keyspace) (cassandra_keyspace_writelatency_seconds{%(queriesSelector)s}))',
          },
        },
      },

      keyspacesTotalDiskSpaceUsed: {
        name: 'Keyspace total disk space used',
        nameShort: 'Keyspaces disk space',
        type: 'raw',
        description: 'The total amount of disk space used by keyspaces.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_totaldiskspaceused{%(queriesSelector)s}) by (keyspace)',
          },
        },
      },

      keyspacesPendingCompactions: {
        name: 'Keyspace pending compactions',
        nameShort: 'Keyspaces pending compactions',
        type: 'raw',
        description: 'The total count of the amount of pending compactions being reported.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_pendingcompactions{%(queriesSelector)s}) by (keyspace)',
          },
        },
      },

      keyspacesMaxPartitionSize: {
        name: 'Keyspace max partition size',
        nameShort: 'Keyspaces max partition size',
        type: 'raw',
        description: 'The total size of the largest partition being reported.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'max(cassandra_table_maxpartitionsize{%(queriesSelector)s}) by (keyspace)',
          },
        },
      },

      writes: {
        name: 'Keyspace writes',
        nameShort: 'Keyspaces writes',
        type: 'counter',
        description: 'The number of writes performed on the keyspace.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_writelatency_seconds_count{%(queriesSelector)s}) by (keyspace)',
            rangeFunction: 'increase',
          },
        },
      },

      reads: {
        name: 'Keyspace reads',
        nameShort: 'Keyspaces reads',
        type: 'counter',
        description: 'The number of reads performed on the keyspace.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_readlatency_seconds_count{%(queriesSelector)s}) by (keyspace)',
            rangeFunction: 'increase',
          },
        },
      },

      repairJobsStarted: {
        name: 'Keyspace repair jobs started',
        nameShort: 'Keyspaces repair jobs started',
        type: 'counter',
        description: 'The number of repair jobs started on the keyspace.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_repairjobsstarted_count{%(queriesSelector)s}) by (keyspace)',
            rangeFunction: 'increase',
          },
        },
      },

      repairJobsCompleted: {
        name: 'Keyspace repair jobs completed',
        nameShort: 'Keyspaces repair jobs completed',
        type: 'counter',
        description: 'The number of repair jobs completed on the keyspace.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_repairjobscompleted_count{%(queriesSelector)s}) by (keyspace)',
            rangeFunction: 'increase',
          },
        },
      },

      keyspaceWriteLatencyP95: {
        name: 'Keyspace write latency p95',
        nameShort: 'Keyspaces write latency p95',
        type: 'raw',
        description: 'The 95th percentile of write latency for the keyspace.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_writelatency_seconds{%(queriesSelector)s, quantile="0.95"} >= 0) by (keyspace)',
          },
        },
      },

      keyspaceWriteLatencyP99: {
        name: 'Keyspace write latency p99',
        nameShort: 'Keyspaces write latency p99',
        type: 'raw',
        description: 'The 99th percentile of write latency for the keyspace.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_writelatency_seconds{%(queriesSelector)s, quantile="0.99"} >= 0) by (keyspace)',
          },
        },
      },

      keyspaceReadLatencyP95: {
        name: 'Keyspace read latency p95',
        nameShort: 'Keyspaces read latency p95',
        type: 'raw',
        description: 'The 95th percentile of read latency for the keyspace.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_readlatency_seconds{%(queriesSelector)s, quantile="0.95"} >= 0) by (keyspace)',
          },
        },
      },

      keyspaceReadLatencyP99: {
        name: 'Keyspace read latency p99',
        nameShort: 'Keyspaces read latency p99',
        type: 'raw',
        description: 'The 99th percentile of read latency for the keyspace.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_readlatency_seconds{%(queriesSelector)s, quantile="0.99"} >= 0) by (keyspace)',
          },
        },
      },
    },
  }
