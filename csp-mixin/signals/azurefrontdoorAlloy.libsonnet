local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: ['dimensionEndpoint'],
    aggLevel: 'instance',
    discoveryMetric: {
      azuremonitor: 'azure_microsoft_cdn_profiles_requestcount_total_count',
    },
    signals: {
      requestsByEndpoint: {
        name: 'Total requests Alloy',
        description: 'Number of requests by endpoints.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}}',
          },
        },
      },

      requestsSizeByEndpoints: {
        name: 'Requests size Alloy',
        description: 'The number of bytes sent as requests from clients to AFDX.',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestsize_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}}',
          },
        },
      },

      responsesSizeByEndpoints: {
        name: 'Responses size Alloy',
        description: 'The number of bytes sent as responses from HTTP/S proxy to clients.',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_responsesize_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}}',
          },
        },
      },

      totalLatencyByEndpoints: {
        name: 'Total latency Alloy',
        description: 'The time calculated from when the client request was received by the HTTP/S proxy until the client acknowledged the last response byte from the HTTP/S proxy\tTotalLatency',
        type: 'gauge',
        unit: 'ms',
        aggFunction: 'avg',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_totallatency_average_milliseconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}}',
          },
        },
      },

      errorsByEndpoints: {
        name: 'Percentage of errors Alloy',
        description: '',
        type: 'raw',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'avg by (job, resourceGroup, subscriptionName, dimensionEndpoint) (azure_microsoft_cdn_profiles_percentage4xx_average_percent{%(queriesSelector)s}) + avg by (job, resourceGroup, subscriptionName, dimensionEndpoint) (azure_microsoft_cdn_profiles_percentage5xx_average_percent{%(queriesSelector)s})',
            legendCustomTemplate: '{{dimensionEndpoint}}',
          },
        },
      },

      originRequestsByEndpoints: {
        name: 'Origin Request count Alloy',
        description: 'The number of requests sent from AFDX to origin.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_originrequestcount_total_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}}',
          },
        },
      },

      originLatencyByEndpoints: {
        name: 'Origin Latency average Alloy',
        description: 'The time calculated from when the request was sent by AFDX edge to the backend until AFDX received the last response byte from the backend.',
        type: 'gauge',
        unit: 'ms',
        aggFunction: 'avg',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_originlatency_average_milliseconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}}',
          },
        },
      },
    },
  }
