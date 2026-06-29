function(this)
  local legendCustomTemplate = this.legendCustomTemplate;
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'up',
    },
    signals: {
      veleroUp: {
        name: 'Velero status',
        type: 'gauge',
        description: 'Current status of the Velero instance (1=up, 0=down).',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'up{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
