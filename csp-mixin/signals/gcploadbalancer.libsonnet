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
        name: 'Requests by status code',
        description: 'Amount of requests sent by status code for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'label_replace(sum by (response_code_class) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s}[$__rate_interval])),"response_code_class","${1}xx","response_code_class","([0-9])00")',
            legendCustomTemplate: '{{response_code_class}}',
          },
        },
      },

      requestsByCountry: {
        name: 'Requests by country',
        description: 'Amount of requests sent by country for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (backend_target_name, client_country) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{client_country}}',
          },
        },
      },

      requestsByCache: {
        name: 'Requests by cache results',
        description: 'Amount of cache results for the filters selected',
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
        description: 'Amount of requests by protocol for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (backend_target_name, protocol) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{protocol}}',
          },
        },
      },

      errorRate: {
        name: 'Error rate percentage',
        description: 'Percentage of requests failing for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: '100 * (sum(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s, response_code_class!="200", response_code_class!="0"}) / sum(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count{%(queriesSelector)s}))',
            legendCustomTemplate: 'Error Rate visualization',
          },
        },
      },

      totalResponseLatency50: {
        name: 'Total Response',
        description: 'Latency of all responses for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.50, sum by(le) (stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_bucket{%(queriesSelector)s}) > 0)',
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
            expr: 'histogram_quantile(0.90, sum by(le) (stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_bucket{%(queriesSelector)s}) > 0)',
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
            expr: 'histogram_quantile(0.99, sum by(le) (stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_bucket{%(queriesSelector)s}) > 0)',
            legendCustomTemplate: 'p99',
          },
        },
      },

      totalResponseLatencyAverage: {
        name: 'Latency Average',
        description: 'Latency of return trip time for the frontend for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_sum{%(queriesSelector)s}) / sum(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_total_latencies_count{%(queriesSelector)s})',
            legendCustomTemplate: 'Average',
          },
        },
      },

      frontendLatency50: {
        name: 'Frontend RTT',
        description: 'Latency of return trip time for the frontend for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.50,sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_frontend_tcp_rtt_bucket{%(queriesSelector)s}[$__rate_interval])) > 0)',
            legendCustomTemplate: 'p50',
          },
        },
      },

      frontendLatency90: {
        name: 'Frontend RTT Latency 90',
        description: 'Latency of return trip time for the frontend for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.90,sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_frontend_tcp_rtt_bucket{%(queriesSelector)s}[$__rate_interval])) > 0)',
            legendCustomTemplate: 'p90',
          },
        },
      },

      frontendLatency99: {
        name: 'Frontend RTT Latency 99',
        description: 'Latency of return trip time for the frontend for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.99,sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_frontend_tcp_rtt_bucket{%(queriesSelector)s}[$__rate_interval])) > 0)',
            legendCustomTemplate: 'p99',
          },
        },
      },

      backendLatency50: {
        name: 'Backend Response',
        description: 'Latency of responses for the backend for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.50, sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_backend_latencies_bucket{%(queriesSelector)s}[$__rate_interval])) > 0)',
            legendCustomTemplate: 'p50',
          },
        },
      },

      backendLatency90: {
        name: 'Backend Response Latency 90',
        description: 'Latency of responses for the backend for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.90, sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_backend_latencies_bucket{%(queriesSelector)s}[$__rate_interval])) > 0)',
            legendCustomTemplate: 'p90',
          },
        },
      },

      backendLatency99: {
        name: 'Backend Response Latency 99',
        description: 'Latency of responses for the backend for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'histogram_quantile(0.99, sum by (le) (rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_backend_latencies_bucket{%(queriesSelector)s}[$__rate_interval])) > 0)',
            legendCustomTemplate: 'p99',
          },
        },
      },

      totalReqSent: {
        name: 'Total requests sent/received',
        description: 'Total bytes sent/received by load balancer for the filters selected',
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
        description: 'Total bytes received by load balancer for the filters selected',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum(rate(stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_response_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Received',
          },
        },
      },
    },
  }
