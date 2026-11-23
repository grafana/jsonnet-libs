function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'pg_settings_max_connections',
    },
    signals: {
      allSettings: {
        name: 'PostgreSQL settings',
        description: 'PostgreSQL configuration settings from the pg_settings_* metrics.',
        type: 'gauge',
        aggLevel: 'none',
        unit: 'short',
        sources: {
          prometheus: {
            expr: '{__name__=~"pg_settings_.*${settingsFilter}.*", %(queriesSelector)s}',
          },
        },
      },
    },
  }
