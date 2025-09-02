local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  local groupAggListWithInstance = std.join(',', this.groupLabels) + (if std.length(this.instanceLabels) > 0 then ',' + std.join(',', this.instanceLabels) else '');
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'aerospike_node_up',
    },
    signals: {
      nodeMemoryUsage: {
        name: 'Node memory usage',
        nameShort: 'Memory',
        type: 'gauge',
        description: 'Memory usage percentage on Aerospike nodes.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 - aerospike_node_stats_system_free_mem_pct{%(queriesSelector)s}',
          },
        },
      },

      clientConnections: {
        name: 'Client connections',
        nameShort: 'Client conn',
        type: 'gauge',
        description: 'Number of client connections to Aerospike nodes.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'aerospike_node_stats_client_connections{%(queriesSelector)s}',
          },
        },
      },

      fabricConnections: {
        name: 'Fabric connections',
        nameShort: 'Fabric conn',
        type: 'gauge',
        description: 'Number of fabric connections between Aerospike nodes.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'aerospike_node_stats_fabric_connections{%(queriesSelector)s}',
          },
        },
      },

      heartbeatConnections: {
        name: 'Heartbeat connections',
        nameShort: 'Heartbeat conn',
        type: 'gauge',
        description: 'Number of heartbeat connections between Aerospike nodes.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'aerospike_node_stats_heartbeat_connections{%(queriesSelector)s}',
          },
        },
      },

      heapMemoryEfficiency: {
        name: 'Heap memory efficiency',
        nameShort: 'Heap efficiency',
        type: 'gauge',
        description: 'Fragmentation rate for the jemalloc heap in Aerospike nodes.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'aerospike_node_stats_heap_efficiency_pct{%(queriesSelector)s}',
          },
        },
      },

      unavailablePartitions: {
        name: 'Unavailable partitions',
        nameShort: 'Unavailable',
        type: 'gauge',
        description: 'Number of unavailable partitions in Aerospike instance.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (aerospike_namespace_unavailable_partitions{%(queriesSelector)s})',
          },
        },
      },

      deadPartitions: {
        name: 'Dead partitions',
        nameShort: 'Dead',
        type: 'gauge',
        description: 'Number of dead partitions in Aerospike instance.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (aerospike_namespace_dead_partitions{%(queriesSelector)s})',
          },
        },
      },

      clientReadSuccess: {
        name: 'Client read success rate',
        nameShort: 'Read success',
        type: 'raw',
        description: 'Rate of successful client read transactions.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_read_success{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - success',
          },
        },
      },

      clientReadError: {
        name: 'Client read error rate',
        nameShort: 'Read error',
        type: 'raw',
        description: 'Rate of client read transaction errors.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_read_error{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - error',
          },
        },
      },

      clientReadTimeout: {
        name: 'Client read timeout rate',
        nameShort: 'Read timeout',
        type: 'raw',
        description: 'Rate of client read transaction timeouts.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_read_timeout{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - timeout',
          },
        },
      },

      clientReadNotFound: {
        name: 'Client read not found rate',
        nameShort: 'Read not found',
        type: 'raw',
        description: 'Rate of client read transactions returning not found.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_read_not_found{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - not found',
          },
        },
      },

      clientReadFiltered: {
        name: 'Client read filtered rate',
        nameShort: 'Read filtered',
        type: 'raw',
        description: 'Rate of filtered client read transactions.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_read_filtered_out{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - filtered',
          },
        },
      },

      clientWriteSuccess: {
        name: 'Client write success rate',
        nameShort: 'Write success',
        type: 'raw',
        description: 'Rate of successful client write transactions.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_write_success{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - success',
          },
        },
      },

      clientWriteError: {
        name: 'Client write error rate',
        nameShort: 'Write error',
        type: 'raw',
        description: 'Rate of client write transaction errors.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_write_error{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - error',
          },
        },
      },

      clientWriteTimeout: {
        name: 'Client write timeout rate',
        nameShort: 'Write timeout',
        type: 'raw',
        description: 'Rate of client write transaction timeouts.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_write_timeout{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - timeout',
          },
        },
      },

      clientWriteFiltered: {
        name: 'Client write filtered rate',
        nameShort: 'Write filtered',
        type: 'raw',
        description: 'Rate of filtered client write transactions.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_write_filtered_out{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - filtered',
          },
        },
      },

      clientUdfComplete: {
        name: 'Client UDF complete rate',
        nameShort: 'UDF complete',
        type: 'raw',
        description: 'Rate of completed client UDF transactions.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_udf_complete{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - complete',
          },
        },
      },

      clientUdfError: {
        name: 'Client UDF error rate',
        nameShort: 'UDF error',
        type: 'raw',
        description: 'Rate of client UDF transaction errors.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_udf_error{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - error',
          },
        },
      },

      clientUdfTimeout: {
        name: 'Client UDF timeout rate',
        nameShort: 'UDF timeout',
        type: 'raw',
        description: 'Rate of client UDF transaction timeouts.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_udf_timeout{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - timeout',
          },
        },
      },

      clientUdfFiltered: {
        name: 'Client UDF filtered rate',
        nameShort: 'UDF filtered',
        type: 'raw',
        description: 'Rate of filtered client UDF transactions.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.instanceLabels) + ') (rate(aerospike_namespace_client_udf_filtered_out{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ instance }} - filtered',
          },
        },
      },

      diskUsage: {
        name: 'Disk usage',
        nameShort: 'Disk usage',
        type: 'raw',
        description: 'Disk utilization in an Aerospike node.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 - sum by (' + groupAggListWithInstance + ') (aerospike_namespace_device_free_pct{%(queriesSelector)s})',
          },
          prometheusAerospike7: {
            expr: 'sum by (' + groupAggListWithInstance + ') (aerospike_namespace_data_used_pct{%(queriesSelector)s, storage_engine="device"})',
          },
        },
      },
    },
  }
