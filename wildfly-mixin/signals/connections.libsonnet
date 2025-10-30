// for Connection related signals
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'wildfly_datasources_pool_in_use_count',
    },
    signals: {
      connectionsActive: {
        name: 'Active Connections',
        nameShort: 'Active Connections',
        type: 'gauge',
        description: 'Connections to the datasource over time',
        sources: {
          prometheus: {
            expr: 'wildfly_datasources_pool_in_use_count{%(queriesSelector)s,data_source=~"$datasource"}',
            legendCustomTemplate: '{{data_source}}',
          },
        },
      },
      connectionsIdle: {
        name: 'Idle Connections',
        nameShort: 'Idle Connections',
        type: 'gauge',
        description: 'Idle connections to the datasource over time',
        sources: {
          prometheus: {
            expr: 'wildfly_datasources_pool_idle_count{%(queriesSelector)s,data_source=~"$datasource"}',
            legendCustomTemplate: '{{data_source}}',
          },
        },
      },
    },
  }
