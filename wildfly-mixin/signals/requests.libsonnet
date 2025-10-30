// for Requests related signals
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
      prometheus: 'wildfly_undertow_request_count_total',
    },
    signals: {
      requestsRate: {
        name: 'Requests Rate',
        nameShort: 'Requests',
        type: 'counter',
        description: 'Requests rate over time',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_request_count_total{%(queriesSelector)s,server=~"$server"}',
            legendCustomTemplate: '{{server}} - {{http_listener}}{{https_listener}}',
          },
        },
      },
      requestErrorsRate: {
        name: 'Request Errors Rate',
        nameShort: 'Request Errors',
        type: 'counter',
        description: 'Rate of requests that result in 500 over time',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_error_count_total{%(queriesSelector)s,server=~"$server"}',
            legendCustomTemplate: '{{server}} - {{http_listener}}{{https_listener}}',
          },
        },
      },
    },
  }
