function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {

      // Inventory signals (for shard, config, mongos nodes these are just representative metrics to best populate the tables)
      shardNodeRepresentativeMetric: {
        name: 'Shard node representative metric',
        type: 'gauge',
        aggLevel: 'none',
        description: 'A representative metric for the shard node inventory.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesIn{%(queriesSelector)s, rs_nm=~"$rs_nm", cl_role="shardsvr"}',  // representative metric for a table
            legendCustomTemplate: '',
          },
        },
      },

      configNodeRepresentativeMetric: {
        name: 'Config inventory representative metric',
        type: 'gauge',
        aggLevel: 'none',
        description: 'A representative metric for the config node inventory.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesIn{%(queriesSelector)s, rs_nm=~"$rs_nm", cl_role="configsvr"}',  // representative metric for a table
            legendCustomTemplate: '',
          },
        },
      },

      mongosNodeRepresentativeMetric: {
        name: 'Mongos node representative metric',
        type: 'gauge',
        aggLevel: 'none',
        description: 'A representative metric for the mongos node inventory.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesIn{%(queriesSelector)s, rs_nm=~"$rs_nm", cl_role="mongos"}',  // representative metric for a table
            legendCustomTemplate: '',
          },
        },
      },

      // Hardware signals
      diskReadCount: {
        name: 'Disk read operations',
        type: 'raw',
        description: 'Number of disk read operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum(rate(hardware_disk_metrics_read_count{%(queriesSelector)s,cl_name=~"$cl_name"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      diskWriteCount: {
        name: 'Disk write operations',
        type: 'raw',
        description: 'Number of disk write operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum(rate(hardware_disk_metrics_write_count{%(queriesSelector)s,cl_name=~"$cl_name"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      diskReadTime: {
        name: 'Disk read I/O time',
        type: 'raw',
        description: 'Time spent on read I/O operations.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'sum(increase(hardware_disk_metrics_read_time_milliseconds{%(queriesSelector)s,cl_name=~"$cl_name"}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      diskWriteTime: {
        name: 'Disk write I/O time',
        type: 'raw',
        description: 'Time spent on write I/O operations.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'sum(increase(hardware_disk_metrics_write_time_milliseconds{%(queriesSelector)s,cl_name=~"$cl_name"}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      cpuIrqTime: {
        name: 'CPU interrupt service time',
        type: 'raw',
        description: 'CPU time spent servicing interrupts.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'sum(increase(hardware_system_cpu_irq_milliseconds{%(queriesSelector)s,cl_name=~"$cl_name"}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}}',
          },
        },
      },

      diskSpaceUtilization: {
        name: 'Disk space utilization',
        type: 'raw',
        description: 'Percentage of disk space used.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: '(sum (hardware_disk_metrics_disk_space_used_bytes{%(queriesSelector)s}) by (cl_name)) / clamp_min((sum (hardware_disk_metrics_disk_space_used_bytes{%(queriesSelector)s}) by (cl_name)) + (sum (hardware_disk_metrics_disk_space_free_bytes{%(queriesSelector)s}) by (cl_name)), 1)',
            legendCustomTemplate: '{{cl_name}}',
          },
        },
      },

      // Memory signals
      memoryResident: {
        name: 'Memory resident (RAM)',
        type: 'raw',
        description: 'Resident memory (RAM) usage.',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'sum(mongodb_mem_resident{%(queriesSelector)s, rs_nm=~"$rs_nm"}) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - RAM',
          },
        },
      },

      memoryVirtual: {
        name: 'Memory virtual',
        type: 'raw',
        description: 'Virtual memory usage.',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'sum(mongodb_mem_virtual{%(queriesSelector)s, rs_nm=~"$rs_nm"}) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - virtual',
          },
        },
      },

      // Network signals
      networkRequests: {
        name: 'Network requests',
        type: 'raw',
        description: 'Number of network requests received.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum(rate(mongodb_network_numRequests{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}}',
          },
        },
      },

      networkBytesIn: {
        name: 'Network bytes received',
        type: 'raw',
        description: 'Network bytes received.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'sum(rate(mongodb_network_bytesIn{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - received',
          },
        },
      },

      networkBytesOut: {
        name: 'Network bytes sent',
        type: 'raw',
        description: 'Network bytes sent.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'sum(rate(mongodb_network_bytesOut{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - sent',
          },
        },
      },

      networkSlowDNS: {
        name: 'Slow DNS operations',
        type: 'raw',
        description: 'Number of slow DNS operations (>1s).',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum(rate(mongodb_network_numSlowDNSOperations{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - DNS',
          },
        },
      },

      networkSlowSSL: {
        name: 'Slow SSL operations',
        type: 'raw',
        description: 'Number of slow SSL operations (>1s).',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum(rate(mongodb_network_numSlowSSLOperations{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - SSL',
          },
        },
      },

      // Connection signals
      connectionsCreated: {
        name: 'Connections created',
        type: 'raw',
        description: 'Total connections created.',
        unit: 'conns',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_connections_totalCreated{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}}',
          },
        },
      },

      // Operations signals
      opLatenciesReadsOps: {
        name: 'Read operation count',
        type: 'raw',
        description: 'Number of read operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum(rate(mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      opLatenciesWritesOps: {
        name: 'Write operation count',
        type: 'raw',
        description: 'Number of write operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum(rate(mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__rate_interval])) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      opCountersInsert: {
        name: 'Insert operations',
        type: 'raw',
        description: 'Number of insert operations.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_opcounters_insert{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - insert',
          },
        },
      },

      opCountersQuery: {
        name: 'Query operations',
        type: 'raw',
        description: 'Number of query operations.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_opcounters_query{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - query',
          },
        },
      },

      opCountersUpdate: {
        name: 'Update operations',
        type: 'raw',
        description: 'Number of update operations.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_opcounters_update{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - update',
          },
        },
      },

      opCountersDelete: {
        name: 'Delete operations',
        type: 'raw',
        description: 'Number of delete operations.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_opcounters_delete{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - delete',
          },
        },
      },

      opLatenciesReadsLatency: {
        name: 'Read operation latency',
        type: 'raw',
        description: 'Total read operation latency.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval)) by (cl_name)',
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

      // Locks signals
      globalLockQueueReaders: {
        name: 'Global lock queue - readers',
        type: 'raw',
        description: 'Number of read operations queued due to locks.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(mongodb_globalLock_currentQueue_readers{%(queriesSelector)s, rs_nm=~"$rs_nm"}) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      globalLockQueueWriters: {
        name: 'Global lock queue - writers',
        type: 'raw',
        description: 'Number of write operations queued due to locks.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(mongodb_globalLock_currentQueue_writers{%(queriesSelector)s, rs_nm=~"$rs_nm"}) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      globalLockActiveReaders: {
        name: 'Global lock active clients - readers',
        type: 'raw',
        description: 'Number of active read operations.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(mongodb_globalLock_activeClients_readers{%(queriesSelector)s}) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      globalLockActiveWriters: {
        name: 'Global lock active clients - writers',
        type: 'raw',
        description: 'Number of active write operations.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(mongodb_globalLock_activeClients_writers{%(queriesSelector)s}) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      dbDeadlockExclusive: {
        name: 'Database exclusive lock deadlocks',
        type: 'raw',
        description: 'Database exclusive lock deadlocks.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_locks_Database_deadlockCount_W{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - exclusive',
          },
        },
      },

      dbDeadlockIntentExclusive: {
        name: 'Database intent exclusive lock deadlocks',
        type: 'raw',
        description: 'Database intent exclusive lock deadlocks.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_locks_Database_deadlockCount_w{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - intent exclusive',
          },
        },
      },

      dbDeadlockShared: {
        name: 'Database shared lock deadlocks',
        type: 'raw',
        description: 'Database shared lock deadlocks.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_locks_Database_deadlockCount_R{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - shared',
          },
        },
      },

      dbDeadlockIntentShared: {
        name: 'Database intent shared lock deadlocks',
        type: 'raw',
        description: 'Database intent shared lock deadlocks.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_locks_Database_deadlockCount_r{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - intent shared',
          },
        },
      },

      dbWaitCountExclusive: {
        name: 'Database exclusive lock wait count',
        type: 'raw',
        description: 'Database exclusive lock wait count.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_locks_Database_acquireWaitCount_W{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - exclusive',
          },
        },
      },

      dbWaitCountIntentExclusive: {
        name: 'Database intent exclusive lock wait count',
        type: 'raw',
        description: 'Database intent exclusive lock wait count.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_locks_Database_acquireWaitCount_w{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - intent exclusive',
          },
        },
      },

      dbWaitCountShared: {
        name: 'Database shared lock wait count',
        type: 'raw',
        description: 'Database shared lock wait count.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_locks_Database_acquireWaitCount_R{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - shared',
          },
        },
      },

      dbWaitCountIntentShared: {
        name: 'Database intent shared lock wait count',
        type: 'raw',
        description: 'Database intent shared lock wait count.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum(increase(mongodb_locks_Database_acquireWaitCount_r{%(queriesSelector)s}[$__interval:] offset -$__interval)) by (cl_name)',
            legendCustomTemplate: '{{cl_name}} - intent shared',
          },
        },
      },
    },
  }
