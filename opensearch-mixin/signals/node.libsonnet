// Node-level signals for OpenSearch
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
        type: 'raw',
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
        type: 'raw',
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
        type: 'raw',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggListWithInstance + ') (rate(opensearch_fs_io_total_read_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{node}} - read',
          },
        },
      },
      fs_write_bps: {
        name: 'FS write bytes/s',
        description: 'Filesystem write rate.',
        type: 'raw',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggListWithInstance + ') (rate(opensearch_fs_io_total_write_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{node}} - write',
          },
        },
      },
      fs_used_percent: {
        name: 'FS used %%',
        description: 'Filesystem used percent.',
        type: 'raw',
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
        type: 'raw',
        unit: 'connections',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggListWithInstance + ') (opensearch_transport_server_open_number{%(queriesSelector)s})',
            legendCustomTemplate: '{{node}}',
          },
        },
      },
      transport_tx_bps: {
        name: 'Transport TX bitrate',
        description: 'Transport transmit bitrate.',
        type: 'raw',
        unit: 'bit/s',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggListWithInstance + ') (rate(opensearch_transport_tx_bytes_count{%(queriesSelector)s}[$__rate_interval])) * 8',
            legendCustomTemplate: '{{node}} - sent',
          },
        },
      },
      transport_rx_bps: {
        name: 'Transport RX bitrate',
        description: 'Transport receive bitrate.',
        type: 'raw',
        unit: 'bit/s',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggListWithInstance + ') (rate(opensearch_transport_rx_bytes_count{%(queriesSelector)s}[$__rate_interval])) * 8',
            legendCustomTemplate: '{{node}} - received',
          },
        },
      },
      circuitbreaker_tripped_sum_by_name: {
        name: 'Circuit breaker trips by name',
        description: 'Circuit breaker trips by breaker name.',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'sum by (name, ' + this.groupAggListWithInstance + ') (increase(opensearch_circuitbreaker_tripped_count{%(queriesSelector)s}[$__interval:]))',
            legendCustomTemplate: '{{node}} - {{ name }}',
          },
        },
      },
      jvm_heap_used_bytes: {
        name: 'JVM heap used',
        description: 'JVM heap used.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (opensearch_jvm_mem_heap_used_bytes{%(queriesSelector)s})',
          },
        },
      },
      jvm_heap_committed_bytes: {
        name: 'JVM heap committed',
        description: 'JVM heap committed.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (opensearch_jvm_mem_heap_committed_bytes{%(queriesSelector)s})',
          },
        },
      },
      jvm_nonheap_used_bytes: {
        name: 'JVM non-heap used',
        description: 'JVM non-heap used.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (opensearch_jvm_mem_nonheap_used_bytes{%(queriesSelector)s})',
          },
        },
      },
      jvm_nonheap_committed_bytes: {
        name: 'JVM non-heap committed',
        description: 'JVM non-heap committed.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (opensearch_jvm_mem_nonheap_committed_bytes{%(queriesSelector)s})',
          },
        },
      },
      jvm_threads: {
        name: 'JVM threads',
        description: 'JVM thread count.',
        type: 'raw',
        unit: 'threads',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (opensearch_jvm_threads_number{%(queriesSelector)s})',
          },
        },
      },
      jvm_bufferpool_number: {
        name: 'JVM buffer pools',
        description: 'Number of JVM buffer pools.',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ', bufferpool) (opensearch_jvm_bufferpool_number{%(queriesSelector)s})',
            legendCustomTemplate: '{{ bufferpool }}',
          },
        },
      },
      jvm_uptime: {
        name: 'JVM uptime',
        description: 'JVM uptime seconds.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (opensearch_jvm_uptime_seconds{%(queriesSelector)s})',
          },
        },
      },
      jvm_gc_collections: {
        name: 'JVM GC collections',
        description: 'GC collections per interval.',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (increase(opensearch_jvm_gc_collection_count{%(queriesSelector)s}[$__interval:]))',
          },
        },
      },
      jvm_gc_time: {
        name: 'JVM GC time',
        description: 'GC time per interval.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (increase(opensearch_jvm_gc_collection_time_seconds{%(queriesSelector)s}[$__interval:]))',
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
            expr: '100 * (sum by (' + this.groupAggList + ', bufferpool) (opensearch_jvm_bufferpool_used_bytes{%(queriesSelector)s})) / clamp_min((sum by (job, bufferpool, cluster) (opensearch_jvm_bufferpool_total_capacity_bytes{%(queriesSelector)s})),1)',
            legendCustomTemplate: '{{ bufferpool }}',
          },
        },
      },
      threadpool_threads: {
        name: 'Threadpool threads',
        description: 'Total threadpool threads.',
        type: 'raw',
        unit: 'threads',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') ((opensearch_threadpool_threads_number{%(queriesSelector)s}))',
          },
        },
      },
      threadpool_tasks: {
        name: 'Threadpool tasks',
        description: 'Threadpool tasks.',
        type: 'raw',
        unit: 'count',
        sources: {
          prometheus: {
            expr: 'sum by (' + this.groupAggList + ') (opensearch_threadpool_tasks_number{%(queriesSelector)s})',
          },
        },
      },
    },
  }
