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
      prometheus: 'oracledb_up',
    },
    signals: {
      databaseStatus: {
        name: 'Database status',
        nameShort: 'Status',
        type: 'gauge',
        description: 'Database status indicator - 1 for up, 0 for down.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'oracledb_up{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      sessions: {
        name: 'Sessions',
        nameShort: 'Sessions',
        type: 'gauge',
        description: 'Current number of sessions.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'oracledb_resource_current_utilization{%(queriesSelector)s, resource_name="sessions"}',
            legendCustomTemplate: '{{ instance }} - open',
          },
        },
      },
      sessionsLimit: {
        name: 'Sessions limit',
        nameShort: 'Sessions limit',
        type: 'gauge',
        description: 'Maximum number of sessions allowed.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'oracledb_resource_limit_value{%(queriesSelector)s, resource_name="sessions"}',
            legendCustomTemplate: '{{ instance }} - limit',
          },
        },
      },
      processes: {
        name: 'Processes',
        nameShort: 'Processes',
        type: 'gauge',
        description: 'Current number of processes.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'oracledb_resource_current_utilization{%(queriesSelector)s, resource_name="processes"}',
            legendCustomTemplate: '{{ instance }} - current',
          },
        },
      },
      processesLimit: {
        name: 'Processes limit',
        nameShort: 'Processes limit',
        type: 'gauge',
        description: 'Maximum number of processes allowed.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'oracledb_resource_limit_value{%(queriesSelector)s, resource_name="processes"}',
            legendCustomTemplate: '{{ instance }} - limit',
          },
        },
      },
    },
  }
