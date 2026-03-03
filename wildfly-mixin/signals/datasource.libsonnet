// Signals for Wildfly datasource dashboard
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + ['data_source'],
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'wildfly_datasources_pool_in_use_count',
    },
    signals: {
      // Connections signals
      connectionsActive: {
        name: 'Active connections',
        nameShort: 'Active connections',
        type: 'gauge',
        unit: 'short',
        description: 'Connections to the datasource over time',
        sources: {
          prometheus: {
            expr: 'wildfly_datasources_pool_in_use_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{data_source}}',
          },
        },
      },
      connectionsIdle: {
        name: 'Idle connections',
        nameShort: 'Idle connections',
        type: 'gauge',
        unit: 'short',
        description: 'Idle connections to the datasource over time',
        sources: {
          prometheus: {
            expr: 'wildfly_datasources_pool_idle_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{data_source}}',
          },
        },
      },
    },
  }
