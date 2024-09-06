local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: ['job', 'project_id'],
    instanceLabels: ['backend_target_name'],
    aggLevel: 'instance',
    discoveryMetric: {
      stackdriver: 'stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count',
    },
    signals: {
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
