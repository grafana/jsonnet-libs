local commonlib = import 'common-lib/common/main.libsonnet';


function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + this.databaseLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'mssql_io_stall_seconds_total',
    },

    signals: {
      databaseWriteStallDuration: {
        name: 'Database write stall duration',
        nameShort: 'Write stall',
        type: 'counter',
        description: 'Time spent waiting for database write operations.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'mssql_io_stall_seconds_total{%(queriesSelector)s, operation="write"}',
            legendCustomTemplate: '{{ instance }} - {{ db }}',
          },
        },
      },
      databaseReadStallDuration: {
        name: 'Database read stall duration',
        nameShort: 'Read stall',
        type: 'counter',
        description: 'Time spent waiting for database read operations.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'mssql_io_stall_seconds_total{%(queriesSelector)s, operation="read"}',
            legendCustomTemplate: '{{ instance }} - {{ db }}',
          },
        },
      },
      transactionLogExpansions: {
        name: 'Transaction log expansions',
        nameShort: 'Log expansions',
        type: 'counter',
        description: 'Rate of transaction log expansions per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'mssql_log_growths_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ db }}',
          },
        },
      },
    },
  }
