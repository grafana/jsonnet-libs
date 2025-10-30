// for Transaction related signals
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
      prometheus: 'wildfly_transactions_number_of_transactions_total',
    },
    signals: {
      transactionsCreated: {
        name: 'Created Transactions',
        nameShort: 'Created Transactions',
        type: 'raw',
        description: 'Number of transactions that were created over time',
        sources: {
          prometheus: {
            expr: 'increase(wildfly_transactions_number_of_transactions_total{%(queriesSelector)s}[$__interval])',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      transactionsInFlight: {
        name: 'In-flight Transactions',
        nameShort: 'In-flight Transactions',
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
        name: 'Aborted Transactions',
        nameShort: 'Aborted Transactions',
        type: 'raw',
        description: 'Number of transactions that have been aborted over time',
        sources: {
          prometheus: {
            expr: 'increase(wildfly_transactions_number_of_aborted_transactions_total{%(queriesSelector)s}[$__interval])',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
