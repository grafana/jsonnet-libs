function(this)
  local legendCustomTemplate =
    std.join(' - ', std.map(
      function(label) '{{' + label + '}}',
      std.filter(
        function(label) !(label == 'job' || label == 'cluster'),
        this.groupLabels + this.instanceLabels
      )
    ));
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'hadoop_namenode_blockstotal',
    },
    signals: {
      datanodeStateLive: {
        name: 'DataNode state live',
        nameShort: 'DataNode state live',
        type: 'gauge',
        description: 'Number of live DataNodes.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_numlivedatanodes{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate + ' - live DataNodes',
          },
        },
      },

      datanodeStateDead: {
        name: 'DataNode state dead',
        nameShort: 'DataNode state dead',
        type: 'gauge',
        description: 'Number of dead DataNodes.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_numdeaddatanodes{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate + ' - dead DataNodes',
          },
        },
      },

      datanodeStateStale: {
        name: 'DataNode state stale',
        nameShort: 'DataNode state stale',
        type: 'gauge',
        description: 'Number of stale DataNodes.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_numstaledatanodes{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - stale DataNodes',
          },
        },
      },

      datanodeStateDecommissioning: {
        name: 'DataNode state decommissioning',
        nameShort: 'DataNode state decommissioning',
        type: 'gauge',
        description: 'Number of decommissioning DataNodes.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_numdecommissioningdatanodes{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate + ' - decommissioning DataNodes',
          },
        },
      },

      capacityUtilization: {
        name: 'Capacity utilization',
        nameShort: 'Capacity',
        type: 'raw',
        description: 'The storage utilization of the NameNode.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * hadoop_namenode_capacityused{%(queriesSelector)s, name="FSNamesystem"} / clamp_min(hadoop_namenode_capacitytotal{%(queriesSelector)s, name="FSNamesystem"}, 1)',
          },
        },
      },

      totalBlocks: {
        name: 'Total blocks',
        nameShort: 'Total blocks',
        type: 'gauge',
        description: 'Total number of blocks managed by the NameNode.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_blockstotal{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      missingBlocks: {
        name: 'Missing blocks',
        nameShort: 'Missing blocks',
        type: 'gauge',
        description: 'Number of blocks reported by DataNodes as missing.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_missingblocks{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      underreplicatedBlocks: {
        name: 'Under-replicated blocks',
        nameShort: 'Under-replicated blocks',
        type: 'gauge',
        description: 'Number of blocks that are under-replicated.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_underreplicatedblocks{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      transactionsSinceLastCheckpoint: {
        name: 'Transactions since last checkpoint',
        nameShort: 'Transactions',
        type: 'gauge',
        description: 'Number of transactions processed by the NameNode since the last checkpoint.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_transactionssincelastcheckpoint{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      volumeFailures: {
        name: 'Volume failures',
        nameShort: 'Volume failures',
        type: 'counter',
        description: 'The recent increase in number of volume failures on all DataNodes.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_volumefailurestotal{%(queriesSelector)s, name="FSNamesystem"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      totalFiles: {
        name: 'Total files',
        nameShort: 'Total files',
        type: 'gauge',
        description: 'Total number of files managed by the NameNode.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_filestotal{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      totalLoad: {
        name: 'Total load',
        nameShort: 'Total load',
        type: 'gauge',
        description: 'Total load on the NameNode.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_namenode_totalload{%(queriesSelector)s, name="FSNamesystem"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
