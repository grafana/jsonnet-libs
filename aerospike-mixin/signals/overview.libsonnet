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
      nodesClusterSize: {
        name: 'Nodes cluster size',
        nameShort: 'Nodes',
        type: 'raw',
        description: 'Number of nodes in an Aerospike cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, aerospike_cluster, instance) (aerospike_namespace_ns_cluster_size{%(queriesSelector)s})',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      namespacesClusterSize: {
        name: 'Namespaces cluster size',
        nameShort: 'Namespaces',
        type: 'raw',
        description: 'Number of namespaces in an Aerospike cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, aerospike_cluster, instance, ns) (aerospike_namespace_ns_cluster_size{%(queriesSelector)s})',
            legendCustomTemplate: '{{ns}}',
          },
        },
      },

      unavailablePartitions: {
        name: 'Unavailable partitions',
        nameShort: 'Unavailable',
        type: 'gauge',
        description: 'Number of unavailable data partitions in an Aerospike cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, aerospike_cluster) (aerospike_namespace_unavailable_partitions{%(queriesSelector)s})',
            legendCustomTemplate: '{{aerospike_cluster}}',
          },
        },
      },

      deadPartitions: {
        name: 'Dead partitions',
        nameShort: 'Dead',
        type: 'gauge',
        description: 'Number of dead data partitions in an Aerospike cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, aerospike_cluster) (aerospike_namespace_dead_partitions{%(queriesSelector)s})',
            legendCustomTemplate: '{{aerospike_cluster}}',
          },
        },
      },

      topNodesByMemoryUsage: {
        name: 'Top nodes by memory usage',
        nameShort: 'Top memory',
        type: 'gauge',
        description: 'Memory utilization for the top k nodes in an Aerospike cluster.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk($k, 100 - sum by(job, aerospike_cluster, instance) (avg_over_time(aerospike_node_stats_system_free_mem_pct{%(queriesSelector)s}[$__interval])))',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      topNodesByDiskUsage: {
        name: 'Top nodes by disk usage',
        nameShort: 'Top disk',
        type: 'gauge',
        description: 'Disk utilization for the top k nodes in an Aerospike cluster. Note: This uses legacy device_free_pct metric which may not be available in Aerospike 7.0+.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk($k, 100 - sum by(job, aerospike_cluster, instance) (avg_over_time(aerospike_namespace_device_free_pct{%(queriesSelector)s}[$__interval])))',
            legendCustomTemplate: '{{instance}}',
          },
          prometheusAerospike7: {
            expr: 'topk($k, 100 - sum by(job, aerospike_cluster, instance) (avg_over_time(aerospike_namespace_data_used_pct{%(queriesSelector)s}[$__interval])))',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      clientReadSuccess: {
        name: 'Client read success rate',
        nameShort: 'Read success',
        type: 'raw',
        description: 'Rate of successful client read transactions.',
        unit: 'rps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_success{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - success',
          },
        },
      },

      clientReadError: {
        name: 'Client read error rate',
        nameShort: 'Read error',
        type: 'raw',
        description: 'Rate of failed client read transactions.',
        unit: 'rps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_error{%(queriesSelector)s}[$__rate_interval]))',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{aerospike_cluster}} - error',
          },
        },
      },

      clientReadFiltered: {
        name: 'Client read filtered rate',
        nameShort: 'Read filtered',
        type: 'raw',
        description: 'Rate of filtered client read transactions.',
        unit: 'rps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_filtered_out{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - filtered',
          },
        },
      },

      clientReadTimeout: {
        name: 'Client read timeout rate',
        nameShort: 'Read timeout',
        type: 'raw',
        description: 'Rate of client read transaction timeouts.',
        unit: 'rps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_timeout{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - timeout',
          },
        },
      },

      clientReadNotFound: {
        name: 'Client read not found rate',
        nameShort: 'Read not found',
        type: 'raw',
        description: 'Rate of client read transactions returning not found.',
        unit: 'rps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_not_found{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - not found',
          },
        },
      },

      clientWriteSuccess: {
        name: 'Client write success rate',
        nameShort: 'Write success',
        type: 'raw',
        description: 'Rate of successful client write transactions.',
        unit: 'wps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_write_success{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - success',
          },
        },
      },

      clientWriteError: {
        name: 'Client write error rate',
        nameShort: 'Write error',
        type: 'raw',
        description: 'Rate of failed client write transactions.',
        unit: 'wps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_write_error{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - error',
          },
        },
      },

      clientWriteFiltered: {
        name: 'Client write filtered rate',
        nameShort: 'Write filtered',
        type: 'raw',
        description: 'Rate of filtered client write transactions.',
        unit: 'wps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_write_filtered_out{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - filtered',
          },
        },
      },

      clientWriteTimeout: {
        name: 'Client write timeout rate',
        nameShort: 'Write timeout',
        type: 'raw',
        description: 'Rate of client write transaction timeouts.',
        unit: 'wps',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_write_timeout{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - timeout',
          },
        },
      },

      clientUdfComplete: {
        name: 'Client UDF complete rate',
        nameShort: 'UDF complete',
        type: 'raw',
        description: 'Rate of completed client UDF transactions.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_udf_complete{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - complete',
          },
        },
      },

      clientUdfError: {
        name: 'Client UDF error rate',
        nameShort: 'UDF error',
        type: 'raw',
        description: 'Rate of failed client UDF transactions.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_udf_error{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - error',
          },
        },
      },

      clientUdfFiltered: {
        name: 'Client UDF filtered rate',
        nameShort: 'UDF filtered',
        type: 'raw',
        description: 'Rate of filtered client UDF transactions.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_udf_filtered_out{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - filtered',
          },
        },
      },

      clientUdfTimeout: {
        name: 'Client UDF timeout rate',
        nameShort: 'UDF timeout',
        type: 'raw',
        description: 'Rate of client UDF transaction timeouts.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_udf_timeout{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{aerospike_cluster}} - timeout',
          },
        },
      },

      clientConnections: {
        name: 'Client connections',
        nameShort: 'Client conn',
        type: 'raw',
        description: 'Number of client connections to an Aerospike cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (aerospike_node_stats_client_connections{%(queriesSelector)s})',
            legendCustomTemplate: '{{aerospike_cluster}} - client',
          },
        },
      },

      fabricConnections: {
        name: 'Fabric connections',
        nameShort: 'Fabric conn',
        type: 'raw',
        description: 'Number of fabric connections in an Aerospike cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (aerospike_node_stats_fabric_connections{%(queriesSelector)s})',
            legendCustomTemplate: '{{aerospike_cluster}} - fabric',
          },
        },
      },

      heartbeatConnections: {
        name: 'Heartbeat connections',
        nameShort: 'Heartbeat conn',
        type: 'raw',
        description: 'Number of heartbeat connections in an Aerospike cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(aerospike_cluster, job) (aerospike_node_stats_heartbeat_connections{%(queriesSelector)s})',
            legendCustomTemplate: '{{aerospike_cluster}} - heartbeat',
          },
        },
      },
    },
  }
