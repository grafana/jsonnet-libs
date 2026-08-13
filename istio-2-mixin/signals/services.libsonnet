// Service-level traffic signals and the services table.
local selectorsLib = import './selectors.libsonnet';

function(this)
  local selectors = selectorsLib(this);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'datasource',
    aggLevel: 'none',
    discoveryMetric: {
      prometheus: 'istiod_uptime_seconds',
    },
    signals: {

      tableSourceServiceHTTPGRPCRequestRate: {
        name: 'Source service HTTP/GRPC request rate',
        description: 'Service details for the Istio system.',
        type: 'counter',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s}' % selectors,
            exprWrappers: [
              ['label_replace(', ', "service", "$1", "source_canonical_service", "(.*)")'],
              ['sum by(job, cluster, service) (', ')'],
            ],
            legendCustomTemplate: '',
          },
        },
      },

      tableDestinationServiceHTTPGRPCRequestRate: {
        name: 'Destination service HTTP/GRPC request rate',
        description: 'Service details for the Istio system.',
        type: 'counter',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}' % selectors,
            exprWrappers: [
              ['label_replace(', ', "service", "$1", "destination_canonical_service", "(.*)")'],
              ['sum by(job, cluster, service) (', ')'],
            ],
            legendCustomTemplate: '',
          },
        },
      },

      tableSourceServiceHTTPGRPCRequestLatency: {
        name: 'Source service HTTP/GRPC request latency',
        description: 'Service details for the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: |||
              sum by(job, cluster, service) (label_replace(increase(istio_request_duration_milliseconds_sum{%(queriesGroupSelector)s, %(reporterSourceFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)"))
              /
              clamp_min(sum by(job, cluster, service) (label_replace(increase(istio_request_duration_milliseconds_count{%(queriesGroupSelector)s, %(reporterSourceFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)")), 1)
            ||| % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      tableDestinationServiceHTTPGRPCRequestLatency: {
        name: 'Destination service HTTP/GRPC request latency',
        description: 'Service details for the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: |||
              sum by(job, cluster, service) (label_replace(increase(istio_request_duration_milliseconds_sum{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)"))
              /
              clamp_min(sum by(job, cluster, service) (label_replace(increase(istio_request_duration_milliseconds_count{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)")), 1)
            ||| % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      tableSourceServiceHTTPRequestSuccessRate: {
        name: 'Source service HTTP request success rate',
        description: 'Service details for the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: |||
              100 * sum by(job, cluster, service) (label_replace(increase(istio_requests_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)"))
              /
              clamp_min(sum by(job, cluster, service) (label_replace(increase(istio_requests_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s, %(requestProtocolHTTPFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)")), 1)
            ||| % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      tableDestinationServiceHTTPRequestSuccessRate: {
        name: 'Destination service HTTP request success rate',
        description: 'Service details for the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: |||
              100 * sum by(job, cluster, service) (label_replace(increase(istio_requests_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeOKFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)"))
              /
              clamp_min(sum by(job, cluster, service) (label_replace(increase(istio_requests_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s, %(requestProtocolHTTPFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)")), 1)
            ||| % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      tableSourceServiceTCPReceiveRate: {
        name: 'Source service TCP receive rate',
        description: 'Service details for the Istio system.',
        type: 'counter',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'istio_tcp_received_bytes_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s}' % selectors,
            exprWrappers: [
              ['label_replace(', ', "service", "$1", "source_canonical_service", "(.*)")'],
              ['sum by(job, cluster, service) (', ')'],
            ],
            legendCustomTemplate: '',
          },
        },
      },

      tableSourceServiceTCPSendRate: {
        name: 'Source service TCP send rate',
        description: 'Service details for the Istio system.',
        type: 'counter',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'istio_tcp_sent_bytes_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}' % selectors,
            exprWrappers: [
              ['label_replace(', ', "service", "$1", "destination_canonical_service", "(.*)")'],
              ['sum by(job, cluster, service) (', ')'],
            ],
            legendCustomTemplate: '',
          },
        },
      },

      clientServiceHTTPGRPCRequestRate: {
        name: 'HTTP/GRPC requests sent',
        description: 'Rate of HTTP/GRPC requests sent from this service to server services in the Istio system.',
        type: 'counter',
        unit: 'reqps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{source_canonical_service}} -> {{destination_canonical_service}}',
          },
        },
      },

      clientServiceHTTPGRPCAvgRequestDelay: {
        name: 'HTTP/GRPC request delay',
        description: 'Average latency of HTTP/GRPC requests sent from this service to server services in the Istio system.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: |||
              sum by(job, cluster, source_canonical_service, destination_canonical_service) (increase(istio_request_duration_milliseconds_sum{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))
              /
              clamp_min(sum by(job, cluster, source_canonical_service, destination_canonical_service) (increase(istio_request_duration_milliseconds_count{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval])), 1)
            ||| % selectors,
            legendCustomTemplate: '{{source_canonical_service}} -> {{destination_canonical_service}}',
          },
        },
      },

      clientServiceHTTPGRPCRequestThroughputRate: {
        name: 'HTTP/GRPC request throughput',
        description: 'Rate of HTTP/GRPC request data sent from this service to server services in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_request_bytes_sum{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{source_canonical_service}} -> {{destination_canonical_service}}',
          },
        },
      },

      clientServiceHTTPGRPCResponseThroughputRate: {
        name: 'HTTP/GRPC response throughput',
        description: 'Rate of HTTP/GRPC response data received by this service from server services in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_response_bytes_sum{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}',
          },
        },
      },

      clientServiceHTTPOKResponses: {
        name: 'Client service HTTP OK responses',
        description: 'Overview of the types of HTTP responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (ok)',
          },
        },
      },

      clientServiceHTTPErrorResponses: {
        name: 'Client service HTTP error responses',
        description: 'Overview of the types of HTTP responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (error)',
          },
        },
      },

      clientServiceHTTP1xxResponses: {
        name: 'Client service HTTP 1xx responses',
        description: 'The types of HTTP responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode1xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (1xx)',
          },
        },
      },

      clientServiceHTTP2xxResponses: {
        name: 'Client service HTTP 2xx responses',
        description: 'The types of HTTP responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode2xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (2xx)',
          },
        },
      },

      clientServiceHTTP3xxResponses: {
        name: 'Client service HTTP 3xx responses',
        description: 'The types of HTTP responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode3xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (3xx)',
          },
        },
      },

      clientServiceHTTP4xxResponses: {
        name: 'Client service HTTP 4xx responses',
        description: 'The types of HTTP responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode4xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (4xx)',
          },
        },
      },

      clientServiceHTTP5xxResponses: {
        name: 'Client service HTTP 5xx responses',
        description: 'The types of HTTP responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode5xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (5xx)',
          },
        },
      },

      clientServiceGRPCOKResponses: {
        name: 'Client service GRPC OK responses',
        description: 'Overview of the types of GRPC responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusOKFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (ok)',
          },
        },
      },

      clientServiceGRPCErrorResponses: {
        name: 'Client service GRPC error responses',
        description: 'Overview of the types of GRPC responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusErrorFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: (error)',
          },
        },
      },

      clientServiceGRPCResponses: {
        name: 'GRPC responses / $__interval',
        description: 'The types of GRPC responses received by this service from server services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}: {{grpc_response_status}}',
          },
        },
      },

      clientServiceTCPRequestThroughputRate: {
        name: 'TCP request throughput',
        description: 'Rate of TCP request data sent from this service to server services in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_tcp_received_bytes_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{source_canonical_service}} -> {{destination_canonical_service}}',
          },
        },
      },

      clientServiceTCPResponseThroughputRate: {
        name: 'TCP response throughput',
        description: 'Rate of TCP response data received by this service from server services in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_tcp_sent_bytes_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{source_canonical_service}} <- {{destination_canonical_service}}',
          },
        },
      },

      serverServiceHTTPGRPCRequestRate: {
        name: 'HTTP/GRPC requests received',
        description: 'Rate of HTTP/GRPC requests received by this service from client services in the Istio system.',
        type: 'counter',
        unit: 'reqps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{destination_canonical_service}} <- {{source_canonical_service}}',
          },
        },
      },

      serverServiceHTTPGRPCAvgRequestDelay: {
        name: 'HTTP/GRPC request delay',
        description: 'Average latency of HTTP/GRPC requests received by this service from client services in the Istio system.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: |||
              sum by(job, cluster, source_canonical_service, destination_canonical_service) (increase(istio_request_duration_milliseconds_sum{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))
              /
              clamp_min(sum by(job, cluster, source_canonical_service, destination_canonical_service) (increase(istio_request_duration_milliseconds_count{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval])), 1)
            ||| % selectors,
            legendCustomTemplate: '{{destination_canonical_service}} <- {{source_canonical_service}}',
          },
        },
      },

      serverServiceHTTPGRPCRequestThroughputRate: {
        name: 'HTTP/GRPC request throughput',
        description: 'Rate of HTTP/GRPC request data received by this service from client services in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_request_bytes_sum{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{destination_canonical_service}} <- {{source_canonical_service}}',
          },
        },
      },

      serverServiceHTTPGRPCResponseThroughputRate: {
        name: 'HTTP/GRPC response throughput',
        description: 'Rate of HTTP/GRPC response data sent from this service to client services in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_response_bytes_sum{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}',
          },
        },
      },

      serverServiceHTTPOKResponses: {
        name: 'Server service HTTP OK responses',
        description: 'Overview of the types of HTTP responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeOKFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (ok)',
          },
        },
      },

      serverServiceHTTPErrorResponses: {
        name: 'Server service HTTP error responses',
        description: 'Overview of the types of HTTP responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeErrorFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (error)',
          },
        },
      },

      serverServiceHTTP1xxResponses: {
        name: 'Server service HTTP 1xx responses',
        description: 'The types of HTTP responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode1xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (1xx)',
          },
        },
      },

      serverServiceHTTP2xxResponses: {
        name: 'Server service HTTP 2xx responses',
        description: 'The types of HTTP responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode2xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (2xx)',
          },
        },
      },

      serverServiceHTTP3xxResponses: {
        name: 'Server service HTTP 3xx responses',
        description: 'The types of HTTP responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode3xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (3xx)',
          },
        },
      },

      serverServiceHTTP4xxResponses: {
        name: 'Server service HTTP 4xx responses',
        description: 'The types of HTTP responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode4xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (4xx)',
          },
        },
      },

      serverServiceHTTP5xxResponses: {
        name: 'Server service HTTP 5xx responses',
        description: 'The types of HTTP responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode5xxFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (5xx)',
          },
        },
      },

      serverServiceGRPCOKResponses: {
        name: 'Server service GRPC OK responses',
        description: 'Overview of the types of GRPC responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusOKFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (ok)',
          },
        },
      },

      serverServiceGRPCErrorResponses: {
        name: 'Server service GRPC error responses',
        description: 'Overview of the types of GRPC responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusErrorFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: (error)',
          },
        },
      },

      serverServiceGRPCResponses: {
        name: 'GRPC responses / $__interval',
        description: 'The types of GRPC responses sent from this service to client services in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}: {{grpc_response_status}}',
          },
        },
      },

      serverServiceTCPRequestThroughputRate: {
        name: 'TCP request throughput',
        description: 'Rate of TCP request data received by this service from client services in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_tcp_received_bytes_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{destination_canonical_service}} <- {{source_canonical_service}}',
          },
        },
      },

      serverServiceTCPResponseThroughputRate: {
        name: 'TCP response throughput',
        description: 'Rate of TCP response data sent from this service to client services in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_tcp_sent_bytes_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_canonical_service', 'destination_canonical_service'],
            legendCustomTemplate: '{{destination_canonical_service}} -> {{source_canonical_service}}',
          },
        },
      },
    },
  }
