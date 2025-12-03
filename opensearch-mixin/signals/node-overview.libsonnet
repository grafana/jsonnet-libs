// Node Overview dashboard signals for OpenSearch
// Combines signals from roles and node domains
function(this)
  local aggLabelsList = this.groupAggListWithInstance + ',node';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + ['node'],
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'opensearch_os_cpu_percent',
    },
    signals: {
      // Node role signals
      node_role_data: {
        name: 'Node role: data',
        description: 'Data role present flag.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="data"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / data',
            aggKeepLabels: ['role'],
            exprWrappers: [['', ' * 2']],
          },
        },
      },
      node_role_master: {
        name: 'Node role: master',
        description: 'Master role present flag.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="master"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / master',
            aggKeepLabels: ['role'],
            exprWrappers: [['', ' * 3']],
          },
        },
      },
      node_role_ingest: {
        name: 'Node role: ingest',
        description: 'Ingest role present flag.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="ingest"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / ingest',
            aggKeepLabels: ['role'],
            exprWrappers: [['', ' * 4']],
          },
        },
      },
      node_role_cluster_manager: {
        name: 'Node role: cluster_manager',
        description: 'Cluster manager role present flag.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="cluster_manager"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / cluster_manager',
            aggKeepLabels: ['role'],
            exprWrappers: [['', ' * 5']],
          },
        },
      },
      node_role_remote_cluster_client: {
        name: 'Node role: remote_cluster_client',
        description: 'Remote cluster client role present flag.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="remote_cluster_client"}[1m]) == 1',
            legendCustomTemplate: '{{ node }} / remote_client',
            aggKeepLabels: ['role'],
            exprWrappers: [['', ' * 6']],
          },
        },
      },

      // Node health and resource signals
      os_cpu_percent: {
        name: 'CPU %%',
        description: 'Node CPU percent.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'opensearch_os_cpu_percent{%(queriesSelector)s}',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      os_mem_used_percent: {
        name: 'Memory used %%',
        description: 'Node memory used percent.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'opensearch_os_mem_used_percent{%(queriesSelector)s}',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      os_swap_used_percent: {
        name: 'Swap used %%',
        description: 'Swap used percent.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * opensearch_os_swap_used_bytes{%(queriesSelector)s} / clamp_min((opensearch_os_swap_used_bytes{%(queriesSelector)s} + opensearch_os_swap_free_bytes{%(queriesSelector)s}), 1)',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      fs_read_bps: {
        name: 'FS read bytes/s',
        description: 'Filesystem read rate.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'opensearch_fs_io_total_read_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{node}} - read',
          },
        },
      },
      fs_write_bps: {
        name: 'FS write bytes/s',
        description: 'Filesystem write rate.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'opensearch_fs_io_total_write_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{node}} - write',
          },
        },
      },
      fs_used_percent: {
        name: 'FS used %%',
        description: 'Filesystem used percent.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 - (100 * opensearch_fs_path_free_bytes{%(queriesSelector)s} / clamp_min(opensearch_fs_path_total_bytes{%(queriesSelector)s}, 1))',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      transport_open_connections: {
        name: 'Transport server open',
        description: 'Open transport server connections.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'connections',
        sources: {
          prometheus: {
            expr: 'opensearch_transport_server_open_number{%(queriesSelector)s}',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      transport_tx_bps: {
        name: 'Transport TX bitrate',
        description: 'Transport transmit bitrate.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'bit/s',
        sources: {
          prometheus: {
            expr: 'opensearch_transport_tx_bytes_count{%(queriesSelector)s}',
            exprWrappers: [['', ' * 8']],
            legendCustomTemplate: '{{node}} - sent',
          },
        },
      },
      transport_rx_bps: {
        name: 'Transport RX bitrate',
        description: 'Transport receive bitrate.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'bit/s',
        sources: {
          prometheus: {
            expr: 'opensearch_transport_rx_bytes_count{%(queriesSelector)s}',
            exprWrappers: [['', ' * 8']],
            legendCustomTemplate: '{{node}} - received',
          },
        },
      },
      circuitbreaker_tripped_sum_by_name: {
        name: 'Circuit breaker trips by name',
        description: 'Circuit breaker trips by breaker name.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_circuitbreaker_tripped_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{node}} - {{ name }}',
            rangeFunction: 'increase',
          },
        },
      },

      // JVM signals
      jvm_heap_used_bytes: {
        name: 'JVM heap used',
        description: 'JVM heap used.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_mem_heap_used_bytes{%(queriesSelector)s}',
          },
        },
      },
      jvm_heap_committed_bytes: {
        name: 'JVM heap committed',
        description: 'JVM heap committed.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_mem_heap_committed_bytes{%(queriesSelector)s}',
          },
        },
      },
      jvm_nonheap_used_bytes: {
        name: 'JVM non-heap used',
        description: 'JVM non-heap used.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_mem_nonheap_used_bytes{%(queriesSelector)s}',
          },
        },
      },
      jvm_nonheap_committed_bytes: {
        name: 'JVM non-heap committed',
        description: 'JVM non-heap committed.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_mem_nonheap_committed_bytes{%(queriesSelector)s}',
          },
        },
      },
      jvm_threads: {
        name: 'JVM threads',
        description: 'JVM thread count.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'threads',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_threads_number{%(queriesSelector)s}',
          },
        },
      },
      jvm_bufferpool_number: {
        name: 'JVM buffer pools',
        description: 'Number of JVM buffer pools.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_bufferpool_number{%(queriesSelector)s}',
            legendCustomTemplate: '{{ node }} - {{ bufferpool }}',
            aggKeepLabels: ['bufferpool'],
          },
        },
      },
      jvm_uptime: {
        name: 'JVM uptime',
        description: 'JVM uptime seconds.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_uptime_seconds{%(queriesSelector)s}',
          },
        },
      },
      jvm_gc_collections: {
        name: 'JVM GC collections',
        description: 'GC collections per interval.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_gc_collection_count{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
      jvm_gc_time: {
        name: 'JVM GC time',
        description: 'GC time per interval.',
        type: 'counter',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'opensearch_jvm_gc_collection_time_seconds{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
      jvm_bufferpool_used_percent: {
        name: 'JVM bufferpool used %%',
        description: 'Percent of bufferpool used.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * (sum by (' + aggLabelsList + ',bufferpool) (opensearch_jvm_bufferpool_used_bytes{%(queriesSelector)s})) / clamp_min((sum by (' + aggLabelsList + ',bufferpool) (opensearch_jvm_bufferpool_total_capacity_bytes{%(queriesSelector)s})),1)',
            legendCustomTemplate: '{{ node }} - {{ bufferpool }}',
          },
        },
      },

      // Thread pool signals
      threadpool_threads: {
        name: 'Threadpool threads',
        description: 'Total threadpool threads.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'threads',
        sources: {
          prometheus: {
            expr: 'opensearch_threadpool_threads_number{%(queriesSelector)s}',
          },
        },
      },
      threadpool_tasks: {
        name: 'Threadpool tasks',
        description: 'Threadpool tasks.',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'opensearch_threadpool_tasks_number{%(queriesSelector)s}',
          },
        },
      },
    },
  }
