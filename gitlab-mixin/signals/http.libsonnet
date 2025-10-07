// for HTTP/traffic related signals
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
      prometheus: 'http_requests_total',
    },
    signals: {
      requestsByStatus: {
        name: 'Traffic by Response Code',
        nameShort: 'Traffic',
        type: 'raw',
        description: 'Rate of HTTP traffic over time, grouped by status.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by (status) (rate(http_requests_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ status }}',
          },
        },
      },

      averageRequestLatency: {
        name: 'Average request latency',
        nameShort: 'Average request latency',
        description: 'Average latency of inbound HTTP requests.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: '1000 * rate(http_request_duration_seconds_sum{%(queriesSelector)s}[$__rate_interval]) / rate(http_request_duration_seconds_count{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{ method }}',
          },
        },
      },

      topRequests: {
        name: 'Top request types',
        nameShort: 'Top request types',
        description: 'Top types of requests to the Gitlab server.',
        type: 'raw',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (feature_category) (topk(5, rate(http_requests_total{%(queriesSelector)s}[$__rate_interval])))',
          },
        },
      },
    },
  }
