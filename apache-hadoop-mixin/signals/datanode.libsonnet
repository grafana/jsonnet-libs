function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: '{{hadoop_cluster}} - {{instance}}',
    aggFunction: 'avg',
    aggLevel: 'none',
    discoveryMetric: {
      prometheus: 'hadoop_datanode_ramdiskblocksevictedwithoutread',
    },
    signals: {
      unreadBlocksEvicted: {
        name: 'Unread blocks evicted',
        nameShort: 'Unread evicted',
        type: 'counter',
        description: 'Total number of blocks evicted without being read by the Hadoop DataNode.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'hadoop_datanode_ramdiskblocksevictedwithoutread{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },

      blocksRemoved: {
        name: 'Blocks removed',
        nameShort: 'Removed',
        type: 'counter',
        description: 'Total number of blocks removed by the Hadoop DataNode.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'hadoop_datanode_blocksremoved{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },

      volumeFailures: {
        name: 'Volume failures',
        nameShort: 'Volume failures',
        type: 'counter',
        description: 'Displays the total number of volume failures encountered by the Hadoop DataNode.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'hadoop_datanode_volumefailures{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
    },
  }
