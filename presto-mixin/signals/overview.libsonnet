function(this) {
  local legendCustomTemplate = '{{presto_cluster}}',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.groupLabels)),
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'presto_metadata_DiscoveryNodeManager_ActiveResourceManagerCount',
  },
  signals: {

    activeResourceManagers: {
      name: 'Active resource managers',
      nameShort: 'Resource managers',
      type: 'raw',
      description: 'Number of resource manager instances across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(max by (presto_cluster) (presto_metadata_DiscoveryNodeManager_ActiveResourceManagerCount{%(queriesSelector)s}))',
          legendCustomTemplate: 'Resource manager',
        },
      },
    },

    activeCoordinators: {
      name: 'Active coordinators',
      nameShort: 'Coordinators',
      type: 'raw',
      description: 'Number of broker instances across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(max by (presto_cluster) (presto_metadata_DiscoveryNodeManager_ActiveCoordinatorCount{%(queriesSelector)s}))',
          legendCustomTemplate: 'Coordinator',
        },
      },
    },

    activeWorkers: {
      name: 'Active workers',
      nameShort: 'Workers',
      type: 'raw',
      description: 'Number of worker instances across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(max by (presto_cluster) (presto_metadata_DiscoveryNodeManager_ActiveNodeCount{%(queriesSelector)s}))',
          legendCustomTemplate: 'Worker',
        },
      },
    },

    inactiveWorkers: {
      name: 'Inactive workers',
      nameShort: 'Inactive workers',
      type: 'raw',
      description: 'Number of inactive worker instances across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(max by (presto_cluster) (presto_metadata_DiscoveryNodeManager_InactiveNodeCount{%(queriesSelector)s}))',
          legendCustomTemplate: legendCustomTemplate + ' - inactive',
        },
      },
    },

    completedQueries: {
      name: 'Completed queries - one minute count',
      nameShort: 'Completed queries',
      type: 'gauge',
      description: 'Number of completed queries across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_CompletedQueries_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - completed',
        },
      },
    },


    userErrorFailures: {
      name: 'User error failures - one minute count',
      nameShort: 'User error failures',
      type: 'gauge',
      description: 'Number of user error failures across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_UserErrorFailures_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - user',
        },
      },
    },

    queuedQueries: {
      name: 'Queued queries',
      nameShort: 'Queued queries',
      type: 'gauge',
      description: 'Number of queued queries across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_QueuedQueries{%(queriesSelector)s}',
        },
      },
    },

    blockedNodes: {
      name: 'Blocked nodes',
      nameShort: 'Blocked nodes',
      type: 'gauge',
      description: 'Number of blocked nodes across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_ClusterMemoryPool_general_BlockedNodes{%(queriesSelector)s}',
        },
      },
    },

    internalErrorFailures: {
      name: 'Internal error failures - one minute count',
      nameShort: 'Internal error failures',
      type: 'gauge',
      description: 'Number of internal error failures across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_InternalFailures_OneMinute_Count{%(queriesSelector)s}',
        },
      },
    },

    clusterMemoryDistributedBytesFree: {
      name: 'Cluster memory distributed bytes free',
      nameShort: 'Cluster memory distributed bytes free',
      type: 'gauge',
      description: 'Number of cluster memory distributed bytes free across clusters.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'sum by (presto_cluster) (presto_ClusterMemoryPool_general_FreeDistributedBytes{%(queriesSelector)s})',
        },
      },
    },

    clusterMemoryDistributedBytesReserved: {
      name: 'Cluster memory distributed bytes reserved',
      nameShort: 'Cluster memory distributed bytes reserved',
      type: 'raw',
      description: 'Number of cluster memory distributed bytes reserved across clusters.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'sum by (presto_cluster) (presto_ClusterMemoryPool_reserved_FreeDistributedBytes{%(queriesSelector)s})',
        },
      },
    },


    insufficientResourceFailures: {
      name: 'Insufficient resource failures - one minute rate',
      nameShort: 'Insufficient resource failures',
      type: 'gauge',
      description: 'Number of insufficient resource failures across clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_InsufficientResourcesFailures_OneMinute_Rate{%(queriesSelector)s}',
        },
      },
    },

    dataProcessingThroughputInput: {
      name: 'Data processing throughput input - one minute rate',
      nameShort: 'Data processing throughput input',
      type: 'gauge',
      description: 'Number of data processing throughput input across clusters.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'sum by (presto_cluster) (presto_TaskManager_InputDataSize_OneMinute_Rate{%(queriesSelector)s})',
          legendCustomTemplate: legendCustomTemplate + ' - input',
        },
      },
    },


    dataProcessingThroughputOutput: {
      name: 'Data processing throughput output - one minute rate',
      nameShort: 'Data processing throughput output',
      type: 'gauge',
      description: 'Number of data processing throughput output across clusters.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'sum by (presto_cluster) (presto_TaskManager_OutputDataSize_OneMinute_Rate{%(queriesSelector)s})',
          legendCustomTemplate: legendCustomTemplate + ' - output',
        },
      },
    },
  },
}
