local commonlib = import 'common-lib/common/main.libsonnet';


function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'mssql_connections',
    },
    signals: {
      mssqlConnections: {
        name: 'SQL Server connections',
        nameShort: 'Connections',
        type: 'gauge',
        description: 'Current number of SQL Server connections.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'mssql_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      batchRequests: {
        name: 'Batch requests',
        nameShort: 'Batch requests',
        type: 'counter',
        description: 'Rate of batch requests per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'mssql_batch_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      severeErrors: {
        name: 'Severe errors',
        nameShort: 'Severe errors',
        type: 'counter',
        description: 'Rate of severe connection errors per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'mssql_kill_connection_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      deadlocks: {
        name: 'Deadlocks',
        nameShort: 'Deadlocks',
        type: 'counter',
        description: 'Rate of deadlocks per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'mssql_deadlocks_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
    },
  }
