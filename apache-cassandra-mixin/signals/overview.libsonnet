function(this) {
  local legendCustomTemplate = '{{ cassandra_cluster }}',
  local aggregationLabels = '(' + std.join(',', this.groupLabels + this.instanceLabels) + ')',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  legendCustomTemplate: legendCustomTemplate,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '2m',
  discoveryMetric: 'cassandra_up_endpoint_count',
  signals: {
    clusterCount: {
      name: 'Number of clusters',
      nameShort: 'Clusters',
      type: 'raw',
      description: 'The number of unique jobs being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'count(count by (cassandra_cluster) (cassandra_up_endpoint_count{%(queriesSelector)s}))',
        },
      },
    },

    nodeCount: {
      name: 'Number of nodes',
      nameShort: 'Nodes',
      type: 'raw',
      description: 'The number of unique instances being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(count by ' + aggregationLabels + ' (cassandra_up_endpoint_count{%(queriesSelector)s}))',
        },
      },
    },

    downNodeCount: {
      name: 'Number of down nodes',
      nameShort: 'Down nodes',
      type: 'raw',
      description: 'The number of down nodes being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(max by ' + aggregationLabels + ' (cassandra_down_endpoint_count{%(queriesSelector)s}))',
        },
      },
    },

    connectionTimeouts: {
      name: 'Connection timeouts',
      nameShort: 'Connection timeouts',
      type: 'raw',
      description: 'The number of timeouts experienced from each node',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(increase(cassandra_connection_timeouts_count{%(queriesSelector)s}[$__interval:])) by ' + aggregationLabels,
          legendCustomTemplate: '{{ cassandra_cluster }} - {{ instance }}',
        },
      },
    },

    averageKeyCacheHitRatio: {
      name: 'Average key cache hit ratio',
      nameShort: 'Key cache hit ratio',
      type: 'raw',
      description: 'The average key cache hit ratio being reported',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'avg(cassandra_cache_hitrate{%(queriesSelector)s, cache="KeyCache"} * 100) by (cassandra_cluster)',
        },
      },
    },

    largeDroppedTasks: {
      name: 'Large dropped tasks',
      nameShort: 'Large dropped tasks',
      type: 'raw',
      description: 'The number of large dropped tasks being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_connection_largemessagedroppedtasks{%(queriesSelector)s}) by ' + aggregationLabels,
          legendCustomTemplate: '{{instance }} - large dropped',
        },
      },
    },

    largeActiveTasks: {
      name: 'Large active tasks',
      nameShort: 'Large active tasks',
      type: 'raw',
      description: 'The number of large active tasks being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_connection_largemessageactivetasks{%(queriesSelector)s}) by ' + aggregationLabels,
          legendCustomTemplate: '{{instance }} - large active',
        },
      },
    },

    largePendingTasks: {
      name: 'Large pending tasks',
      nameShort: 'Large pending tasks',
      type: 'raw',
      description: 'The number of large pending tasks being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_connection_largemessagependingtasks{%(queriesSelector)s}) by ' + aggregationLabels,
          legendCustomTemplate: '{{instance }} - large pending',
        },
      },
    },

    smallDroppedTasks: {
      name: 'Small dropped tasks',
      nameShort: 'Small dropped tasks',
      type: 'raw',
      description: 'The number of small dropped tasks being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_connection_smallmessagedroppedtasks{%(queriesSelector)s}) by ' + aggregationLabels,
          legendCustomTemplate: '{{instance }} - small dropped',
        },
      },
    },

    smallActiveTasks: {
      name: 'Small active tasks',
      nameShort: 'Small active tasks',
      type: 'raw',
      description: 'The number of small active tasks being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_connection_smallmessageactivetasks{%(queriesSelector)s}) by ' + aggregationLabels,
          legendCustomTemplate: '{{instance }} - small active',
        },
      },
    },

    smallPendingTasks: {
      name: 'Small pending tasks',
      nameShort: 'Small pending tasks',
      type: 'raw',
      description: 'The number of small pending tasks being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_connection_smallmessagependingtasks{%(queriesSelector)s}) by ' + aggregationLabels,
          legendCustomTemplate: '{{instance }} - small pending',
        },
      },
    },

    totalDiskUsage: {
      name: 'Total disk usage',
      nameShort: 'Total disk usage',
      type: 'raw',
      description: 'The total disk usage being reported',
      unit: 'bytes',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_storage_load_count{%(queriesSelector)s}) by (cassandra_cluster)',
          legendCustomTemplate: '{{ instance }}',
        },
      },
    },

    diskUsagePanel: {
      name: 'Disk usage',
      nameShort: 'Disk usage',
      type: 'raw',
      description: 'The disk usage being reported',
      unit: 'bytes',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_storage_load_count{%(queriesSelector)s}) by ' + aggregationLabels,
          legendCustomTemplate: '{{ instance }}',
        },
      },
    },

    writes: {
      name: 'Writes',
      nameShort: 'Writes',
      type: 'raw',
      description: 'The number of writes being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by (cassandra_cluster) (increase(cassandra_keyspace_writelatency_seconds_count{%(queriesSelector)s}[$__rate_interval]))',
        },
      },
    },

    reads: {
      name: 'Reads',
      nameShort: 'Reads',
      type: 'raw',
      description: 'The number of reads being reported',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by (cassandra_cluster) (increase(cassandra_keyspace_readlatency_seconds_count{%(queriesSelector)s}[$__rate_interval]))',
        },
      },
    },

    writeAverageLatency: {
      name: 'Write average latency',
      nameShort: 'Write average latency',
      type: 'gauge',
      description: 'The average write latency being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_writelatency_seconds_average{%(queriesSelector)s} >= 0) by (cassandra_cluster)',
        },
      },
    },

    readAverageLatency: {
      name: 'Read average latency',
      nameShort: 'Read average latency',
      type: 'gauge',
      description: 'The average read latency being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_readlatency_seconds_average{%(queriesSelector)s} >= 0) by (cassandra_cluster)',
        },
      },
    },

    writeLatencyHeatmap: {
      name: 'Write latency',
      nameShort: 'Write latency',
      type: 'gauge',
      description: 'The write latency being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_writelatency_seconds{%(queriesSelector)s} >= 0) by (quantile)',
        },
      },
    },

    readLatencyHeatmap: {
      name: 'Read latency',
      nameShort: 'Read latency',
      type: 'gauge',
      description: 'The read latency being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_readlatency_seconds{%(queriesSelector)s} >= 0) by (quantile)',
        },
      },
    },

    writeLatencyQuartiles: {
      name: 'Write latency quartiles p95',
      nameShort: 'Write latency quartiles p95',
      type: 'gauge',
      description: 'The write latency quartiles being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_writelatency_seconds{%(queriesSelector)s, quantile="0.95"} >= 0) by (cassandra_cluster)',
        },
      },
    },

    readLatencyQuartilesP95: {
      name: 'Read latency quartiles p95',
      nameShort: 'Read latency quartiles p95',
      type: 'gauge',
      description: 'The read latency quartiles being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_readlatency_seconds{%(queriesSelector)s, quantile="0.95"} >= 0) by (cassandra_cluster)',
          legendCustomTemplate: legendCustomTemplate + ' - p95',
        },
      },
    },
    readLatencyQuartilesP99: {
      name: 'Read latency quartiles p99',
      nameShort: 'Read latency quartiles p99',
      type: 'gauge',
      description: 'The read latency quartiles being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_readlatency_seconds{%(queriesSelector)s, quantile="0.99"} >= 0) by (cassandra_cluster)',
          legendCustomTemplate: legendCustomTemplate + ' - p99',
        },
      },
    },

    writeLatencyQuartilesP95: {
      name: 'Write latency quartiles p95',
      nameShort: 'Write latency quartiles p95',
      type: 'gauge',
      description: 'The write latency quartiles being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_writelatency_seconds{%(queriesSelector)s, quantile="0.95"} >= 0) by (cassandra_cluster)',
          legendCustomTemplate: legendCustomTemplate + ' - p95',
        },
      },
    },

    writeLatencyQuartilesP99: {
      name: 'Write latency quartiles p99',
      nameShort: 'Write latency quartiles p99',
      type: 'gauge',
      description: 'The write latency quartiles being reported',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(cassandra_keyspace_writelatency_seconds{%(queriesSelector)s, quantile="0.99"} >= 0) by (cassandra_cluster)',
          legendCustomTemplate: legendCustomTemplate + ' - p99',
        },
      },
    },


    writeRequests: {
      name: 'Write requests',
      nameShort: 'Write requests',
      type: 'raw',
      description: 'The number of write requests being reported',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum(rate(cassandra_clientrequest_latency_seconds_count{%(queriesSelector)s, clientrequest="Write"}[$__rate_interval])) by (cassandra_cluster)',
        },
      },
    },

    writeRequestsUnavailable: {
      name: 'Write requests unavailable',
      nameShort: 'Write requests unavailable',
      type: 'raw',
      description: 'The number of write requests being reported',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum(rate(cassandra_clientrequest_unavailables_count{%(queriesSelector)s, clientrequest="Write"}[$__rate_interval])) by (cassandra_cluster)',
        },
      },
    },

    writeRequestsTimedOut: {
      name: 'Write requests timed out',
      nameShort: 'Write requests timed out',
      type: 'raw',
      description: 'The number of write requests being reported',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum(rate(cassandra_clientrequest_timeouts_count{%(queriesSelector)s, clientrequest="Write"}[$__rate_interval])) by (cassandra_cluster)',
        },
      },
    },

    readRequests: {
      name: 'Read requests',
      nameShort: 'Read requests',
      type: 'raw',
      description: 'The number of read requests being reported',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum(rate(cassandra_clientrequest_latency_seconds_count{%(queriesSelector)s, clientrequest="Read"}[$__rate_interval])) by (cassandra_cluster)',
        },
      },
    },

    readRequestsTimedOut: {
      name: 'Read requests timed out',
      nameShort: 'Read requests timed out',
      type: 'raw',
      description: 'The number of read requests being reported',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum(rate(cassandra_clientrequest_timeouts_count{%(queriesSelector)s, clientrequest="Read"}[$__rate_interval])) by (cassandra_cluster)',
        },
      },
    },

    readRequestsUnavailable: {
      name: 'Read requests unavailable',
      nameShort: 'Read requests unavailable',
      type: 'raw',
      description: 'The number of read requests being reported',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum(rate(cassandra_clientrequest_unavailables_count{%(queriesSelector)s, clientrequest="Read"}[$__rate_interval])) by (cassandra_cluster)',
        },
      },
    },
  },
}
