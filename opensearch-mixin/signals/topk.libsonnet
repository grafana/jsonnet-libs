// TopK and ranking signals for OpenSearch
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
      prometheus: 'opensearch_os_cpu_percent',
    },
    signals: {
      os_cpu_percent_topk: {
        name: 'Top nodes by CPU usage',
        description: 'Top nodes by OS CPU usage across the OpenSearch cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk(10, sort_desc(sum by(' + this.groupAggListWithInstance + ') (opensearch_os_cpu_percent{%(queriesSelectorGroupOnly)s})))',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      fs_path_used_percent_topk: {
        name: 'Top nodes by disk usage',
        description: 'Top nodes by disk usage across the OpenSearch cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk(10, sort_desc((100 * (sum by(' + this.groupAggListWithInstance + ') (opensearch_fs_path_total_bytes{%(queriesSelectorGroupOnly)s})- sum by(' + this.groupAggListWithInstance + ') (opensearch_fs_path_free_bytes{%(queriesSelectorGroupOnly)s})) / sum by(' + this.groupAggListWithInstance + ') (opensearch_fs_path_total_bytes{%(queriesSelectorGroupOnly)s}))))',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      circuitbreaker_tripped_count_sum: {
        name: 'Breakers tripped',
        description: 'The total count of circuit breakers tripped across the OpenSearch cluster.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_circuitbreaker_tripped_count{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{node}}',
            rangeFunction: 'increase',
          },
        },
      },
      search_current_inflight_topk: {
        name: 'Top indices by request rate',
        description: 'Top indices by combined fetch, query, and scroll request rate across the OpenSearch cluster.',
        type: 'raw',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'topk(10, sort_desc(avg by(index, ' + this.groupAggList + ') (\n  opensearch_index_search_fetch_current_number{%(queriesSelectorGroupOnly)s, context="total"} + \n  opensearch_index_search_query_current_number{%(queriesSelectorGroupOnly)s, context="total"} + \n  opensearch_index_search_scroll_current_number{%(queriesSelectorGroupOnly)s, context="total"}\n)))\n',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      search_avg_latency_topk: {
        name: 'Top indices by request latency',
        description: 'Top indices by combined fetch, query, and scroll latency across the OpenSearch cluster.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'topk(10, sort_desc(sum by(index, ' + this.groupAggList + ') ((increase(opensearch_index_search_fetch_time_seconds{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:])\n+increase(opensearch_index_search_query_time_seconds{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:])\n+increase(opensearch_index_search_scroll_time_seconds{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:]))\n/ clamp_min(increase(opensearch_index_search_fetch_count{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:])\n+increase(opensearch_index_search_query_count{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:])\n+increase(opensearch_index_search_scroll_count{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:]), 1))))\n',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      request_query_cache_hit_rate_topk: {
        name: 'Top indices by combined cache hit ratio',
        description: 'Top indices by cache hit ratio for the combined request and query cache across the OpenSearch cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk(10, sort_desc(avg by(index, ' + this.groupAggList + ') (\n  100 * (opensearch_index_requestcache_hit_count{%(queriesSelectorGroupOnly)s, context="total"} + \n  opensearch_index_querycache_hit_count{%(queriesSelectorGroupOnly)s, context="total"}) / \n  clamp_min((opensearch_index_requestcache_hit_count{%(queriesSelectorGroupOnly)s, context="total"} + \n  opensearch_index_querycache_hit_count{%(queriesSelectorGroupOnly)s, context="total"} + \n  opensearch_index_requestcache_miss_count{%(queriesSelectorGroupOnly)s, context="total"} + \n  opensearch_index_querycache_miss_number{%(queriesSelectorGroupOnly)s, context="total"}), 1\n  ))))',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      ingest_throughput_topk: {
        name: 'Top nodes by ingest rate',
        description: 'Top nodes by rate of ingest across the OpenSearch cluster.',
        type: 'raw',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk(10, sum by(' + this.groupAggListWithInstance + ') (rate(opensearch_ingest_total_count{%(queriesSelectorGroupOnly)s}[$__rate_interval])))',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      ingest_latency_topk: {
        name: 'Top nodes by ingest latency',
        description: 'Top nodes by ingestion latency across the OpenSearch cluster.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'topk(10, sum by(' + this.groupAggListWithInstance + ') (increase(opensearch_ingest_total_time_seconds{%(queriesSelectorGroupOnly)s}[$__interval:]) / clamp_min(increase(opensearch_ingest_total_count{%(queriesSelectorGroupOnly)s}[$__interval:]), 1)))',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      ingest_failures_topk: {
        name: 'Top nodes by ingest errors',
        description: 'Top nodes by ingestion failures across the OpenSearch cluster.',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'topk(10, sum by(' + this.groupAggListWithInstance + ') (increase(opensearch_ingest_total_failed_count{%(queriesSelectorGroupOnly)s}[$__interval:])))',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      indexing_current_topk: {
        name: 'Top indices by index rate',
        description: 'Top indices by rate of document indexing across the OpenSearch cluster.',
        type: 'raw',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk(10, avg by(index, ' + this.groupAggList + ') (opensearch_index_indexing_index_current_number{%(queriesSelectorGroupOnly)s}))',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      indexing_latency_topk: {
        name: 'Top indices by index latency',
        description: 'Top indices by indexing latency across the OpenSearch cluster.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'topk(10, avg by(index, ' + this.groupAggList + ') (increase(opensearch_index_indexing_index_time_seconds{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_indexing_index_count{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:]), 1)))',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      indexing_failed_topk: {
        name: 'Top indices by index failures',
        description: 'Top indices by index document failures across the OpenSearch cluster.',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'topk(10, avg by(index, ' + this.groupAggList + ') (increase(opensearch_index_indexing_index_failed_count{%(queriesSelectorGroupOnly)s}[$__interval:])))',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
    },
  }
