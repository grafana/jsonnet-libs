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
      prometheus: 'oracledb_wait_time_application',
    },
    signals: {
      applicationWaitTime: {
        name: 'Application wait time',
        nameShort: 'Application wait',
        type: 'counter',
        description: 'Application wait time in seconds waiting for wait events.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'oracledb_wait_time_application{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      commitWaitTime: {
        name: 'Commit wait time',
        nameShort: 'Commit wait',
        type: 'counter',
        description: 'Commit wait time in seconds waiting for wait events.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'oracledb_wait_time_commit{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      concurrencyWaitTime: {
        name: 'Concurrency wait time',
        nameShort: 'Concurrency wait',
        type: 'counter',
        description: 'Concurrency wait time in seconds waiting for wait events.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'oracledb_wait_time_concurrency{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      configurationWaitTime: {
        name: 'Configuration wait time',
        nameShort: 'Configuration wait',
        type: 'counter',
        description: 'Configuration wait time in seconds waiting for wait events.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'oracledb_wait_time_configuration{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      networkWaitTime: {
        name: 'Network wait time',
        nameShort: 'Network wait',
        type: 'counter',
        description: 'Network wait time in seconds waiting for wait events.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'oracledb_wait_time_network{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      schedulerWaitTime: {
        name: 'Scheduler wait time',
        nameShort: 'Scheduler wait',
        type: 'counter',
        description: 'Scheduler wait time in seconds waiting for wait events.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'oracledb_wait_time_scheduler{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      systemIOWaitTime: {
        name: 'System I/O wait time',
        nameShort: 'System I/O wait',
        type: 'counter',
        description: 'System I/O wait time in seconds waiting for wait events.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'oracledb_wait_time_system_io{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      userIOWaitTime: {
        name: 'User I/O wait time',
        nameShort: 'User I/O wait',
        type: 'counter',
        description: 'User I/O wait time in seconds waiting for wait events.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'oracledb_wait_time_user_io{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
    },
  }
