function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {

      // Global lock queues
      globalLockQueueReaders: {
        name: 'Global lock queue - readers',
        type: 'gauge',
        description: 'Number of read operations queued due to locks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_globalLock_currentQueue_readers{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      globalLockQueueWriters: {
        name: 'Global lock queue - writers',
        type: 'gauge',
        description: 'Number of write operations queued due to locks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_globalLock_currentQueue_writers{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      // Global lock active clients
      globalLockActiveReaders: {
        name: 'Global lock active clients - readers',
        type: 'gauge',
        description: 'Number of active read operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_globalLock_activeClients_readers{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      globalLockActiveWriters: {
        name: 'Global lock active clients - writers',
        type: 'gauge',
        description: 'Number of active write operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_globalLock_activeClients_writers{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      // Database lock deadlocks
      dbDeadlockExclusive: {
        name: 'Database exclusive lock deadlocks',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database exclusive lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_W{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - exclusive',
          },
        },
      },

      dbDeadlockIntentExclusive: {
        name: 'Database intent exclusive lock deadlocks',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database intent exclusive lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_w{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - intent exclusive',
          },
        },
      },

      dbDeadlockShared: {
        name: 'Database shared lock deadlocks',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database shared lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_R{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - shared',
          },
        },
      },

      dbDeadlockIntentShared: {
        name: 'Database intent shared lock deadlocks',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database intent shared lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_r{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - intent shared',
          },
        },
      },

      dbDeadlockExclusiveByInstance: {
        name: 'Database exclusive lock deadlocks by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database exclusive lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_W{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      dbDeadlockIntentExclusiveByInstance: {
        name: 'Database intent exclusive lock deadlocks by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database intent exclusive lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_w{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      dbDeadlockSharedByInstance: {
        name: 'Database shared lock deadlocks by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database shared lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_R{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      dbDeadlockIntentSharedByInstance: {
        name: 'Database intent shared lock deadlocks by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database intent shared lock deadlocks per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_r{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Database lock wait counts
      dbWaitCountExclusive: {
        name: 'Database exclusive lock wait count',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database exclusive lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_W{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - exclusive',
          },
        },
      },

      dbWaitCountIntentExclusive: {
        name: 'Database intent exclusive lock wait count',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database intent exclusive lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_w{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - intent exclusive',
          },
        },
      },

      dbWaitCountShared: {
        name: 'Database shared lock wait count',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database shared lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_R{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - shared',
          },
        },
      },

      dbWaitCountIntentShared: {
        name: 'Database intent shared lock wait count',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database intent shared lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_r{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - intent shared',
          },
        },
      },

      dbWaitCountExclusiveByInstance: {
        name: 'Database exclusive lock wait count by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database exclusive lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_W{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      dbWaitCountIntentExclusiveByInstance: {
        name: 'Database intent exclusive lock wait count by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database intent exclusive lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_w{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      dbWaitCountSharedByInstance: {
        name: 'Database shared lock wait count by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database shared lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_R{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      dbWaitCountIntentSharedByInstance: {
        name: 'Database intent shared lock wait count by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database intent shared lock wait count per instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_r{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Database lock acquisition time
      dbAcqTimeExclusive: {
        name: 'Database exclusive lock acquisition time',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database exclusive lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_W{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      dbAcqTimeIntentExclusive: {
        name: 'Database intent exclusive lock acquisition time',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database intent exclusive lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_w{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      dbAcqTimeShared: {
        name: 'Database shared lock acquisition time',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database shared lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_R{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      dbAcqTimeIntentShared: {
        name: 'Database intent shared lock acquisition time',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Database intent shared lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_r{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock deadlocks
      collDeadlockExclusive: {
        name: 'Collection exclusive lock deadlocks',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection exclusive lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_W{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collDeadlockIntentExclusive: {
        name: 'Collection intent exclusive lock deadlocks',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_w{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collDeadlockShared: {
        name: 'Collection shared lock deadlocks',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection shared lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_R{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collDeadlockIntentShared: {
        name: 'Collection intent shared lock deadlocks',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection intent shared lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_r{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock wait counts
      collWaitCountExclusive: {
        name: 'Collection exclusive lock wait count',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection exclusive lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_W{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collWaitCountIntentExclusive: {
        name: 'Collection intent exclusive lock wait count',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_w{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collWaitCountShared: {
        name: 'Collection shared lock wait count',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection shared lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_R{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collWaitCountIntentShared: {
        name: 'Collection intent shared lock wait count',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection intent shared lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_r{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock acquisition time
      collAcqTimeExclusive: {
        name: 'Collection exclusive lock acquisition time',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection exclusive lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_W{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collAcqTimeIntentExclusive: {
        name: 'Collection intent exclusive lock acquisition time',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_w{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collAcqTimeShared: {
        name: 'Collection shared lock acquisition time',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection shared lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_R{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collAcqTimeIntentShared: {
        name: 'Collection intent shared lock acquisition time',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Collection intent shared lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_r{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },
    },
  }
