function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      currentConnections: {
        name: 'Current connections',
        type: 'gauge',
        description: 'The number of current connections to an IIS site.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_current_connections{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      connectionAttempts: {
        name: 'Connection attempts',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of attempted connections to an IIS site.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_connection_attempts_all_instances_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },
    },
  }
