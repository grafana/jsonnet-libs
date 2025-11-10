function(this) {
  local legendCustomTemplate = '{{ redis_cluster }}',
  local aggregationLabels = '(' + std.join(',', this.groupLabels + this.instanceLabels) + ')',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  legendCustomTemplate: legendCustomTemplate,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '2m',
  discoveryMetric: 'node_up',
  signals: {
    // Status signals
    nodeUp: {
      name: 'Node up',
      nameShort: 'Node up',
      type: 'raw',
      description: 'Up/down status for each node in the cluster',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'node_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{ redis_cluster }} - {{ node }}',
        },
      },
    },

    databaseUp: {
      name: 'Database up',
      nameShort: 'Database up',
      type: 'raw',
      description: 'Up/down status for each database in the cluster',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'bdb_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{ redis_cluster }} - bdb={{ bdb }}',
        },
      },
    },

    shardUp: {
      name: 'Shard up',
      nameShort: 'Shard up',
      type: 'raw',
      description: 'Up/down status for each shard in the cluster',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'redis_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{ redis_cluster }} - redis: {{ redis }}',
        },
      },
    },

    // Cluster aggregate signals
    clusterTotalRequests: {
      name: 'Cluster total requests',
      nameShort: 'Total requests',
      type: 'raw',
      description: 'Total requests handled by endpoints aggregated across all nodes',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(node_total_req{%(queriesSelector)s}) by (redis_cluster, job)',
          legendCustomTemplate: '{{ redis_cluster }}',
        },
      },
    },

    clusterTotalMemoryUsed: {
      name: 'Cluster total memory used',
      nameShort: 'Total memory used',
      type: 'raw',
      description: 'Total memory used by each database in the cluster',
      unit: 'bytes',
      sources: {
        prometheus: {
          expr: 'sum(bdb_used_memory{%(queriesSelector)s}) by (job, bdb, redis_cluster)',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }}',
        },
      },
    },

    clusterTotalConnections: {
      name: 'Cluster total connections',
      nameShort: 'Total connections',
      type: 'raw',
      description: 'Total connections to each database in the cluster',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(bdb_conns{%(queriesSelector)s}) by (bdb, redis_cluster, job)',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }}',
        },
      },
    },

    clusterTotalKeys: {
      name: 'Cluster total keys',
      nameShort: 'Total keys',
      type: 'raw',
      description: 'Total cluster key count for each database in the cluster',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(bdb_no_of_keys{%(queriesSelector)s}) by (redis_cluster, bdb, job)',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }}',
        },
      },
    },

    clusterCacheHitRatio: {
      name: 'Cluster cache hit ratio',
      nameShort: 'Cache hit ratio',
      type: 'raw',
      description: 'Ratio of database cache key hits against hits and misses',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'bdb_read_hits{%(queriesSelector)s} / (clamp_min(bdb_read_hits{%(queriesSelector)s} + bdb_read_misses{%(queriesSelector)s}, 1)) * 100',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }}',
        },
      },
    },

    clusterEvictedObjects: {
      name: 'Cluster evicted objects',
      nameShort: 'Evicted objects',
      type: 'raw',
      description: 'Sum of key evictions in the cluster by database',
      unit: 'ops',
      sources: {
        prometheus: {
          expr: 'bdb_evicted_objects{%(queriesSelector)s}',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }} - evicted',
        },
      },
    },

    clusterExpiredObjects: {
      name: 'Cluster expired objects',
      nameShort: 'Expired objects',
      type: 'raw',
      description: 'Sum of key expirations in the cluster by database',
      unit: 'ops',
      sources: {
        prometheus: {
          expr: 'bdb_expired_objects{%(queriesSelector)s}',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }} - expired',
        },
      },
    },

    // Node KPI signals
    nodeRequests: {
      name: 'Node requests',
      nameShort: 'Requests',
      type: 'raw',
      description: 'Endpoint request rate for each node in the cluster',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'rate(node_total_req{%(queriesSelector)s}[$__rate_interval])',
          legendCustomTemplate: '{{ redis_cluster }} - node: {{ node }}',
        },
      },
    },

    nodeAverageLatency: {
      name: 'Node average latency',
      nameShort: 'Avg latency',
      type: 'raw',
      description: 'Average latency for each node in the cluster',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'node_avg_latency{%(queriesSelector)s}',
          legendCustomTemplate: '{{ redis_cluster }} - node: {{ node }}',
        },
      },
    },

    nodeMemoryUtilization: {
      name: 'Node memory utilization',
      nameShort: 'Memory utilization',
      type: 'raw',
      description: 'Memory utilization % for each node in the cluster',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '(sum(redis_used_memory{%(queriesSelector)s}) by (redis_cluster, node, job) / clamp_min(sum(node_available_memory{%(queriesSelector)s}) by (redis_cluster, node, job), 1)) * 100',
          legendCustomTemplate: '{{ redis_cluster }} - node: {{ node }}',
        },
      },
    },

    nodeCPUSystem: {
      name: 'Node CPU system',
      nameShort: 'CPU system',
      type: 'raw',
      description: 'System CPU utilization for each node in the cluster',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'node_cpu_system{%(queriesSelector)s} * 100',
          legendCustomTemplate: 'node: {{ node }} - system',
        },
      },
    },

    nodeCPUUser: {
      name: 'Node CPU user',
      nameShort: 'CPU user',
      type: 'raw',
      description: 'User CPU utilization for each node in the cluster',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'node_cpu_user{%(queriesSelector)s} * 100',
          legendCustomTemplate: 'node: {{ node }} - user',
        },
      },
    },

    // Database KPI signals
    databaseOperations: {
      name: 'Database operations',
      nameShort: 'Operations',
      type: 'raw',
      description: 'Rate of requests handled by each database in the cluster',
      unit: 'ops',
      sources: {
        prometheus: {
          expr: 'sum(bdb_instantaneous_ops_per_sec{%(queriesSelector)s}) by (redis_cluster, bdb, job)',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }}',
        },
      },
    },

    databaseAverageLatency: {
      name: 'Database average latency',
      nameShort: 'Avg latency',
      type: 'raw',
      description: 'Average latency for each database in the cluster',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum(bdb_avg_latency{%(queriesSelector)s}) by (redis_cluster, job, bdb)',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }}',
        },
      },
    },

    databaseMemoryUtilization: {
      name: 'Database memory utilization',
      nameShort: 'Memory utilization',
      type: 'raw',
      description: 'Calculated memory utilization % for each database in the cluster',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'sum(bdb_used_memory{%(queriesSelector)s}) by (job, redis_cluster, bdb) / clamp_min(sum(bdb_memory_limit{%(queriesSelector)s}) by (job, redis_cluster, bdb), 1) * 100',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }}',
        },
      },
    },

    databaseCacheHitRatio: {
      name: 'Database cache hit ratio',
      nameShort: 'Cache hit ratio',
      type: 'raw',
      description: 'Calculated cache hit rate for each database in the cluster',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'sum(bdb_read_hits{%(queriesSelector)s}) by (job, redis_cluster, bdb) / clamp_min(sum(bdb_read_hits{%(queriesSelector)s}) by (job, redis_cluster, bdb) + sum(bdb_read_misses{%(queriesSelector)s}) by (job, redis_cluster, bdb), 1) * 100',
          legendCustomTemplate: '{{ redis_cluster }} - db: {{ bdb }}',
        },
      },
    },
  },
}
