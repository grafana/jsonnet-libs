function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {
      suspend: {
        name: 'Cluster suspend status',
        type: 'gauge',
        description: 'The suspension status of the cluster (0 = not suspended, 1 = suspended).',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_cluster_suspend{%(queriesSelector)s}',
            legendCustomTemplate: '{{mq_cluster}}',
          },
        },
      },
    },
  }
