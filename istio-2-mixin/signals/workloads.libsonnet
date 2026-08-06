// Workload-level traffic signals and the workloads table.
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

      tableSourceWorkloadHTTPGRPCRequestRate: {
        name: 'Source workload HTTP/GRPC request rate',
        description: 'Workload details for a service in the Istio system.',
        type: 'counter',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s}' % selectors,
            exprWrappers: [
              ['label_replace(', ', "service", "$1", "source_canonical_service", "(.*)")'],
              ['label_replace(', ', "workload", "$1", "source_workload", "(.*)")'],
              ['sum by(job, cluster, service, workload) (', ')'],
            ],
            legendCustomTemplate: '',
          },
        },
      },

      tableDestinationWorkloadHTTPGRPCRequestRate: {
        name: 'Destination workload HTTP/GRPC request rate',
        description: 'Workload details for a service in the Istio system.',
        type: 'counter',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s}' % selectors,
            exprWrappers: [
              ['label_replace(', ', "service", "$1", "destination_canonical_service", "(.*)")'],
              ['label_replace(', ', "workload", "$1", "destination_workload", "(.*)")'],
              ['sum by(job, cluster, service, workload) (', ')'],
            ],
            legendCustomTemplate: '',
          },
        },
      },

      tableSourceWorkloadHTTPGRPCRequestLatency: {
        name: 'Source workload HTTP/GRPC request latency',
        description: 'Workload details for a service in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: |||
              sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_request_duration_milliseconds_sum{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)"))
              /
              clamp_min(sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_request_duration_milliseconds_count{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)")), 1)
            ||| % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      tableDestinationWorkloadHTTPGRPCRequestLatency: {
        name: 'Destination workload HTTP/GRPC request latency',
        description: 'Workload details for a service in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: |||
              sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_request_duration_milliseconds_sum{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)"))
              /
              clamp_min(sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_request_duration_milliseconds_count{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)")), 1)
            ||| % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      tableSourceWorkloadHTTPRequestSuccessRate: {
        name: 'Source workload HTTP request success rate',
        description: 'Workload details for a service in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: |||
              100 * sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_requests_total{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)"))
              /
              clamp_min(sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_requests_total{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s, %(requestProtocolHTTPFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)")), 1)
            ||| % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      tableDestinationWorkloadHTTPRequestSuccessRate: {
        name: 'Destination workload HTTP request success rate',
        description: 'Workload details for a service in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: |||
              100 * sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_requests_total{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeOKFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)"))
              /
              clamp_min(sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_requests_total{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s, %(requestProtocolHTTPFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)")), 1)
            ||| % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      tableSourceWorkloadTCPRequestThroughputRate: {
        name: 'Source workload TCP request throughput',
        description: 'Workload details for a service in the Istio system.',
        type: 'counter',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'istio_tcp_received_bytes_total{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s}' % selectors,
            exprWrappers: [
              ['label_replace(', ', "service", "$1", "source_canonical_service", "(.*)")'],
              ['label_replace(', ', "workload", "$1", "source_workload", "(.*)")'],
              ['sum by(job, cluster, service, workload) (', ')'],
            ],
            legendCustomTemplate: '',
          },
        },
      },

      tableDestinationWorkloadTCPResponseThroughputRate: {
        name: 'Destination workload TCP response throughput',
        description: 'Workload details for a service in the Istio system.',
        type: 'counter',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'istio_tcp_sent_bytes_total{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s}' % selectors,
            exprWrappers: [
              ['label_replace(', ', "service", "$1", "destination_canonical_service", "(.*)")'],
              ['label_replace(', ', "workload", "$1", "destination_workload", "(.*)")'],
              ['sum by(job, cluster, service, workload) (', ')'],
            ],
            legendCustomTemplate: '',
          },
        },
      },

      clientWorkloadHTTPGRPCRequestRate: {
        name: 'HTTP/GRPC requests sent',
        description: 'Rate of HTTP/GRPC requests sent from this workload to server workloads in the Istio system.',
        type: 'counter',
        unit: 'reqps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{source_workload}} -> {{destination_workload}}',
          },
        },
      },

      clientWorkloadHTTPGRPCAvgRequestDelay: {
        name: 'HTTP/GRPC request delay',
        description: 'Average latency of HTTP/GRPC requests sent from this workload to server workloads in the Istio system.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: |||
              sum by(job, cluster, source_workload, destination_workload) (increase(istio_request_duration_milliseconds_sum{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]))
              /
              clamp_min(sum by(job, cluster, source_workload, destination_workload) (increase(istio_request_duration_milliseconds_count{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval:])), 1)
            ||| % selectors,
            legendCustomTemplate: '{{source_workload}} -> {{destination_workload}}',
          },
        },
      },

      clientWorkloadHTTPGRPCRequestThroughputRate: {
        name: 'HTTP/GRPC request throughput',
        description: 'Rate of HTTP/GRPC request data sent from this workload to server workloads in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_request_bytes_sum{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{source_workload}} -> {{destination_workload}}',
          },
        },
      },

      clientWorkloadHTTPGRPCResponseThroughputRate: {
        name: 'HTTP/GRPC response throughput',
        description: 'Rate of HTTP/GRPC response data received by this workload from server workloads in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_response_bytes_sum{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}',
          },
        },
      },

      clientWorkloadHTTPOKResponses: {
        name: 'Client workload HTTP OK responses',
        description: 'Overview of the types of HTTP responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (ok)',
          },
        },
      },

      clientWorkloadHTTPErrorResponses: {
        name: 'Client workload HTTP error responses',
        description: 'Overview of the types of HTTP responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (error)',
          },
        },
      },

      clientWorkloadHTTP1xxResponses: {
        name: 'Client workload HTTP 1xx responses',
        description: 'The types of HTTP responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode1xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (1xx)',
          },
        },
      },

      clientWorkloadHTTP2xxResponses: {
        name: 'Client workload HTTP 2xx responses',
        description: 'The types of HTTP responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode2xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (2xx)',
          },
        },
      },

      clientWorkloadHTTP3xxResponses: {
        name: 'Client workload HTTP 3xx responses',
        description: 'The types of HTTP responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode3xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (3xx)',
          },
        },
      },

      clientWorkloadHTTP4xxResponses: {
        name: 'Client workload HTTP 4xx responses',
        description: 'The types of HTTP responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode4xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (4xx)',
          },
        },
      },

      clientWorkloadHTTP5xxResponses: {
        name: 'Client workload HTTP 5xx responses',
        description: 'The types of HTTP responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode5xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (5xx)',
          },
        },
      },

      clientWorkloadGRPCOKResponses: {
        name: 'Client workload GRPC OK responses',
        description: 'Overview of the types of GRPC responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusOKFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (ok)',
          },
        },
      },

      clientWorkloadGRPCErrorResponses: {
        name: 'Client workload GRPC error responses',
        description: 'Overview of the types of GRPC responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusErrorFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: (error)',
          },
        },
      },

      clientWorkloadGRPCResponses: {
        name: 'GRPC responses / $__interval',
        description: 'The types of GRPC responses received by this workload from server workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}: {{grpc_response_status}}',
          },
        },
      },

      clientWorkloadTCPRequestThroughputRate: {
        name: 'TCP request throughput',
        description: 'Rate of TCP request data sent from this workload to server workloads in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_tcp_received_bytes_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{source_workload}} -> {{destination_workload}}',
          },
        },
      },

      clientWorkloadTCPResponseThroughputRate: {
        name: 'TCP response throughput',
        description: 'Rate of TCP response data received by this workload from server workloads in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_tcp_sent_bytes_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{source_workload}} <- {{destination_workload}}',
          },
        },
      },

      serverWorkloadHTTPGRPCRequestRate: {
        name: 'HTTP/GRPC requests received',
        description: 'Rate of HTTP/GRPC requests received by this workload from client workloads in the Istio system.',
        type: 'counter',
        unit: 'reqps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{destination_workload}} <- {{source_workload}}',
          },
        },
      },

      serverWorkloadHTTPGRPCAvgRequestDelay: {
        name: 'HTTP/GRPC request delay',
        description: 'Average latency of HTTP/GRPC requests received by this workload from client workloads in the Istio system.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: |||
              sum by(job, cluster, source_workload, destination_workload) (increase(istio_request_duration_milliseconds_sum{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]))
              /
              clamp_min(sum by(job, cluster, source_workload, destination_workload) (increase(istio_request_duration_milliseconds_count{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:])), 1)
            ||| % selectors,
            legendCustomTemplate: '{{destination_workload}} <- {{source_workload}}',
          },
        },
      },

      serverWorkloadHTTPGRPCRequestThroughputRate: {
        name: 'HTTP/GRPC request throughput',
        description: 'Rate of HTTP/GRPC request data received by this workload from client workloads in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_request_bytes_sum{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{destination_workload}} <- {{source_workload}}',
          },
        },
      },

      serverWorkloadHTTPGRPCResponseThroughputRate: {
        name: 'HTTP/GRPC response throughput',
        description: 'Rate of HTTP/GRPC response data sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_response_bytes_sum{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}',
          },
        },
      },

      serverWorkloadHTTPOKResponses: {
        name: 'Server workload HTTP OK responses',
        description: 'Overview of the types of HTTP responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeOKFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (ok)',
          },
        },
      },

      serverWorkloadHTTPErrorResponses: {
        name: 'Server workload HTTP error responses',
        description: 'Overview of the types of HTTP responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeErrorFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (error)',
          },
        },
      },

      serverWorkloadHTTP1xxResponses: {
        name: 'Server workload HTTP 1xx responses',
        description: 'The types of HTTP responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode1xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (1xx)',
          },
        },
      },

      serverWorkloadHTTP2xxResponses: {
        name: 'Server workload HTTP 2xx responses',
        description: 'The types of HTTP responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode2xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (2xx)',
          },
        },
      },

      serverWorkloadHTTP3xxResponses: {
        name: 'Server workload HTTP 3xx responses',
        description: 'The types of HTTP responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode3xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (3xx)',
          },
        },
      },

      serverWorkloadHTTP4xxResponses: {
        name: 'Server workload HTTP 4xx responses',
        description: 'The types of HTTP responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode4xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (4xx)',
          },
        },
      },

      serverWorkloadHTTP5xxResponses: {
        name: 'Server workload HTTP 5xx responses',
        description: 'The types of HTTP responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode5xxFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (5xx)',
          },
        },
      },

      serverWorkloadGRPCOKResponses: {
        name: 'Server workload GRPC OK responses',
        description: 'Overview of the types of GRPC responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusOKFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (ok)',
          },
        },
      },

      serverWorkloadGRPCErrorResponses: {
        name: 'Server workload GRPC error responses',
        description: 'Overview of the types of GRPC responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusErrorFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: (error)',
          },
        },
      },

      serverWorkloadGRPCResponses: {
        name: 'GRPC responses / $__interval',
        description: 'The types of GRPC responses sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            rangeFunction: 'increase',
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}: {{grpc_response_status}}',
          },
        },
      },

      serverWorkloadTCPRequestThroughputRate: {
        name: 'TCP request throughput',
        description: 'Rate of TCP request data received by this workload from client workloads in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_tcp_received_bytes_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{destination_workload}} <- {{source_workload}}',
          },
        },
      },

      serverWorkloadTCPResponseThroughputRate: {
        name: 'TCP response throughput',
        description: 'Rate of TCP response data sent from this workload to client workloads in the Istio system.',
        type: 'counter',
        unit: 'Bps',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_tcp_sent_bytes_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}' % selectors,
            aggKeepLabels: ['source_workload', 'destination_workload'],
            legendCustomTemplate: '{{destination_workload}} -> {{source_workload}}',
          },
        },
      },
    },
  }
