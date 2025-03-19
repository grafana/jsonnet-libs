local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    aggLevel: 'instance',
    discoveryMetric: {
      azuremonitor: 'azure_microsoft_cdn_profiles_requestcount_total_count',
      azuremonitor_agentless: self.azuremonitor,
    },
    signals: {

      requestsByEndpoint: {
        name: 'Total requests',
        description: 'Number of requests by endpoints.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimensionEndpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimensionEndpoint'],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimension_Endpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimension_Endpoint'],
          },
        },
      },

      requestsSizeByEndpoints: {
        name: 'Requests size',
        description: 'The number of bytes sent as requests from clients to AFDX.',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestsize_total_bytes{dimensionEndpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimensionEndpoint'],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_requestsize_total_bytes{dimension_Endpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimension_Endpoint'],
          },
        },
      },

      responsesSizeByEndpoints: {
        name: 'Responses size',
        description: 'The number of bytes sent as responses from HTTP/S proxy to clients.',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_responsesize_total_bytes{dimensionEndpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimensionEndpoint'],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_responsesize_total_bytes{dimension_Endpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimension_Endpoint'],
          },
        },
      },

      totalLatencyByEndpoints: {
        name: 'Total latency',
        description: 'The time calculated from when the client request was received by the HTTP/S proxy until the client acknowledged the last response byte from the HTTP/S proxy\tTotalLatency',
        type: 'gauge',
        unit: 'ms',
        aggFunction: 'avg',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_totallatency_average_milliseconds{dimensionEndpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimensionEndpoint'],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_totallatency_average_milliseconds{dimension_Endpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimension_Endpoint'],
          },
        },
      },

      errorsByEndpoints: {
        name: 'Percentage of errors',
        description: '',
        type: 'raw',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'avg by (job, resourceGroup, subscriptionName, dimensionEndpoint) (azure_microsoft_cdn_profiles_percentage4xx_average_percent{dimensionEndpoint!="",%(queriesSelector)s}) + avg by (job, resourceGroup, subscriptionName, dimensionEndpoint) (azure_microsoft_cdn_profiles_percentage5xx_average_percent{dimensionEndpoint!="",%(queriesSelector)s})',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimensionEndpoint'],
          },
          azuremonitor_agentless: {
            expr: 'avg by (job, resourceGroup, subscriptionName, dimension_Endpoint) (azure_microsoft_cdn_profiles_percentage4xx_average_percent{dimension_Endpoint!="",%(queriesSelector)s}) + avg by (job, resourceGroup, subscriptionName, dimension_Endpoint) (azure_microsoft_cdn_profiles_percentage5xx_average_percent{dimension_Endpoint!="",%(queriesSelector)s})',
            legendCustomTemplate: '{{dimensionEndpoint}}{{dimension_Endpoint}}',
            aggKeepLabels: ['dimension_Endpoint'],
          },
        },
      },

      originRequestsByEndpoints: {
        name: 'Origin Request count',
        description: 'The number of requests sent from AFDX to origin.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_originrequestcount_total_count{dimensionEndpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimensionEndpoint'],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_originrequestcount_total_count{dimension_Endpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimension_Endpoint'],
          },
        },
      },

      originLatencyByEndpoints: {
        name: 'Origin Latency average',
        description: 'The time calculated from when the request was sent by AFDX edge to the backend until AFDX received the last response byte from the backend.',
        type: 'gauge',
        unit: 'ms',
        aggFunction: 'avg',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_originlatency_average_milliseconds{dimensionEndpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimensionEndpoint'],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_originlatency_average_milliseconds{dimension_Endpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionEndpoint}} {{dimension_Endpoint}}',
            aggKeepLabels: ['dimension_Endpoint'],
          },
        },
      },
    },
  }
