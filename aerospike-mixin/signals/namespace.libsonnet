local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)) + ' - {{ns}}',
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
        description: 'Disk usage percentage for Aerospike namespaces. Supports both legacy (device_free_pct) and modern (data_used_pct) metrics.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 - aerospike_namespace_device_free_pct{%(queriesSelector)s}',
          },
          prometheusAerospike7: {
            expr: 'aerospike_namespace_data_used_pct{%(queriesSelector)s, storage_engine="device"}',
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
          },
          prometheusAerospike7: {
            expr: 'aerospike_namespace_data_used_pct{%(queriesSelector)s, storage_engine="memory"}',
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
