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
      prometheus: 'ClickHouseProfileEvents_SelectQuery',
    },
    signals: {
      selectQueries: {
        name: 'Select queries',
        nameShort: 'SELECT',
        type: 'counter',
        description: 'Rate of SELECT queries per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_SelectQuery{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Select query',
          },
        },
      },
      insertQueries: {
        name: 'Insert queries',
        nameShort: 'INSERT',
        type: 'counter',
        description: 'Rate of INSERT queries per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_InsertQuery{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Insert query',
          },
        },
      },
      asyncInsertQueries: {
        name: 'Async insert queries',
        nameShort: 'Async INSERT',
        type: 'counter',
        description: 'Rate of async INSERT queries per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_AsyncInsertQuery{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Async insert query',
          },
        },
      },
      failedSelectQueries: {
        name: 'Failed select queries',
        nameShort: 'Failed SELECT',
        type: 'counter',
        description: 'Rate of failed SELECT queries per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_FailedSelectQuery{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Failed select query',
          },
        },
      },
      failedInsertQueries: {
        name: 'Failed insert queries',
        nameShort: 'Failed INSERT',
        type: 'counter',
        description: 'Rate of failed INSERT queries per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_FailedInsertQuery{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Failed insert query',
          },
        },
      },
      rejectedInserts: {
        name: 'Rejected inserts',
        nameShort: 'Rejected',
        type: 'counter',
        description: 'Number of rejected inserts per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_RejectedInserts{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Rejected inserts',
          },
        },
      },
    },
  }
