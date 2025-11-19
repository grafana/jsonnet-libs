// Signals for Wildfly overview dashboard
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + ['server'],
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'wildfly_undertow_request_count_total',
    },
    signals: {
      // Requests signals
      requestsRate: {
        name: 'Requests rate',
        nameShort: 'Requests',
        type: 'counter',
        description: 'Requests rate over time',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_request_count_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{server}} - {{http_listener}}{{https_listener}}',
          },
        },
      },
      requestErrorsRate: {
        name: 'Request errors rate',
        nameShort: 'Request errors',
        type: 'counter',
        description: 'Rate of requests that result in 500 over time',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_error_count_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{server}} - {{http_listener}}{{https_listener}}',
          },
        },
      },
      // Network signals
      networkReceivedThroughput: {
        name: 'Network received throughput',
        nameShort: 'Network received',
        type: 'counter',
        description: 'Throughput rate of data received over time',
        unit: 'binBps',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_bytes_received_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{server}} - {{http_listener}}{{https_listener}}',
          },
        },
      },
      networkSentThroughput: {
        name: 'Network sent throughput',
        nameShort: 'Network sent',
        type: 'counter',
        description: 'Throughput rate of data sent over time',
        unit: 'binBps',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_bytes_sent_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{server}} - {{http_listener}}{{https_listener}}',
          },
        },
      },
    },
  }
