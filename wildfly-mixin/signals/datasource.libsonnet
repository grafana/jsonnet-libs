// Signals for Wildfly datasource dashboard
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
      // Connections signals
      connectionsActive: {
        name: 'Active connections',
        nameShort: 'Active connections',
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
        name: 'Idle connections',
        nameShort: 'Idle connections',
        type: 'gauge',
        description: 'Idle connections to the datasource over time',
        sources: {
          prometheus: {
            expr: 'wildfly_datasources_pool_idle_count{%(queriesSelector)s,data_source=~"$datasource"}',
            legendCustomTemplate: '{{data_source}}',
          },
        },
      },
      // Transactions signals
      transactionsCreated: {
        name: 'Created transactions',
        nameShort: 'Created transactions',
        type: 'counter',
        description: 'Number of transactions that were created over time',
        sources: {
          prometheus: {
            expr: 'wildfly_transactions_number_of_transactions_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      transactionsInFlight: {
        name: 'In-flight transactions',
        nameShort: 'In-flight transactions',
        type: 'gauge',
        description: 'Number of transactions that are in-flight over time',
        sources: {
          prometheus: {
            expr: 'wildfly_transactions_number_of_inflight_transactions{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      transactionsAborted: {
        name: 'Aborted transactions',
        nameShort: 'Aborted transactions',
        type: 'counter',
        description: 'Number of transactions that have been aborted over time',
        sources: {
          prometheus: {
            expr: 'wildfly_transactions_number_of_aborted_transactions_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
