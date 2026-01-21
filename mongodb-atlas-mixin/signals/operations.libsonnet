function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {

      opCountersInsert: {
        name: 'Insert operations',
        type: 'counter',
        description: 'Number of insert operations.',
        unit: 'ops/s',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_insert{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      opCountersQuery: {
        name: 'Query operations',
        type: 'counter',
        description: 'Number of query operations.',
        unit: 'ops/s',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_query{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      opCountersDelete: {
        name: 'Delete operations',
        type: 'counter',
        description: 'Number of delete operations.',
        unit: 'ops/s',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_delete{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      opCountersUpdate: {
        name: 'Update operations',
        type: 'counter',
        description: 'Number of update operations.',
        unit: 'ops/s',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_update{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Connection signals
      connectionsCurrent: {
        name: 'Current connections',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Current number of incoming connections.',
        unit: 'short',
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
        unit: 'short',
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
        unit: 'short',
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
        unit: 'short',
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
        unit: 'short',
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
        unit: 'short',
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
        unit: 'short',
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
        unit: 'short',
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
        unit: 'short',
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
