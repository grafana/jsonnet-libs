// Cluster Overview dashboard signals for OpenSearch
// Combines signals from cluster, roles, and topk domains
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
      prometheus: 'opensearch_cluster_status',
    },
    signals: {
      // Cluster status and metrics
      cluster_status: {
        name: 'Cluster status',
        description: 'Overall cluster health status as a numeric code.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'min',
        sources: {
          prometheus: {
            expr: 'opensearch_cluster_status{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
          },
        },
      },
      cluster_nodes_number: {
        name: 'Node count',
        description: 'The number of running nodes across the OpenSearch cluster.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'min',
        sources: {
          prometheus: {
            expr: 'opensearch_cluster_nodes_number{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
          },
        },
      },
      cluster_datanodes_number: {
        name: 'Data node count',
        description: 'The number of data nodes in the OpenSearch cluster.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'min',
        sources: {
          prometheus: {
            expr: 'opensearch_cluster_datanodes_number{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
          },
        },
      },
      cluster_shards_number_total: {
        name: 'Shard count',
        description: 'The number of shards in the OpenSearch cluster across all indices.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'opensearch_cluster_shards_number{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
            aggKeepLabels: ['type'],
            exprWrappers: [['sum(', ')']],
          },
        },
      },
      cluster_shards_number_by_type: {
        name: 'Shard status',
        description: 'Shard status counts across the OpenSearch cluster.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'min',
        sources: {
          prometheus: {
            expr: 'opensearch_cluster_shards_number{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{type}}',
            aggKeepLabels: ['type'],
          },
        },
      },
      cluster_shards_active_percent: {
        name: 'Active shards %%',
        description: 'Percent of active shards across the OpenSearch cluster.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'min',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'opensearch_cluster_shards_active_percent{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
          },
        },
      },
      cluster_pending_tasks_number: {
        name: 'Pending tasks',
        description: 'The number of tasks waiting to be executed across the OpenSearch cluster.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'opensearch_cluster_pending_tasks_number{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
          },
        },
      },
      cluster_task_max_wait_seconds: {
        name: 'Task max wait time',
        description: 'The max wait time for tasks to be executed across the OpenSearch cluster.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'max',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'opensearch_cluster_task_max_waiting_time_seconds{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
          },
        },
      },
      indices_indexing_index_count_avg: {
        name: 'Total documents',
        description: 'The total count of documents indexed across the OpenSearch cluster.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'opensearch_indices_indexing_index_count{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
          },
        },
      },
      indices_store_size_bytes_avg: {
        name: 'Store size',
        description: 'The total size of the store across the OpenSearch cluster.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_indices_store_size_bytes{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{opensearch_cluster}}',
          },
        },
      },

      // Cluster role signals
      node_role_data: {
        name: 'Node role: data',
        description: 'Data role present flag.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelectorGroupOnly)s, role="data"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / data',
            aggKeepLabels: ['node', 'role'],
            exprWrappers: [['', ' * 2']],
          },
        },
      },
      node_role_master: {
        name: 'Node role: master',
        description: 'Master role present flag.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelectorGroupOnly)s, role="master"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / master',
            aggKeepLabels: ['node', 'role'],
            exprWrappers: [['', ' * 3']],

          },
        },
      },
      node_role_ingest: {
        name: 'Node role: ingest',
        description: 'Ingest role present flag.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelectorGroupOnly)s, role="ingest"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / ingest',
            aggKeepLabels: ['node', 'role'],
            exprWrappers: [['', ' * 4']],
          },
        },
      },
      node_role_cluster_manager: {
        name: 'Node role: cluster_manager',
        description: 'Cluster manager role present flag.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelectorGroupOnly)s, role="cluster_manager"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / cluster_manager',
            aggKeepLabels: ['node', 'role'],
            exprWrappers: [['', ' * 5']],
          },
        },
      },
      node_role_remote_cluster_client: {
        name: 'Node role: remote_cluster_client',
        description: 'Remote cluster client role present flag.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelectorGroupOnly)s, role="remote_cluster_client"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / remote_client',
            aggKeepLabels: ['node', 'role'],
            exprWrappers: [['', ' * 6']],
          },
        },
      },
      node_role_last_seen: {
        name: 'Node role bool last seen',
        description: 'Last seen role bool within 1d.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'last_over_time(opensearch_node_role_bool{%(queriesSelectorGroupOnly)s}[1d])',
            aggKeepLabels: ['node', 'nodeid', 'role', 'primary_ip'],
          },
        },
      },

      // Top K signals
      os_cpu_percent_topk: {
        name: 'Top nodes by CPU usage',
        description: 'Top nodes by OS CPU usage across the OpenSearch cluster.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'opensearch_os_cpu_percent{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{node}}',
            exprWrappers: [['topk($k, sort_desc(', '))']],
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
            expr: 'topk($k, sort_desc((100 * (\n'
                  + '  sum by(' + this.groupAggListWithInstance + ') (opensearch_fs_path_total_bytes{%(queriesSelectorGroupOnly)s}) - \n'
                  + '  sum by(' + this.groupAggListWithInstance + ') (opensearch_fs_path_free_bytes{%(queriesSelectorGroupOnly)s})\n'
                  + ') / \n'
                  + 'sum by(' + this.groupAggListWithInstance + ') (opensearch_fs_path_total_bytes{%(queriesSelectorGroupOnly)s})\n'
                  + ')))',
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
        unit: 'short',
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
            expr: 'topk($k, sort_desc(avg by(index, ' + this.groupAggList + ') (\n'
                  + '  opensearch_index_search_fetch_current_number{%(queriesSelectorGroupOnly)s, context="total"} + \n'
                  + '  opensearch_index_search_query_current_number{%(queriesSelectorGroupOnly)s, context="total"} + \n'
                  + '  opensearch_index_search_scroll_current_number{%(queriesSelectorGroupOnly)s, context="total"}\n'
                  + ')))',
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
            expr: 'topk($k, sort_desc(sum by(index, ' + this.groupAggList + ') ((\n'
                  + '  increase(opensearch_index_search_fetch_time_seconds{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:] offset $__interval) + \n'
                  + '  increase(opensearch_index_search_query_time_seconds{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:] offset $__interval) + \n'
                  + '  increase(opensearch_index_search_scroll_time_seconds{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:] offset $__interval)\n'
                  + ') / clamp_min(\n'
                  + '  increase(opensearch_index_search_fetch_count{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:] offset $__interval) + \n'
                  + '  increase(opensearch_index_search_query_count{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:] offset $__interval) + \n'
                  + '  increase(opensearch_index_search_scroll_count{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:] offset $__interval), 1\n'
                  + '))))',
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
            expr: 'topk($k, sort_desc(avg by(index, ' + this.groupAggList + ') (\n'
                  + '  100 * (opensearch_index_requestcache_hit_count{%(queriesSelectorGroupOnly)s, context="total"} + \n'
                  + '  opensearch_index_querycache_hit_count{%(queriesSelectorGroupOnly)s, context="total"}) / \n'
                  + '  clamp_min((opensearch_index_requestcache_hit_count{%(queriesSelectorGroupOnly)s, context="total"} + \n'
                  + '  opensearch_index_querycache_hit_count{%(queriesSelectorGroupOnly)s, context="total"} + \n'
                  + '  opensearch_index_requestcache_miss_count{%(queriesSelectorGroupOnly)s, context="total"} + \n'
                  + '  opensearch_index_querycache_miss_number{%(queriesSelectorGroupOnly)s, context="total"}), 1\n'
                  + '))))',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      ingest_throughput_topk: {
        name: 'Top nodes by ingest rate',
        description: 'Top nodes by rate of ingest across the OpenSearch cluster.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'opensearch_ingest_total_count{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{node}}',
            exprWrappers: [['topk($k, ', ')']],
            aggKeepLabels: ['node'],
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
            expr: 'topk($k, sum by(' + this.groupAggListWithInstance + ') (\n'
                  + '  increase(opensearch_ingest_total_time_seconds{%(queriesSelectorGroupOnly)s}[$__interval:] offset $__interval) / \n'
                  + '  clamp_min(increase(opensearch_ingest_total_count{%(queriesSelectorGroupOnly)s}[$__interval:] offset $__interval), 1)\n'
                  + '))',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      ingest_failures_topk: {
        name: 'Top nodes by ingest errors',
        description: 'Top nodes by ingestion failures across the OpenSearch cluster.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'opensearch_ingest_total_failed_count{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{node}}',
            rangeFunction: 'increase',
            exprWrappers: [['topk($k, ', ')']],
            aggKeepLabels: ['node'],

          },
        },
      },
      indexing_current_topk: {
        name: 'Top indices by index rate',
        description: 'Top indices by rate of document indexing across the OpenSearch cluster.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_index_current_number{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{index}}',
            exprWrappers: [['topk($k, ', ')']],
            aggKeepLabels: ['index'],
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
            expr: 'topk($k, avg by(index, ' + this.groupAggList + ') (\n'
                  + '  increase(opensearch_index_indexing_index_time_seconds{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:] offset $__interval) / \n'
                  + '  clamp_min(increase(opensearch_index_indexing_index_count{%(queriesSelectorGroupOnly)s, context="total"}[$__interval:] offset $__interval), 1)\n'
                  + '))',
            legendCustomTemplate: '{{index}}',
          },
        },
      },
      indexing_failed_topk: {
        name: 'Top indices by index failures',
        description: 'Top indices by index document failures across the OpenSearch cluster.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'avg',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'opensearch_index_indexing_index_failed_count{%(queriesSelectorGroupOnly)s}',
            legendCustomTemplate: '{{index}}',
            rangeFunction: 'increase',
            exprWrappers: [['topk($k, ', ')']],
            aggKeepLabels: ['index'],
          },
        },
      },
    },
  }
