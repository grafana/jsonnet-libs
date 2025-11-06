local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  local groupAggList = std.join(',', this.groupLabels);
  local groupAggListWithInstance = groupAggList + ', ' + std.join(',', this.instanceLabels);
  local legendCustomTemplate = '{{instance}}';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    legendCustomTemplate: legendCustomTemplate,
    discoveryMetric: {
      prometheus: 'server_region_count',
    },
    signals: {
      // Region and store metrics
      regionCount: {
        name: 'Region count',
        type: 'gauge',
        description: 'The number of regions hosted by the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'server_region_count{%(queriesSelector)s}',
          },
        },
      },

      storeFileCount: {
        name: 'Store file count',
        type: 'gauge',
        description: 'The number of store files on disk currently managed by the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'server_store_file_count{%(queriesSelector)s}',
          },
        },
      },

      storeFileSize: {
        name: 'Store file size',
        type: 'gauge',
        description: 'The total size of the store files on disk managed by the RegionServer.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'server_store_file_size{%(queriesSelector)s}',
          },
        },
      },

      // Connection metrics
      rpcConnections: {
        name: 'RPC connections',
        type: 'gauge',
        description: 'The number of open connections to the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'region_server_num_open_connections{%(queriesSelector)s}',
          },
        },
      },

      // Request metrics
      totalRequestRate: {
        name: 'Total requests',
        type: 'counter',
        description: 'The rate of requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'server_total_request_count{%(queriesSelector)s}',
          },
        },
      },

      readRequestRate: {
        name: 'Read requests',
        type: 'raw',
        description: 'The rate of read requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_read_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'read',
          },
        },
      },

      writeRequestRate: {
        name: 'Write requests',
        type: 'raw',
        description: 'The rate of write requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_write_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'write',
          },
        },
      },

      cpRequestRate: {
        name: 'Copy requests',
        type: 'raw',
        description: 'The rate of copy requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_cp_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'copy',
          },
        },
      },

      filteredReadRequestRate: {
        name: 'Filtered read requests',
        type: 'raw',
        description: 'The rate of filtered read requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_filtered_read_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'filtered read',
          },
        },
      },

      rpcGetRequestRate: {
        name: 'RPC get requests',
        type: 'raw',
        description: 'The rate of RPC get requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_rpc_get_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'rpc get',
          },
        },
      },

      rpcScanRequestRate: {
        name: 'RPC scan requests',
        type: 'raw',
        description: 'The rate of RPC scan requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_rpc_scan_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'rpc scan',
          },
        },
      },

      rpcFullScanRequestRate: {
        name: 'RPC full scan requests',
        type: 'raw',
        description: 'The rate of RPC full scan requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_rpc_full_scan_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'rpc full scan',
          },
        },
      },

      rpcMutateRequestRate: {
        name: 'RPC mutate requests',
        type: 'raw',
        description: 'The rate of RPC mutate requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_rpc_mutate_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'rpc mutate',
          },
        },
      },

      rpcMultiRequestRate: {
        name: 'RPC multi requests',
        type: 'raw',
        description: 'The rate of RPC multi requests received by the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (server_rpc_multi_request_count{%(queriesSelector)s})',
            legendCustomTemplate: 'rpc multi',
          },
        },
      },

      // Queue metrics
      callsInGeneralQueue: {
        name: 'Calls in general queue',
        type: 'gauge',
        description: 'Number of calls waiting in the general queue of the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (region_server_num_calls_in_general_queue{%(queriesSelector)s})',
            legendCustomTemplate: 'general',
          },
        },
      },

      callsInReplicationQueue: {
        name: 'Calls in replication queue',
        type: 'gauge',
        description: 'Number of calls waiting in the replication queue of the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (region_server_num_calls_in_replication_queue{%(queriesSelector)s})',
            legendCustomTemplate: 'replication',
          },
        },
      },

      callsInReadQueue: {
        name: 'Calls in read queue',
        type: 'gauge',
        description: 'Number of calls waiting in the read queue of the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (region_server_num_calls_in_read_queue{%(queriesSelector)s})',
            legendCustomTemplate: 'read',
          },
        },
      },

      callsInWriteQueue: {
        name: 'Calls in write queue',
        type: 'gauge',
        description: 'Number of calls waiting in the write queue of the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (region_server_num_calls_in_write_queue{%(queriesSelector)s})',
            legendCustomTemplate: 'write',
          },
        },
      },

      callsInScanQueue: {
        name: 'Calls in scan queue',
        type: 'gauge',
        description: 'Number of calls waiting in the scan queue of the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (region_server_num_calls_in_scan_queue{%(queriesSelector)s})',
            legendCustomTemplate: 'scan',
          },
        },
      },

      callsInPriorityQueue: {
        name: 'Calls in priority queue',
        type: 'gauge',
        description: 'Number of calls waiting in the priority queue of the RegionServer.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (region_server_num_calls_in_priority_queue{%(queriesSelector)s})',
            legendCustomTemplate: 'priority',
          },
        },
      },

      // Slow operations
      slowAppendRate: {
        name: 'Slow appends',
        type: 'raw',
        description: 'The rate of slow append operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(server_slow_append_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'append',
          },
        },
      },

      slowPutRate: {
        name: 'Slow puts',
        type: 'raw',
        description: 'The rate of slow put operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(server_slow_put_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'put',
          },
        },
      },

      slowDeleteRate: {
        name: 'Slow deletes',
        type: 'raw',
        description: 'The slow delete operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(server_slow_delete_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'delete',
          },
        },
      },

      slowGetRate: {
        name: 'Slow gets',
        type: 'raw',
        description: 'The rate of slow get operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(server_slow_get_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'get',
          },
        },
      },

      slowIncrementRate: {
        name: 'Slow increments',
        type: 'raw',
        description: 'The rate of slow increment operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(server_slow_increment_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'increment',
          },
        },
      },

      // Cache metrics
      blockCacheHitPercent: {
        name: 'Block cache hit percentage',
        type: 'gauge',
        description: 'The percent of time that requests hit the cache.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'server_block_cache_express_hit_percent{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // JVM memory for RegionServers
      jvmHeapMemoryUsage: {
        name: 'RegionServer JVM heap memory usage',
        type: 'raw',
        description: 'Heap memory usage for the RegionServer JVM.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'jvm_metrics_mem_heap_used_m{%(queriesSelector)s, processname="RegionServer"} / clamp_min(jvm_metrics_mem_heap_committed_m{%(queriesSelector)s, processname="RegionServer"}, 1)',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      regionServerAuthenticationSuccess: {
        name: 'RegionServer authentication successes',
        type: 'raw',
        description: 'The rate of successful authentications to the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(region_server_authentication_successes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'success',
          },
        },
      },

      regionServerAuthenticationFailure: {
        name: 'RegionServer authentication failures',
        type: 'raw',
        description: 'The rate of failed authentications to the RegionServer.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(region_server_authentication_failures{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'failure',
          },
        },
      },
    },
  }
