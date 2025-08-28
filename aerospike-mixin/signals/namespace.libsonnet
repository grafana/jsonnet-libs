local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'aerospike_namespace_ns_cluster_size',
    },
    signals: {
      namespaceDiskUsage: {
        name: 'Namespace disk usage',
        nameShort: 'Disk usage',
        type: 'gauge',
        description: 'Disk usage percentage for Aerospike namespaces. Note: This uses legacy device_free_pct metric which may not be available in Aerospike 7.0+.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 - aerospike_namespace_device_free_pct{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }}',
          },
        },
      },

      namespaceDiskUsage7: {
        name: 'Namespace disk usage',
        nameShort: 'Disk usage',
        type: 'gauge',
        description: 'Disk usage percentage for Aerospike namespaces. Compatible with Aerospike Database 7.0+ using data_used_pct metric.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_data_used_pct{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }}',
          },
        },
      },

      namespaceMemoryUsage: {
        name: 'Namespace memory usage',
        nameShort: 'Memory usage',
        type: 'gauge',
        description: 'Memory usage percentage for Aerospike namespaces.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 - aerospike_namespace_memory_free_pct{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }}',
          },
        },
      },

      // this is compatible with Aerospike 7.0+ compared to namespaceMemoryUsage
      namespaceMemoryUsageBytes: {
        name: 'Namespace memory usage bytes',
        nameShort: 'Memory bytes',
        type: 'gauge',
        description: 'Total memory usage in bytes for Aerospike namespaces.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: |||
              (
                aerospike_namespace_data_used_bytes{%(queriesSelector)s}
              ) + (
                aerospike_namespace_index_used_bytes{%(queriesSelector)s}
              ) + (
                aerospike_namespace_set_index_used_bytes{%(queriesSelector)s}
              ) + (
                aerospike_namespace_sindex_used_bytes{%(queriesSelector)s}
              )
            |||,
            legendCustomTemplate: '{{ instance }} - {{ ns }}',
          },
        },
      },

      // Individual memory component signals for debugging which metrics exist
      namespaceDataUsedBytes: {
        name: 'Namespace data used bytes',
        nameShort: 'Data bytes',
        type: 'gauge',
        description: 'Data memory usage in bytes for Aerospike namespaces.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_data_used_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }} - data',
          },
        },
      },

      namespaceIndexUsedBytes: {
        name: 'Namespace index used bytes',
        nameShort: 'Index bytes',
        type: 'gauge',
        description: 'Primary index memory usage in bytes for Aerospike namespaces.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_index_used_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }} - index',
          },
        },
      },

      namespaceSetIndexUsedBytes: {
        name: 'Namespace set index used bytes',
        nameShort: 'Set index bytes',
        type: 'gauge',
        description: 'Set index memory usage in bytes for Aerospike namespaces.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_set_index_used_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }} - set_index',
          },
        },
      },

      namespaceSindexUsedBytes: {
        name: 'Namespace secondary index used bytes',
        nameShort: 'Sindex bytes',
        type: 'gauge',
        description: 'Secondary index memory usage in bytes for Aerospike namespaces.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_sindex_used_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }} - sindex',
          },
        },
      },

      unavailablePartitions: {
        name: 'Unavailable partitions',
        nameShort: 'Unavailable',
        type: 'gauge',
        description: 'Number of unavailable partitions in Aerospike namespaces.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_unavailable_partitions{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }}',
          },
        },
      },

      deadPartitions: {
        name: 'Dead partitions',
        nameShort: 'Dead',
        type: 'gauge',
        description: 'Number of dead partitions in Aerospike namespaces.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_dead_partitions{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ ns }}',
          },
        },
      },

      cacheReadUtilization: {
        name: 'Cache read utilization',
        nameShort: 'Cache hits',
        type: 'gauge',
        description: 'Percentage of read transactions that are resolved by a cache hit.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_cache_read_pct{%(queriesSelector)s}',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }}',
          },
        },
      },

      // Individual namespace transaction rates (not aggregated by cluster)
      readTransactionSuccess: {
        name: 'Read transaction success rate',
        nameShort: 'Read success',
        type: 'counter',
        description: 'Rate of successful read transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_read_success{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - success',
          },
        },
      },

      readTransactionError: {
        name: 'Read transaction error rate',
        nameShort: 'Read errors',
        type: 'counter',
        description: 'Rate of failed read transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_read_error{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - error',
          },
        },
      },

      readTransactionTimeout: {
        name: 'Read transaction timeout rate',
        nameShort: 'Read timeouts',
        type: 'counter',
        description: 'Rate of read transaction timeouts per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_read_timeout{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - timeout',
          },
        },
      },

      readTransactionNotFound: {
        name: 'Read transaction not found rate',
        nameShort: 'Read not found',
        type: 'counter',
        description: 'Rate of read transactions returning not found per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_read_not_found{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - not found',
          },
        },
      },

      readTransactionFiltered: {
        name: 'Read transaction filtered rate',
        nameShort: 'Read filtered',
        type: 'counter',
        description: 'Rate of filtered read transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_read_filtered_out{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - filtered',
          },
        },
      },

      writeTransactionSuccess: {
        name: 'Write transaction success rate',
        nameShort: 'Write success',
        type: 'counter',
        description: 'Rate of successful write transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_write_success{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - success',
          },
        },
      },

      writeTransactionError: {
        name: 'Write transaction error rate',
        nameShort: 'Write errors',
        type: 'counter',
        description: 'Rate of failed write transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_write_error{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - error',
          },
        },
      },

      writeTransactionTimeout: {
        name: 'Write transaction timeout rate',
        nameShort: 'Write timeouts',
        type: 'counter',
        description: 'Rate of write transaction timeouts per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_write_timeout{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - timeout',
          },
        },
      },

      writeTransactionFiltered: {
        name: 'Write transaction filtered rate',
        nameShort: 'Write filtered',
        type: 'counter',
        description: 'Rate of filtered write transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_write_filtered_out{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - filtered',
          },
        },
      },

      udfTransactionComplete: {
        name: 'UDF transaction complete rate',
        nameShort: 'UDF complete',
        type: 'counter',
        description: 'Rate of completed UDF transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_udf_complete{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - complete',
          },
        },
      },

      udfTransactionError: {
        name: 'UDF transaction error rate',
        nameShort: 'UDF errors',
        type: 'counter',
        description: 'Rate of failed UDF transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_udf_error{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - error',
          },
        },
      },

      udfTransactionTimeout: {
        name: 'UDF transaction timeout rate',
        nameShort: 'UDF timeouts',
        type: 'counter',
        description: 'Rate of UDF transaction timeouts per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_udf_timeout{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - timeout',
          },
        },
      },

      udfTransactionFiltered: {
        name: 'UDF transaction filtered rate',
        nameShort: 'UDF filtered',
        type: 'counter',
        description: 'Rate of filtered UDF transactions per namespace.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'aerospike_namespace_client_udf_filtered_out{%(queriesSelector)s}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{ aerospike_cluster }} - {{ ns }} - filtered',
          },
        },
      },
    },
  }
