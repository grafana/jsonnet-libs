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
      prometheus: 'mssql_io_stall_seconds_total',
    },

    signals: {
      databaseWriteStallDuration: {
        name: 'Database write stall duration',
        nameShort: 'Write Stall',
        type: 'raw',
        description: 'Time spent waiting for database write operations.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'increase(mssql_io_stall_seconds_total{%(queriesSelector)s, db=~"$db", operation="write"}[$__rate_interval:])',
            legendCustomTemplate: '{{ instance }} - {{ db }}',
          },
        },
      },
      databaseReadStallDuration: {
        name: 'Database read stall duration',
        nameShort: 'Read Stall',
        type: 'raw',
        description: 'Time spent waiting for database read operations.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'increase(mssql_io_stall_seconds_total{%(queriesSelector)s, db=~"$db", operation="read"}[$__rate_interval:])',
            legendCustomTemplate: '{{ instance }} - {{ db }}',
          },
        },
      },
      transactionLogExpansions: {
        name: 'Transaction log expansions',
        nameShort: 'Log Expansions',
        type: 'raw',
        description: 'Rate of transaction log expansions per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'increase(mssql_log_growths_total{%(queriesSelector)s, db=~"$db"}[$__rate_interval:])',
            legendCustomTemplate: '{{ instance }} - {{ db }}',
          },
        },
      },
    },
  }
