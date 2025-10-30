function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {

      // Operation counters
      opCountersInsert: {
        name: 'Insert operations',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of insert operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_insert{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - insert',
          },
        },
      },

      opCountersQuery: {
        name: 'Query operations',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of query operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_query{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - query',
          },
        },
      },

      opCountersUpdate: {
        name: 'Update operations',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of update operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_update{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - update',
          },
        },
      },

      opCountersDelete: {
        name: 'Delete operations',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of delete operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_delete{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - delete',
          },
        },
      },

      opCountersInsertByInstance: {
        name: 'Insert operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of insert operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_insert{%(queriesSelector)s, rs_nm=~"$rs"}',
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
            expr: 'mongodb_opcounters_query{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      opCountersUpdateByInstance: {
        name: 'Update operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of update operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opcounters_update{%(queriesSelector)s, rs_nm=~"$rs"}',
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
            expr: 'mongodb_opcounters_delete{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Operation latencies
      opLatenciesReadsOps: {
        name: 'Read operation count',
        type: 'counter',
        description: 'Number of read operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs"}',
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
            expr: 'mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      opLatenciesReadsOpsByInstance: {
        name: 'Read operation count by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of read operations per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs"}',
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
            expr: 'mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },

      opLatenciesReadsLatency: {
        name: 'Read operation latency',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Total read operation latency.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      opLatenciesWritesLatency: {
        name: 'Write operation latency',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Total write operation latency.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      opLatenciesReadsLatencyByInstance: {
        name: 'Read operation latency by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Total read operation latency per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - reads',
          },
        },
      },

      opLatenciesWritesLatencyByInstance: {
        name: 'Write operation latency by instance',
        type: 'counter',
        rangeFunction: 'increase',
        aggLevel: 'none',
        description: 'Total write operation latency per instance.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },

      // Average latency calculations (raw type for complex expressions)
      avgReadLatency: {
        name: 'Average read latency',
        type: 'raw',
        description: 'Average latency per read operation.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'sum (increase(mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs"}[$__interval:])) by (job, cl_name) / clamp_min(sum (increase(mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs"}[$__interval:])) by (job, cl_name), 1)',
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
            expr: 'sum (increase(mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs"}[$__interval:])) by (job, cl_name) / clamp_min(sum (increase(mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs"}[$__interval:])) by (job, cl_name), 1)',
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
            expr: 'increase(mongodb_opLatencies_reads_latency{%(queriesSelector)s, rs_nm=~"$rs"}[$__interval:]) / clamp_min(increase(mongodb_opLatencies_reads_ops{%(queriesSelector)s, rs_nm=~"$rs"}[$__interval:]), 1)',
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
            expr: 'increase(mongodb_opLatencies_writes_latency{%(queriesSelector)s, rs_nm=~"$rs"}[$__interval:]) / clamp_min(increase(mongodb_opLatencies_writes_ops{%(queriesSelector)s, rs_nm=~"$rs"}[$__interval:]), 1)',
            legendCustomTemplate: '{{instance}} - writes',
          },
        },
      },
    },
  }
