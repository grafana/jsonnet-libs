local commonlib = import 'common-lib/common/main.libsonnet';

function(this) {
  local legendCustomTemplate = std.join(',', std.map(function(label) '{{ ' + label + ' }}', this.databaseLabels)),
  local databaseFilters = commonlib.utils.labelsToPromQLSelector(this.databaseLabels),
  local nodeFilters = commonlib.utils.labelsToPromQLSelector(this.nodeLabels),
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  legendCustomTemplate: legendCustomTemplate,
  aggLevel: 'none',
  aggFunction: 'avg',
  discoveryMetric: 'bdb_up',
  signals: {
    databaseUp: {
      name: 'Database up',
      nameShort: 'Up',
      type: 'raw',
      description: 'Displays up/down status for the selected database',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'bdb_up{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    shardUp: {
      name: 'Shard up',
      nameShort: 'Shard up',
      type: 'raw',
      description: 'Displays up/down status for each shard related to the database',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'redis_up{%(queriesSelector)s, ' + databaseFilters + '}',
          legendCustomTemplate: '{{ bdb }} - redis: {{ redis }}',
        },
      },
    },

    nodeUp: {
      name: 'Nodes up',
      nameShort: 'Nodes up',
      type: 'raw',
      description: 'Displays up/down status for each node related to the database',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'node_up{%(queriesSelector)s, ' + nodeFilters + '}',
          legendCustomTemplate: '{{ node }}',
        },
      },
    },

    databaseReadRequests: {
      name: 'Database read requests',
      nameShort: 'Read requests',
      type: 'raw',
      description: 'Rate of read requests',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'bdb_read_req{%(queriesSelector)s, ' + databaseFilters + '}',
          legendCustomTemplate: '{{ bdb }} - read',
        },
      },
    },

    databaseWriteRequests: {
      name: 'Database write requests',
      nameShort: 'Write requests',
      type: 'raw',
      description: 'Rate of write requests',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'bdb_write_req{%(queriesSelector)s, ' + databaseFilters + '}',
          legendCustomTemplate: '{{ bdb }} - write',
        },
      },
    },

    databaseReadLatency: {
      name: 'Database read latency',
      nameShort: 'Read latency',
      type: 'gauge',
      description: 'Average latency for read requests',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'bdb_avg_read_latency{%(queriesSelector)s, ' + databaseFilters + '}',
          legendCustomTemplate: '{{ bdb }} - read',
        },
      },
    },

    databaseWriteLatency: {
      name: 'Database write latency',
      nameShort: 'Write latency',
      type: 'gauge',
      description: 'Average latency for write requests',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'bdb_avg_write_latency{%(queriesSelector)s, ' + databaseFilters + '}',
          legendCustomTemplate: '{{ bdb }} - write',
        },
      },
    },

    databaseKeys: {
      name: 'Database key count',
      nameShort: 'Keys',
      type: 'gauge',
      description: 'Number of keys in the database',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'bdb_no_of_keys{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    databaseCacheHitRatio: {
      name: 'Database cache hit ratio',
      nameShort: 'Cache hit ratio',
      type: 'raw',
      description: 'Calculated cache hit rate for the database',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'sum(bdb_read_hits{%(queriesSelector)s, ' + databaseFilters + '}) by (job, redis_cluster, bdb) / clamp_min(sum(bdb_read_hits{%(queriesSelector)s, ' + databaseFilters + '}) by (job, redis_cluster, bdb) + sum(bdb_read_misses{%(queriesSelector)s, ' + databaseFilters + '}) by (job, redis_cluster, bdb), 1) * 100',
        },
      },
    },

    databaseEvictedObjects: {
      name: 'Database evicted objects',
      nameShort: 'Evicted',
      type: 'gauge',
      description: 'Number of evicted objects from the database',
      unit: 'ops',
      sources: {
        prometheus: {
          expr: 'bdb_evicted_objects{%(queriesSelector)s, ' + databaseFilters + '}',
          legendCustomTemplate: legendCustomTemplate + ' - evicted',
        },
      },
    },

    databaseExpiredObjects: {
      name: 'Database expired objects',
      nameShort: 'Expired',
      type: 'gauge',
      description: 'Number of expired objects from the database',
      unit: 'ops',
      sources: {
        prometheus: {
          expr: 'bdb_expired_objects{%(queriesSelector)s, ' + databaseFilters + '}',
          legendCustomTemplate: legendCustomTemplate + ' - expired',
        },
      },
    },

    databaseMemoryUtilization: {
      name: 'Database memory utilization',
      nameShort: 'Memory utilization',
      type: 'raw',
      description: 'Calculated memory utilization % of the database compared to the limit',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'bdb_used_memory{%(queriesSelector)s, ' + databaseFilters + '} / bdb_memory_limit{%(queriesSelector)s, ' + databaseFilters + '} * 100',
        },
      },
    },

    databaseMemoryFragmentationRatio: {
      name: 'Database memory fragmentation ratio',
      nameShort: 'Memory fragmentation',
      type: 'gauge',
      description: 'RAM fragmentation ratio between RSS and allocated RAM',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'bdb_mem_frag_ratio{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    databaseLUAHeapSize: {
      name: 'Database LUA heap size',
      nameShort: 'LUA heap',
      type: 'gauge',
      description: 'LUA scripting heap size',
      unit: 'bytes',
      sources: {
        prometheus: {
          expr: 'bdb_mem_size_lua{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    databaseNetworkIngress: {
      name: 'Database network ingress',
      nameShort: 'Network in',
      type: 'gauge',
      description: 'Rate of incoming network traffic',
      unit: 'binBps',
      sources: {
        prometheus: {
          expr: 'bdb_ingress_bytes{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    databaseNetworkEgress: {
      name: 'Database network egress',
      nameShort: 'Network out',
      type: 'gauge',
      description: 'Rate of outgoing network traffic',
      unit: 'binBps',
      sources: {
        prometheus: {
          expr: 'bdb_egress_bytes{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    databaseConnections: {
      name: 'Database connections',
      nameShort: 'Connections',
      type: 'gauge',
      description: 'Number of client connections',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'bdb_conns{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    syncStatus: {
      name: 'Sync status',
      nameShort: 'Sync status',
      type: 'gauge',
      description: 'Sync status for CRDB traffic (0=in-sync, 1=syncing, 2=out of sync)',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'bdb_crdt_syncer_status{%(queriesSelector)s, ' + databaseFilters + '}',
          legendCustomTemplate: '{{ bdb }} - repl_id: {{ crdt_replica_id }}',
        },
      },
    },

    localLag: {
      name: 'Local lag',
      nameShort: 'Local lag',
      type: 'gauge',
      description: 'Lag between source and destination for CRDB traffic',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'bdb_crdt_syncer_local_ingress_lag_time{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    crdbIngressCompressed: {
      name: 'CRDB ingress compressed',
      nameShort: 'CRDB in (compressed)',
      type: 'gauge',
      description: 'Rate of compressed network traffic to the CRDB',
      unit: 'binBps',
      sources: {
        prometheus: {
          expr: 'bdb_crdt_syncer_ingress_bytes{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },

    crdbIngressDecompressed: {
      name: 'CRDB ingress decompressed',
      nameShort: 'CRDB in (decompressed)',
      type: 'gauge',
      description: 'Rate of decompressed network traffic to the CRDB',
      unit: 'binBps',
      sources: {
        prometheus: {
          expr: 'bdb_crdt_ingress_bytes_decompressed{%(queriesSelector)s, ' + databaseFilters + '}',
        },
      },
    },
  },
}
