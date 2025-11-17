function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {

      // Operation counters (cluster-level)
      opCountersInsert: {
        name: 'Insert operations',
        type: 'counter',
        description: 'Number of insert operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_insert{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - insert',
          },
        },
      },

      opCountersQuery: {
        name: 'Query operations',
        type: 'counter',
        description: 'Number of query operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_query{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - query',
          },
        },
      },

      opCountersDelete: {
        name: 'Delete operations',
        type: 'counter',
        description: 'Number of delete operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_delete{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - delete',
          },
        },
      },

      // Operation counters (by instance)
      opCountersInsertByInstance: {
        name: 'Insert operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of insert operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_insert{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      opCountersQueryByInstance: {
        name: 'Query operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of query operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_query{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      opCountersUpdate: {
        name: 'Update operations',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of update operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_update{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      opCountersDeleteByInstance: {
        name: 'Delete operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of delete operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_delete{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Operation latencies (cluster-level)
      opLatenciesReadsOps: {
        name: 'Read operation count',
        type: 'counter',
        description: 'Number of read operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      opLatenciesWritesOps: {
        name: 'Write operation count',
        type: 'counter',
        description: 'Number of write operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      opLatenciesReadsLatency: {
        name: 'Read operation latency',
        type: 'counter',
        description: 'Total read operation latency.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      opLatenciesWritesLatency: {
        name: 'Write operation latency',
        type: 'counter',
        description: 'Total write operation latency.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      // Operation latencies (by instance)
      opLatenciesReadsOpsByInstance: {
        name: 'Read operation count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of read operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - reads',
          },
        },
      },

      opLatenciesWritesOpsByInstance: {
        name: 'Write operation count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of write operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },

      opLatenciesReadsLatencyByInstance: {
        name: 'Read operation latency by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Total read operation latency per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - reads',
          },
        },
      },

      opLatenciesWritesLatencyByInstance: {
        name: 'Write operation latency by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Total write operation latency per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },

      // Average latency calculations
      avgReadLatency: {
        name: 'Average read latency',
        type: 'raw',
        description: 'Average latency per read operation.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'sum (increase(mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:])) by (job, cl_name) / clamp_min(sum (increase(mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:])) by (job, cl_name), 1)',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      avgWriteLatency: {
        name: 'Average write latency',
        type: 'raw',
        description: 'Average latency per write operation.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'sum (increase(mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:])) by (job, cl_name) / clamp_min(sum (increase(mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:])) by (job, cl_name), 1)',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      avgReadLatencyByInstance: {
        name: 'Average read latency by instance',
        type: 'raw',
        description: 'Average latency per read operation by instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:]) / clamp_min(increase(mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:]), 1)',
            legendCustomTemplate: '{{instance}} - reads',
          },
        },
      },

      avgWriteLatencyByInstance: {
        name: 'Average write latency by instance',
        type: 'raw',
        description: 'Average latency per write operation by instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:]) / clamp_min(increase(mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:]), 1)',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },

      // Connection signals
      connectionsCurrent: {
        name: 'Current connections',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Current number of incoming connections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_connections_current{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      connectionsActive: {
        name: 'Active connections',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Current number of connections with operations in progress.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_connections_active{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Read/write operations (by instance with stacking)
      opLatenciesReadsOpsByInstanceStacked: {
        name: 'Read operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Rate of read operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - reads',
          },
        },
      },

      opLatenciesWritesOpsByInstanceStacked: {
        name: 'Write operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Rate of write operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },

      // Read/write latencies (by instance with stacking)
      opLatenciesReadsLatencyByInstanceStacked: {
        name: 'Read latency by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Read operation latency per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - reads',
          },
        },
      },

      opLatenciesWritesLatencyByInstanceStacked: {
        name: 'Write latency by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Write operation latency per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },

      // Database lock deadlocks (by instance)
      dbDeadlockExclusiveByInstance: {
        name: 'Database exclusive lock deadlocks by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database exclusive lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      dbDeadlockIntentExclusiveByInstance: {
        name: 'Database intent exclusive lock deadlocks by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database intent exclusive lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      dbDeadlockSharedByInstance: {
        name: 'Database shared lock deadlocks by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database shared lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      dbDeadlockIntentSharedByInstance: {
        name: 'Database intent shared lock deadlocks by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database intent shared lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Database lock wait counts (by instance)
      dbWaitCountExclusiveByInstance: {
        name: 'Database exclusive lock wait count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database exclusive lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      dbWaitCountIntentExclusiveByInstance: {
        name: 'Database intent exclusive lock wait count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database intent exclusive lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      dbWaitCountSharedByInstance: {
        name: 'Database shared lock wait count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database shared lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      dbWaitCountIntentSharedByInstance: {
        name: 'Database intent shared lock wait count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database intent shared lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Database lock acquisition time (by instance)
      dbAcqTimeExclusiveByInstance: {
        name: 'Database exclusive lock acquisition time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database exclusive lock acquisition time per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      dbAcqTimeIntentExclusiveByInstance: {
        name: 'Database intent exclusive lock acquisition time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database intent exclusive lock acquisition time per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      dbAcqTimeSharedByInstance: {
        name: 'Database shared lock acquisition time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database shared lock acquisition time per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      dbAcqTimeIntentSharedByInstance: {
        name: 'Database intent shared lock acquisition time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database intent shared lock acquisition time per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock deadlocks (by instance)
      collDeadlockExclusiveByInstance: {
        name: 'Collection exclusive lock deadlocks by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection exclusive lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collDeadlockIntentExclusiveByInstance: {
        name: 'Collection intent exclusive lock deadlocks by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collDeadlockSharedByInstance: {
        name: 'Collection shared lock deadlocks by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection shared lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collDeadlockIntentSharedByInstance: {
        name: 'Collection intent shared lock deadlocks by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent shared lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock wait counts (by instance)
      collWaitCountExclusiveByInstance: {
        name: 'Collection exclusive lock wait count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection exclusive lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collWaitCountIntentExclusiveByInstance: {
        name: 'Collection intent exclusive lock wait count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collWaitCountSharedByInstance: {
        name: 'Collection shared lock wait count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection shared lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collWaitCountIntentSharedByInstance: {
        name: 'Collection intent shared lock wait count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent shared lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock acquisition time (by instance)
      collAcqTimeExclusiveByInstance: {
        name: 'Collection exclusive lock acquisition time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection exclusive lock acquisition time per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collAcqTimeIntentExclusiveByInstance: {
        name: 'Collection intent exclusive lock acquisition time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock acquisition time per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collAcqTimeSharedByInstance: {
        name: 'Collection shared lock acquisition time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection shared lock acquisition time per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collAcqTimeIntentSharedByInstance: {
        name: 'Collection intent shared lock acquisition time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent shared lock acquisition time per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },
    },
  }
