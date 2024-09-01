local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: ['job', 'project_id', 'client_country'],
    instanceLabels: ['backend_target_name'],
    aggLevel: 'instance',
    discoveryMetric: {
      stackdriver: 'stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count',
    },
    signals: {
      requestsByStatus: {
        name: 'Requests / sec',
        description: 'The number of requests per second by status code.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'label_replace(sum by (response_code_class) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s}[$__rate_interval])),"response_code_class","${1}xx","response_code_class","([0-9])00")',
            legendCustomTemplate: '{{response_code_class}}',
          },
        },
      },

      requestsByCountry: {
        name: 'Requests by Country',
        description: 'The number of requests per second by client country.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (backend_target_name, client_country) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{client_country}}',
          },
        },
      },

      requestsByCache: {
        name: 'Requests by Cache Results',
        description: 'The cache results per second of requests.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (backend_target_name, cache_result) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{cache_result}}',
          },
        },
      },

      requestsByProtocol: {
        name: 'Requests by protocol',
        description: 'Requests per second by protocol.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (backend_target_name, protocol) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{protocol}}',
          },
        },
      },

      totalResponseLatency50: {
        name: 'Total Response Latency',
        description: 'The total latency of responses',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.50, sum by(le) (stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_bucket{%(queriesSelector)s}))',
            legendCustomTemplate: 'p50',
          },
        },
      },

      totalResponseLatency90: {
        name: 'Latency 90',
        description: 'The total latency of responses',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.90, sum by(le) (stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_bucket{%(queriesSelector)s}))',
            legendCustomTemplate: 'p90',
          },
        },
      },

      totalResponseLatency99: {
        name: 'Latency 99',
        description: 'The total latency of responses',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.99, sum by(le) (stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_bucket{%(queriesSelector)s}))',
            legendCustomTemplate: 'p99',
          },
        },
      },

      totalResponseLatencyAverage: {
        name: 'Latency Average',
        description: 'The total latency of responses',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_sum{%(queriesSelector)s}) / sum(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_count{%(queriesSelector)s})',
            legendCustomTemplate: 'Average',
          },
        },
      },

      frontendLatency50: {
        name: 'Frontend RTT Latency',
        description: 'The latency of frontend RTT.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.50,sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_frontend_tcp_rtt_bucket{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: 'p50',
          },
        },
      },

      frontendLatency90: {
        name: 'Frontend RTT Latency 90',
        description: 'The latency of frontend RTT.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.90,sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_frontend_tcp_rtt_bucket{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: 'p90',
          },
        },
      },

      frontendLatency99: {
        name: 'Frontend RTT Latency 99',
        description: 'The latency of frontend RTT.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.99,sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_frontend_tcp_rtt_bucket{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: 'p99',
          },
        },
      },

      backendLatency50: {
        name: 'Backend Response Latency',
        description: 'The backend latency of responses.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.50, sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_backend_latencies_bucket{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: 'p50',
          },
        },
      },

      backendLatency90: {
        name: 'Backend Response Latency 90',
        description: 'The backend latency of responses.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.90, sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_backend_latencies_bucket{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: 'p90',
          },
        },
      },

      backendLatency99: {
        name: 'Backend Response Latency 99',
        description: 'The backend latency of responses.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.99, sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_backend_latencies_bucket{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: 'p99',
          },
        },
      },

      totalReqSent: {
        name: 'Total Requests sent/received',
        description: 'Number of bytes sent from/received by the load balancer.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum(rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Sent',
          },
        },
      },

      totalReqReceived: {
        name: 'Total Requests received',
        description: 'Number of bytes sent from/received by the load balancer.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum(rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_response_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Received',
          },
        },
      },

      backendTotalReqSent: {
        name: 'Backend Total Requests sent/received',
        description: 'The number of bytes per second in requests sent from the load balancer to backends and in responses received from the load balancer to the backends.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum(rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_backend_request_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Sent',
          },
        },
      },

      backendTotalReqReceived: {
        name: 'Backend Total Requests received',
        description: 'The number of bytes per second in requests sent from the load balancer to backends and in responses received from the load balancer to the backends.',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum(rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_backend_response_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Received',
          },
        },
      },
    },
  }
