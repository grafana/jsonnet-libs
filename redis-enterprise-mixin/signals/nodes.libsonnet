local commonlib = import 'common-lib/common/main.libsonnet';

function(this) {
  local legendCustomTemplate = std.join(',', std.map(function(label) '{{ ' + label + ' }}', this.nodeLabels)),
  local nodeFilters = commonlib.utils.labelsToPromQLSelector(this.nodeLabels),
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  legendCustomTemplate: legendCustomTemplate,
  aggLevel: 'none',
  aggFunction: 'avg',
  discoveryMetric: 'node_up',
  signals: {
    nodeUp: {
      name: 'Node up',
      nameShort: 'Up',
      type: 'gauge',
      description: 'Displays up/down status for the selected node',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'node_up{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    databaseUp: {
      name: 'Database up',
      nameShort: 'Database up',
      type: 'gauge',
      description: 'Displays up/down status for the databases of the selected node(s)',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'bdb_up{%(queriesSelector)s}',  // intentionall no filtering on the node
          legendCustomTemplate: 'db: {{ bdb }}',
        },
      },
    },

    shardUp: {
      name: 'Shard up',
      nameShort: 'Shard up',
      type: 'gauge',
      description: 'Displays up/down status for the shards on the selected node',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'redis_up{%(queriesSelector)s, ' + nodeFilters + '}',
          legendCustomTemplate: 'redis: {{ redis }}',
        },
      },
    },

    nodeRequests: {
      name: 'Node requests',
      nameShort: 'Requests',
      type: 'gauge',
      description: 'Total endpoint request rate for the selected node',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'node_total_req{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    nodeAverageLatency: {
      name: 'Node average latency',
      nameShort: 'Avg latency',
      type: 'gauge',
      description: 'Average latency for the selected node',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'node_avg_latency{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    nodeMemoryUtilization: {
      name: 'Node memory utilization',
      nameShort: 'Memory utilization',
      type: 'raw',
      description: 'Memory utilization % for the selected node',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '(sum(redis_used_memory{%(queriesSelector)s}) by (redis_cluster, node, job) / clamp_min(sum(node_available_memory{%(queriesSelector)s}) by (redis_cluster, node, job), 1)) * 100',
        },
      },
    },

    nodeCPUSystem: {
      name: 'Node CPU system',
      nameShort: 'CPU system',
      type: 'gauge',
      description: 'System CPU utilization for the selected node',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'node_cpu_system{%(queriesSelector)s, ' + nodeFilters + '} * 100',
          legendCustomTemplate: legendCustomTemplate + ' - system',
        },
      },
    },

    nodeCPUUser: {
      name: 'Node CPU user',
      nameShort: 'CPU user',
      type: 'gauge',
      description: 'User CPU utilization for the selected node',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'node_cpu_user{%(queriesSelector)s, ' + nodeFilters + '} * 100',
          legendCustomTemplate: legendCustomTemplate + ' - user',
        },
      },
    },

    nodeAvailableMemory: {
      name: 'Node available memory',
      nameShort: 'Available memory',
      type: 'gauge',
      description: 'Available memory for the selected node',
      unit: 'bytes',
      sources: {
        prometheus: {
          expr: 'node_available_memory{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    nodeTotalRequests: {
      name: 'Node total requests',
      nameShort: 'Total requests',
      type: 'gauge',
      description: 'Total requests for the selected node',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'node_total_req{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    nodeEphmeralFreeStorage: {
      name: 'Node ephemeral free storage',
      nameShort: 'Free storage',
      type: 'gauge',
      description: 'Ephemeral storage available for the selected node',
      unit: 'bytes',
      sources: {
        prometheus: {
          expr: 'node_ephemeral_storage_free{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    nodePersistentFreeStorage: {
      name: 'Node persistent free storage',
      nameShort: 'Free storage',
      type: 'gauge',
      description: 'Persistent storage available for the selected node',
      unit: 'bytes',
      sources: {
        prometheus: {
          expr: 'node_persistent_storage_free{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    nodeNetworkIngress: {
      name: 'Node network ingress',
      nameShort: 'Network ingress',
      type: 'gauge',
      description: 'Network ingress for the selected node',
      unit: 'binBps',
      sources: {
        prometheus: {
          expr: 'node_network_ingress{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    nodeNetworkEgress: {
      name: 'Node network egress',
      nameShort: 'Network egress',
      type: 'gauge',
      description: 'Network egress for the selected node',
      unit: 'binBps',
      sources: {
        prometheus: {
          expr: 'node_network_egress{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },

    nodeClientConnections: {
      name: 'Node client connections',
      nameShort: 'Client connections',
      type: 'gauge',
      description: 'Number of client connections to the selected node',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'node_conns{%(queriesSelector)s, ' + nodeFilters + '}',
        },
      },
    },
  },
}
