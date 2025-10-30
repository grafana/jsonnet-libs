// Indexing operation signals for OpenSearch
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'opensearch_index_indexing_index_current_number',
    },
    signals: {
      indexing_current: {
        name: 'Indexing current',
        description: 'In-flight indexing operations.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_index_current_number{%(queriesSelectorGroupOnly)s,index=~"$index",context="total"}',
            legendCustomTemplate: '{{index}}',
            aggKeepLabels: ['index'],
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
            expr: 'avg by(' + this.groupAggList + ') (increase(opensearch_index_indexing_index_time_seconds{%(queriesSelector)s, context=~"total"}[$__interval:]) / clamp_min(increase(opensearch_index_indexing_index_count{%(queriesSelector)s, context=~"total"}[$__interval:]),1))',
          },
        },
      },
      indexing_count: {
        name: 'Indexing count (avg)',
        description: 'Indexing ops count.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'documents',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_index_count{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}',
            legendCustomTemplate: '{{index}}',
            aggKeepLabels: ['index'],
          },
        },
      },
      indexing_failed: {
        name: 'Indexing failed (avg)',
        description: 'Indexing failures per interval.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'failures',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_index_failed_count{%(queriesSelectorGroupOnly)s,index=~"$index",context="total"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{index}}',
            aggKeepLabels: ['index'],
          },
        },
      },
      indexing_delete_current: {
        name: 'Indexing delete current',
        description: 'In-flight delete operations.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'documents/s',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_delete_current_number{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}',
            legendCustomTemplate: '{{index}}',
            aggKeepLabels: ['index'],
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
            expr: 'avg by(' + this.groupAggList + ',index) (increase(opensearch_index_flush_total_time_seconds{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_flush_total_count{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}[$__interval:]),1))',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      flush_count: {
        name: 'Flush count (avg)',
        description: 'Flush count proxy (per mapping).',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'avg by(' + this.groupAggList + ') (increase(opensearch_index_flush_total_time_seconds{%(queriesSelector)s, context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_flush_total_count{%(queriesSelector)s, context="total"}[$__interval:]),1))',
          },
        },
      },
      merge_time: {
        name: 'Merge time increase',
        description: 'Merge time increase (boolean >0).',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by(job,opensearch_cluster,index) (increase(opensearch_index_merges_total_time_seconds{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}[$__interval:])) > 0',
            legendCustomTemplate: '{{index}} - total',
          },
        },
      },
      merge_stopped_time: {
        name: 'Merge stopped time increase',
        description: 'Merge stopped time increase (boolean >0).',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by(job,opensearch_cluster,index) (increase(opensearch_index_merges_total_stopped_time_seconds{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}[$__interval:])) > 0',
            legendCustomTemplate: '{{index}} - stopped',
          },
        },
      },
      merge_throttled_time: {
        name: 'Merge throttled time increase',
        description: 'Merge throttled time increase (boolean >0).',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by(job,opensearch_cluster,index) (increase(opensearch_index_merges_total_throttled_time_seconds{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}[$__interval:])) > 0',
            legendCustomTemplate: '{{index}} - throttled',
          },
        },
      },
      merge_docs: {
        name: 'Merge docs increase',
        description: 'Merge docs increase (boolean >0).',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'avg by(' + this.groupAggList + ') (increase(opensearch_index_merges_total_docs_count{%(queriesSelector)s, context="total"}[$__interval:])) > 0',
          },
        },
      },
      merge_current_size: {
        name: 'Merge current size bytes',
        description: 'Merge current size (boolean >0).',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by(' + this.groupAggList + ',index) (opensearch_index_merges_current_size_bytes{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}) > 0',
            legendCustomTemplate: '{{index}}',
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
            expr: 'avg by(job,opensearch_cluster,index) (increase(opensearch_index_refresh_total_time_seconds{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_refresh_total_count{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}[$__interval:]),1))',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      refresh_count: {
        name: 'Refresh count (avg)',
        description: 'Refresh count proxy (per mapping).',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'avg by(' + this.groupAggList + ') (increase(opensearch_index_refresh_total_time_seconds{%(queriesSelector)s, context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_refresh_total_count{%(queriesSelector)s, context="total"}[$__interval:]),1))',
          },
        },
      },
      translog_ops: {
        name: 'Translog operations',
        description: 'Translog operation count.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'operations',
        sources: {
          prometheus: {
            expr: 'opensearch_index_translog_operations_number{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}',
            legendCustomTemplate: '{{index}}',
            aggKeepLabels: ['index'],
          },
        },
      },
      segments_number: {
        name: 'Segments number',
        description: 'Number of segments.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'segments',
        sources: {
          prometheus: {
            expr: 'opensearch_index_segments_number{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}',
            legendCustomTemplate: '{{index}}',
            aggKeepLabels: ['index'],
          },
        },
      },
      segments_memory_bytes: {
        name: 'Segments memory bytes',
        description: 'Segment memory usage.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_index_segments_memory_bytes{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}',
            legendCustomTemplate: '{{index}}',
            aggKeepLabels: ['index'],
          },
        },
      },
      store_size_bytes: {
        name: 'Store size bytes',
        description: 'Store size in bytes.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_index_store_size_bytes{%(queriesSelectorGroupOnly)s,index=~"$index", context="total"}',
            legendCustomTemplate: '{{index}}',
            aggKeepLabels: ['index'],
          },
        },
      },
      shards_per_index: {
        name: 'Active shards per index',
        description: 'Active shards per index.',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'sum by (index) (avg by(' + this.groupAggList + ') (opensearch_index_shards_number{%(queriesSelector)s, type=~"active|active_primary"}))',
            legendCustomTemplate: '{{ index }}',
          },
        },
      },
    },
  }
