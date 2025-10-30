function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {

      connectionsCreated: {
        name: 'Connections created',
        type: 'counter',
        description: 'Total connections created.',
        unit: 'conns',
        sources: {
          prometheus: {
            expr: 'mongodb_connections_totalCreated{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}}',
          },
        },
      },

      connectionsCurrent: {
        name: 'Current connections',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Current number of active connections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_connections_current{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      connectionsActive: {
        name: 'Active connections',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Current number of connections with operations in progress.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_connections_active{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
