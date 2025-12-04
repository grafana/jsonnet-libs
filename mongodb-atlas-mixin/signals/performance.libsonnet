function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {

      // Connection signals
      connectionsCurrent: {
        name: 'Current connections',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Current number of active connections.',
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

      // Database lock deadlocks (cluster-level)
      dbDeadlockExclusive: {
        name: 'Database exclusive lock deadlocks',
        type: 'counter',
        description: 'Database exclusive lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - exclusive',
          },
        },
      },

      dbDeadlockIntentExclusive: {
        name: 'Database intent exclusive lock deadlocks',
        type: 'counter',
        description: 'Database intent exclusive lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - intent exclusive',
          },
        },
      },

      dbDeadlockShared: {
        name: 'Database shared lock deadlocks',
        type: 'counter',
        description: 'Database shared lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - shared',
          },
        },
      },

      dbDeadlockIntentShared: {
        name: 'Database intent shared lock deadlocks',
        type: 'counter',
        description: 'Database intent shared lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_deadlockCount_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - intent shared',
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

      // Database lock wait counts (cluster-level)
      dbWaitCountExclusive: {
        name: 'Database exclusive lock wait count',
        type: 'counter',
        description: 'Database exclusive lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - exclusive',
          },
        },
      },

      dbWaitCountIntentExclusive: {
        name: 'Database intent exclusive lock wait count',
        type: 'counter',
        description: 'Database intent exclusive lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - intent exclusive',
          },
        },
      },

      dbWaitCountShared: {
        name: 'Database shared lock wait count',
        type: 'counter',
        description: 'Database shared lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - shared',
          },
        },
      },

      dbWaitCountIntentShared: {
        name: 'Database intent shared lock wait count',
        type: 'counter',
        description: 'Database intent shared lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_acquireWaitCount_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cl_name}} - intent shared',
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

      // Database lock acquisition time
      dbAcqTimeExclusive: {
        name: 'Database exclusive lock acquisition time',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database exclusive lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      dbAcqTimeIntentExclusive: {
        name: 'Database intent exclusive lock acquisition time',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database intent exclusive lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      dbAcqTimeShared: {
        name: 'Database shared lock acquisition time',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database shared lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      dbAcqTimeIntentShared: {
        name: 'Database intent shared lock acquisition time',
        type: 'counter',
        aggLevel: 'none',
        description: 'Database intent shared lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Database_timeAcquiringMicros_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock deadlocks
      collDeadlockExclusive: {
        name: 'Collection exclusive lock deadlocks',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection exclusive lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collDeadlockIntentExclusive: {
        name: 'Collection intent exclusive lock deadlocks',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collDeadlockShared: {
        name: 'Collection shared lock deadlocks',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection shared lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collDeadlockIntentShared: {
        name: 'Collection intent shared lock deadlocks',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent shared lock deadlocks.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_deadlockCount_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock wait counts
      collWaitCountExclusive: {
        name: 'Collection exclusive lock wait count',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection exclusive lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collWaitCountIntentExclusive: {
        name: 'Collection intent exclusive lock wait count',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collWaitCountShared: {
        name: 'Collection shared lock wait count',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection shared lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collWaitCountIntentShared: {
        name: 'Collection intent shared lock wait count',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent shared lock wait count.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_acquireWaitCount_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Collection lock acquisition time
      collAcqTimeExclusive: {
        name: 'Collection exclusive lock acquisition time',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection exclusive lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_W{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - exclusive',
          },
        },
      },

      collAcqTimeIntentExclusive: {
        name: 'Collection intent exclusive lock acquisition time',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent exclusive lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_w{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent exclusive',
          },
        },
      },

      collAcqTimeShared: {
        name: 'Collection shared lock acquisition time',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection shared lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_R{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - shared',
          },
        },
      },

      collAcqTimeIntentShared: {
        name: 'Collection intent shared lock acquisition time',
        type: 'counter',
        aggLevel: 'none',
        description: 'Collection intent shared lock acquisition time.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_locks_Collection_timeAcquiringMicros_r{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - intent shared',
          },
        },
      },

      // Disk space signals
      diskSpaceFree: {
        name: 'Disk space free',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Free disk space on the node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_disk_space_free_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - free',
          },
        },
      },

      diskSpaceUsed: {
        name: 'Disk space used',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Used disk space on the node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_disk_space_used_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - used',
          },
        },
      },

      diskSpaceUtilizationByInstance: {
        name: 'Disk space utilization by instance',
        type: 'raw',
        aggLevel: 'none',
        description: 'Disk space utilization per instance.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: '(hardware_disk_metrics_disk_space_used_bytes{%(queriesSelector)s}) / clamp_min((hardware_disk_metrics_disk_space_free_bytes{%(queriesSelector)s}) + (hardware_disk_metrics_disk_space_used_bytes{%(queriesSelector)s}), 1)',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Memory signals
      memoryResidentByInstance: {
        name: 'Memory resident by instance',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Resident memory (RAM) usage per instance.',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'mongodb_mem_resident{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - RAM',
          },
        },
      },

      memoryVirtualByInstance: {
        name: 'Memory virtual by instance',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Virtual memory usage per instance.',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'mongodb_mem_virtual{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - virtual',
          },
        },
      },

      // CPU interrupt service time by instance
      cpuIrqTimeByInstance: {
        name: 'CPU interrupt service time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'CPU time spent servicing interrupts per instance.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'hardware_system_cpu_irq_milliseconds{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Network signals by instance
      networkRequestsByInstance: {
        name: 'Network requests by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of network requests per instance.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numRequests{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      networkSlowDNSByInstance: {
        name: 'Slow DNS operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of slow DNS operations per instance.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numSlowDNSOperations{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - DNS',
          },
        },
      },

      networkSlowSSLByInstance: {
        name: 'Slow SSL operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of slow SSL operations per instance.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numSlowSSLOperations{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - SSL',
          },
        },
      },

      networkBytesInByInstance: {
        name: 'Network bytes received by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Network bytes received per instance.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesIn{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - received',
          },
        },
      },

      networkBytesOutByInstance: {
        name: 'Network bytes sent by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Network bytes sent per instance.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesOut{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}} - sent',
          },
        },
      },

      // Hardware I/O by instance
      diskReadCountByInstance: {
        name: 'Disk read operations by instance',
        type: 'raw',
        aggLevel: 'none',
        description: 'Number of disk read operations per instance.',
        unit: 'iops',
        sources: {
          prometheus: {
            expr: 'rate(hardware_disk_metrics_read_count{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}[$__rate_interval])',
            legendCustomTemplate: '{{instance}} - reads',
          },
        },
      },

      diskWriteCountByInstance: {
        name: 'Disk write operations by instance',
        type: 'raw',
        aggLevel: 'none',
        description: 'Number of disk write operations per instance.',
        unit: 'iops',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_write_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },

      diskReadTimeByInstance: {
        name: 'Disk read I/O time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Time spent on read I/O operations per instance.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_read_time_milliseconds{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - read',
          },
        },
      },

      diskWriteTimeByInstance: {
        name: 'Disk write I/O time by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Time spent on write I/O operations per instance.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_write_time_milliseconds{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - write',
          },
        },
      },
    },
  }
