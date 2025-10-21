function(this)
  local legendCustomTemplate = '{{ instance }}';
  local aggregationLabels = '(' + std.join(',', this.instanceLabels) + ')';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: 'cassandra_storage_load_count',
    signals: {
      storageLoadCount: {
        name: 'Storage load count',
        nameShort: 'Storage load',
        type: 'raw',
        description: 'The number of bytes being used by this node',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'cassandra_storage_load_count{%(queriesSelector)s}',
          },
        },
      },

      memoryUsage: {
        name: 'Memory usage',
        nameShort: 'Memory',
        type: 'gauge',
        description: 'The JVM memory usage of this node',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'jvm_memory_usage_used_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ area }}',
          },
        },
      },

      cpuUsage: {
        name: 'CPU usage',
        nameShort: 'CPU',
        type: 'gauge',
        description: 'The JVM CPU usage of this node',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'jvm_process_cpu_load{%(queriesSelector)s}',
          },
        },
      },

      gcDurationPanel: {
        name: 'Garbage collection duration',
        nameShort: 'GC duration',
        type: 'gauge',
        description: 'The amount of time spent performing the most recent garbage collection on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'jvm_gc_duration_seconds{%(queriesSelector)s}',
          },
        },
      },

      gcCollections: {
        name: 'Garbage collections',
        nameShort: 'GC collections',
        type: 'counter',
        description: 'The number of times garbage collection was performed on this node',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'jvm_gc_collection_count{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },

      keycacheHitRate: {
        name: 'Keycache hit rate',
        nameShort: 'Keycache hit rate',
        type: 'gauge',
        description: 'The hit rate of the keycache on this node',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'cassandra_cache_hitrate{%(queriesSelector)s}',
          },
        },
      },

      hintMessages: {
        name: 'Hint messages',
        nameShort: 'Hint messages',
        type: 'counter',
        description: 'The number of hint messages received by this node',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'cassandra_storage_totalhints_count{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },

      pendingCompactionTasks: {
        name: 'Pending compaction tasks',
        nameShort: 'Pending compaction tasks',
        type: 'gauge',
        description: 'The number of pending compaction tasks on this node',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'cassandra_compaction_pendingtasks{%(queriesSelector)s}',
          },
        },
      },

      blockedCompactionTasks: {
        name: 'Blocked compaction tasks',
        nameShort: 'Blocked compaction tasks',
        type: 'gauge',
        description: 'The number of blocked compaction tasks on this node',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'cassandra_threadpools_currentlyblockedtasks_count{%(queriesSelector)s}',
          },
        },
      },

      writes: {
        name: 'Writes',
        nameShort: 'Writes',
        type: 'counter',
        description: 'The number of writes performed on this node',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance) (cassandra_keyspace_writelatency_seconds_count{%(queriesSelector)s})',
            rangeFunction: 'increase',
          },
        },
      },

      reads: {
        name: 'Reads',
        nameShort: 'Reads',
        type: 'counter',
        description: 'The number of reads performed on this node',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance) (cassandra_keyspace_readlatency_seconds_count{%(queriesSelector)s})',
            rangeFunction: 'increase',
          },
        },
      },

      writeAverageLatency: {
        name: 'Write average latency',
        nameShort: 'Write average latency',
        type: 'gauge',
        description: 'The average write latency on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg(cassandra_keyspace_writelatency_seconds_average{%(queriesSelector)s} >= 0)',
          },
        },
      },

      readAverageLatency: {
        name: 'Read average latency',
        nameShort: 'Read average latency',
        type: 'gauge',
        description: 'The average read latency on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg(cassandra_keyspace_readlatency_seconds_average{%(queriesSelector)s} >= 0)',
          },
        },
      },

      writeLatencyP95: {
        name: 'Write latency p95',
        nameShort: 'Write latency p95',
        type: 'gauge',
        description: 'The 95th percentile of write latency on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg(cassandra_keyspace_writelatency_seconds{%(queriesSelector)s, quantile="0.95"} >= 0)',
            legendCustomTemplate: legendCustomTemplate + ' - p95',
          },
        },
      },

      writeLatencyP99: {
        name: 'Write latency p99',
        nameShort: 'Write latency p99',
        type: 'gauge',
        description: 'The 99th percentile of write latency on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg(cassandra_keyspace_writelatency_seconds{%(queriesSelector)s, quantile="0.99"} >= 0)',
            legendCustomTemplate: legendCustomTemplate + ' - p99',
          },
        },
      },

      readLatencyP95: {
        name: 'Read latency p95',
        nameShort: 'Read latency p95',
        type: 'gauge',
        description: 'The 95th percentile of read latency on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_readlatency_seconds{%(queriesSelector)s, quantile="0.95"} >= 0) by (instance)',
            legendCustomTemplate: legendCustomTemplate + ' - p95',
          },
        },
      },

      readLatencyP99: {
        name: 'Read latency p99',
        nameShort: 'Read latency p99',
        type: 'gauge',
        description: 'The 99th percentile of read latency on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_keyspace_readlatency_seconds{%(queriesSelector)s, quantile="0.99"} >= 0) by (instance)',
            legendCustomTemplate: legendCustomTemplate + ' - p99',
          },
        },
      },

      crossNodeLatencyP95: {
        name: 'Cross-node latency p95',
        nameShort: 'Cross-node latency p95',
        type: 'raw',
        description: 'The 95th percentile of cross-node latency on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_messaging_crossnodelatency_seconds{%(queriesSelector)s, quantile="0.95"} >= 0) by (instance)',
            legendCustomTemplate: legendCustomTemplate + ' - p99',
          },
        },
      },

      crossNodeLatencyP99: {
        name: 'Cross-node latency p99',
        nameShort: 'Cross-node latency p99',
        type: 'raw',
        description: 'The 99th percentile of cross-node latency on this node',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum(cassandra_messaging_crossnodelatency_seconds{%(queriesSelector)s, quantile="0.99"} >= 0) by (instance)',
            legendCustomTemplate: legendCustomTemplate + ' - p99',
          },
        },
      },
    },
  }
