local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    discoveryMetric: {
      stackdriver: 'stackdriver_https_lb_rule_loadbalancing_googleapis_com_https_request_count'
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
    },
  }
