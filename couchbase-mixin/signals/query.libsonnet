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
      prometheus: 'n1ql_requests',
    },
    signals: {
      // Query service requests
      queryServiceRequests: {
        name: 'Query service requests',
        nameShort: 'N1QL >0ms',
        type: 'counter',
        description: 'Rate of N1QL requests processed by the query service for a node.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'n1ql_requests{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - >0ms',
          },
        },
      },
      queryServiceRequestsTotal: {
        name: 'Query service requests total',
        nameShort: 'N1QL Total',
        type: 'raw',
        description: 'Total rate of N1QL requests processed by the query service (including valid and invalid).',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'rate(n1ql_requests{%(queriesSelector)s}[$__rate_interval]) + rate(n1ql_invalid_requests{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - total',
          },
        },
      },
      queryServiceErrors: {
        name: 'Query service errors',
        nameShort: 'N1QL Errors',
        type: 'counter',
        description: 'Rate of N1QL query errors.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'n1ql_errors{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - error',
          },
        },
      },
      queryServiceInvalidRequests: {
        name: 'Query service invalid requests',
        nameShort: 'N1QL Invalid',
        type: 'counter',
        description: 'Rate of invalid N1QL requests.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'n1ql_invalid_requests{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - invalid',
          },
        },
      },

      // Query service latency buckets
      queryServiceRequests250ms: {
        name: 'Query service requests >250ms',
        nameShort: 'N1QL >250ms',
        type: 'counter',
        description: 'Rate of N1QL requests taking more than 250ms.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'n1ql_requests_250ms{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - >250ms',
          },
        },
      },
      queryServiceRequests500ms: {
        name: 'Query service requests >500ms',
        nameShort: 'N1QL >500ms',
        type: 'counter',
        description: 'Rate of N1QL requests taking more than 500ms.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'n1ql_requests_500ms{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - >500ms',
          },
        },
      },
      queryServiceRequests1000ms: {
        name: 'Query service requests >1000ms',
        nameShort: 'N1QL >1s',
        type: 'counter',
        description: 'Rate of N1QL requests taking more than 1000ms.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'n1ql_requests_1000ms{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - >1000ms',
          },
        },
      },
      queryServiceRequests5000ms: {
        name: 'Query service requests >5000ms',
        nameShort: 'N1QL >5s',
        type: 'counter',
        description: 'Rate of N1QL requests taking more than 5000ms.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'n1ql_requests_5000ms{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - >5000ms',
          },
        },
      },
    },
  }
