// Search and Index Overview dashboard signals for OpenSearch
// Combines signals from search and indexing domains
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + ['index'],
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'opensearch_index_search_fetch_count',
    },
    signals: {
      // Search performance signals
      search_query_current_avg: {
        name: 'Search queries in-flight',
        description: 'In-flight search queries.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'opensearch_index_search_query_current_number{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}} - query',
          },
        },
      },
      search_fetch_current_avg: {
        name: 'Search fetch in-flight',
        description: 'In-flight fetch operations.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'opensearch_index_search_fetch_current_number{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}} - fetch',
          },
        },
      },
      search_scroll_current_avg: {
        name: 'Search scroll in-flight',
        description: 'In-flight scroll operations.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'opensearch_index_search_scroll_current_number{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}} - scroll',
          },
        },
      },
      search_query_latency_avg: {
        name: 'Search query latency (avg)',
        description: 'Average query latency.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by (job,opensearch_cluster,index) (\n'
                  + '  increase(opensearch_index_search_query_time_seconds{%(queriesSelector)s}[$__interval:] offset $__interval) / \n'
                  + '  clamp_min(increase(opensearch_index_search_query_count{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval), 1)\n'
                  + ')',
            legendCustomTemplate: '{{index}} - query',
          },
        },
      },
      search_fetch_latency_avg: {
        name: 'Search fetch latency (avg)',
        description: 'Average fetch latency.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by (job,opensearch_cluster,index) (\n'
                  + '  increase(opensearch_index_search_fetch_time_seconds{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval) / \n'
                  + '  clamp_min(increase(opensearch_index_search_fetch_count{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval), 1)\n'
                  + ')',
            legendCustomTemplate: '{{index}} - fetch',
          },
        },
      },
      search_scroll_latency_avg: {
        name: 'Search scroll latency (avg)',
        description: 'Average scroll latency.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by (job,opensearch_cluster,index) (\n'
                  + '  increase(opensearch_index_search_scroll_time_seconds{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval) / \n'
                  + '  clamp_min(increase(opensearch_index_search_scroll_count{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval), 1)\n'
                  + ')',
            legendCustomTemplate: '{{index}} - scroll',
          },
        },
      },
      request_cache_hit_rate: {
        name: 'Request cache hit rate %%',
        description: 'Request cache hit rate.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'avg by(job,opensearch_cluster,index) (\n'
                  + '  100 * (opensearch_index_requestcache_hit_count{%(queriesSelector)s, context="total"}) / \n'
                  + '  clamp_min(opensearch_index_requestcache_hit_count{%(queriesSelector)s, context="total"} + \n'
                  + '  opensearch_index_requestcache_miss_count{%(queriesSelector)s, context="total"}, 1)\n'
                  + ')',
            legendCustomTemplate: '{{index}} - request',
          },
        },
      },
      query_cache_hit_rate: {
        name: 'Query cache hit rate %%',
        description: 'Query cache hit rate.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'avg by(job,opensearch_cluster,index) (\n'
                  + '  100 * (opensearch_index_querycache_hit_count{%(queriesSelector)s, context="total"}) / \n'
                  + '  clamp_min(opensearch_index_querycache_hit_count{%(queriesSelector)s, context="total"} + \n'
                  + '  opensearch_index_querycache_miss_number{%(queriesSelector)s, context="total"}, 1)\n'
                  + ')',
            legendCustomTemplate: '{{index}} - query',
          },
        },
      },
      query_cache_evictions: {
        name: 'Query cache evictions',
        description: 'Query cache evictions per interval.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_index_querycache_evictions_count{%(queriesSelector)s, context="total"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{index}} - query cache',
          },
        },
      },
      request_cache_evictions: {
        name: 'Request cache evictions',
        description: 'Request cache evictions per interval.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_index_requestcache_evictions_count{%(queriesSelector)s, context="total"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{index}} - request cache',
          },
        },
      },
      fielddata_evictions: {
        name: 'Fielddata evictions',
        description: 'Fielddata evictions per interval.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_index_fielddata_evictions_count{%(queriesSelector)s, context="total"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{index}} - field data',
          },
        },
      },
      query_cache_memory: {
        name: 'Query cache memory bytes',
        description: 'Query cache memory.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_index_querycache_memory_size_bytes{%(queriesSelector)s, context="total"}',
          },
        },
      },
      request_cache_memory: {
        name: 'Request cache memory bytes',
        description: 'Request cache memory.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_index_requestcache_memory_size_bytes{%(queriesSelector)s, context="total"}',
          },
        },
      },

      // Indexing performance signals
      indexing_current: {
        name: 'Indexing current',
        description: 'In-flight indexing operations.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_index_current_number{%(queriesSelector)s,context="total"}',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      indexing_latency: {
        name: 'Indexing latency (avg)',
        description: 'Average indexing latency.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by(' + this.groupAggList + ') (\n'
                  + '  increase(opensearch_index_indexing_index_time_seconds{%(queriesSelector)s, context=~"total"}[$__interval:] offset $__interval) / \n'
                  + '  clamp_min(increase(opensearch_index_indexing_index_count{%(queriesSelector)s, context=~"total"}[$__interval:] offset $__interval), 1)\n'
                  + ')',
          },
        },
      },
      indexing_count: {
        name: 'Indexing count (avg)',
        description: 'Indexing ops count.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'documents',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_index_count{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      indexing_failed: {
        name: 'Indexing failed (avg)',
        description: 'Indexing failures per interval.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'failures',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_index_failed_count{%(queriesSelector)s,context="total"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      indexing_delete_current: {
        name: 'Indexing delete current',
        description: 'In-flight delete operations.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'documents/s',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_delete_current_number{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      flush_latency: {
        name: 'Flush latency (avg)',
        description: 'Average flush latency.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by(' + this.groupAggList + ',index) (\n'
                  + '  increase(opensearch_index_flush_total_time_seconds{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval) / \n'
                  + '  clamp_min(increase(opensearch_index_flush_total_count{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval), 1)\n'
                  + ')',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      merge_time: {
        name: 'Merge time increase',
        description: 'Merge time increase (boolean >0).',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'opensearch_index_merges_total_time_seconds{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}} - total',
            rangeFunction: 'increase',
            exprWrappers: [['(', ') > 0']],
          },
        },
      },

      merge_stopped_time: {
        name: 'Merge stopped time increase',
        description: 'Merge stopped time increase (boolean >0).',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'opensearch_index_merges_total_stopped_time_seconds{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}} - stopped',
            rangeFunction: 'increase',
            exprWrappers: [['(', ') > 0']],
          },
        },
      },
      merge_throttled_time: {
        name: 'Merge throttled time increase',
        description: 'Merge throttled time increase (boolean >0).',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'opensearch_index_merges_total_throttled_time_seconds{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}} - throttled',
            rangeFunction: 'increase',
            exprWrappers: [['(', ') > 0']],
          },
        },
      },
      merge_docs: {
        name: 'Merge docs increase',
        description: 'Merge docs increase (boolean >0).',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_index_merges_total_docs_count{%(queriesSelector)s, context="total"}',
            rangeFunction: 'increase',
            exprWrappers: [['(', ') > 0']],
          },
        },
      },
      merge_current_size: {
        name: 'Merge current size bytes',
        description: 'Merge current size (boolean >0).',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_index_merges_current_size_bytes{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}}',
            exprWrappers: [['(', ') > 0']],
          },
        },
      },
      refresh_latency: {
        name: 'Refresh latency (avg)',
        description: 'Average refresh latency.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by(job,opensearch_cluster,index) (\n'
                  + '  increase(opensearch_index_refresh_total_time_seconds{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval) / \n'
                  + '  clamp_min(increase(opensearch_index_refresh_total_count{%(queriesSelector)s, context="total"}[$__interval:] offset $__interval), 1)\n'
                  + ')',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      translog_ops: {
        name: 'Translog operations',
        description: 'Translog operation count.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'operations',
        sources: {
          prometheus: {
            expr: 'opensearch_index_translog_operations_number{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      segments_number: {
        name: 'Segments number',
        description: 'Number of segments.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'segments',
        sources: {
          prometheus: {
            expr: 'opensearch_index_segments_number{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      segments_memory_bytes: {
        name: 'Segments memory bytes',
        description: 'Segment memory usage.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_index_segments_memory_bytes{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      store_size_bytes: {
        name: 'Store size bytes',
        description: 'Store size in bytes.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_index_store_size_bytes{%(queriesSelector)s, context="total"}',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      shards_per_index: {
        name: 'Active shards per index',
        description: 'Active shards per index.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'avg',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_index_shards_number{%(queriesSelector)s, type=~"active|active_primary"}',
            legendCustomTemplate: '{{ index }}',
            exprWrappers: [['sum by (index) (', ')']],
          },
        },
      },
    },
  }
