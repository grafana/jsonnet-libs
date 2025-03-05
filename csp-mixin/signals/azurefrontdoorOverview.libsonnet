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
      endpointCount: {
        name: 'Endpoints Count',
        description: 'Number of endpoints',
        type: 'gauge',
        aggFunction: 'sum',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimensionEndpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['dimensionEndpoint'],
            exprWrappers: [['count(', ')']],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimension_Endpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['dimension_Endpoint'],
            exprWrappers: [['count(', ')']],
          },
        },
      },

      top5Errors: {
        name: 'Top 5 Endpoints by Errors',
        description: 'Top 5 Endpoints with higher percentage of client requests for which the response status code is 4XX or 5XX',
        type: 'raw',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'avg by (job, resourceGroup, subscriptionName, resourceName, dimensionClientCountry, dimensionClientRegion, dimension_clientcountry, dimension_clientregion) (azure_microsoft_cdn_profiles_percentage4xx_average_percent{%(queriesSelector)s}) + avg by (job, resourceGroup, subscriptionName, resourceName, dimensionClientCountry, dimensionClientRegion, dimension_clientcountry, dimension_clientregion) (azure_microsoft_cdn_profiles_percentage5xx_average_percent{%(queriesSelector)s})',
            legendCustomTemplate: '',
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      totalRequests: {
        name: 'Total Requests',
        description: 'The number of client requests served by the HTTP/S proxy',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimensionEndpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: 'Total Requests',
            aggKeepLabels: ['dimensionEndpoint'],
            exprWrappers: [['sum(', ')']],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimension_Endpoint!="",%(queriesSelector)s}',
            legendCustomTemplate: 'Total Requests',
            aggKeepLabels: ['dimension_Endpoint'],
            exprWrappers: [['sum(', ')']],
          },
        },
      },

      requestsByCountry: {
        name: 'Requests by country',
        description: 'The number of client requests served by the HTTP/S proxy grouped by country',
        type: 'gauge',
        aggFunction: 'sum',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimensionClientCountry!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionClientCountry}} {{dimension_clientcountry}}',
            aggKeepLabels: ['dimensionClientCountry'],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimension_clientcountry!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionClientCountry}} {{dimension_clientcountry}}',
            aggKeepLabels: ['dimension_clientcountry'],
          },
        },
      },

      requestsByStatus: {
        name: 'Requests by status',
        description: 'The number of client requests served by the HTTP/S proxy grouped by status group',
        type: 'gauge',
        aggFunction: 'sum',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimensionHttpStatusGroup!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionHttpStatusGroup}} {{dimension_httpstatusgroup}}',
            aggKeepLabels: ['dimensionHttpStatusGroup'],
          },
          azuremonitor_agentless: {
            expr: 'azure_microsoft_cdn_profiles_requestcount_total_count{dimension_httpstatusgroup!="",%(queriesSelector)s}',
            legendCustomTemplate: '{{dimensionHttpStatusGroup}} {{dimension_httpstatusgroup}}',
            aggKeepLabels: ['dimension_httpstatusgroup'],
          },
        },
      },

      error4xx: {
        name: '4XX Errors percentage',
        description: '',
        type: 'raw',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_percentage4xx_average_percent{%(queriesSelector)s}',
            legendCustomTemplate: '4xx',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      error5xx: {
        name: '5XX Errors percentage',
        description: '',
        type: 'raw',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_percentage5xx_average_percent{%(queriesSelector)s}',
            legendCustomTemplate: '5xx',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      requestsSize: {
        name: 'Requests size',
        description: 'The number of bytes sent as requests from clients to AFDX.',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_requestsize_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Requests',
            exprWrappers: [['sum(', ')']],
          },
        },
      },

      responsesSize: {
        name: 'Responses size',
        description: 'The number of bytes sent as responses from HTTP/S proxy to clients.',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_responsesize_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Responses',
            exprWrappers: [['sum(', ')']],
          },
        },
      },

      totalLatency: {
        name: 'Total latency',
        description: 'The time calculated from when the client request was received by the HTTP/S proxy until the client acknowledged the last response byte from the HTTP/S proxy\tTotalLatency',
        type: 'raw',
        unit: 'ms',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_totallatency_average_milliseconds{%(queriesSelector)s}',
            legendCustomTemplate: '',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      originHealthPercentage: {
        name: 'Origin Health percentage',
        description: 'The percentage of successful health probes from AFDX to backends.',
        type: 'raw',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_originhealthpercentage_average_percent{%(queriesSelector)s}',
            legendCustomTemplate: '',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      originLatency: {
        name: 'Origin Latency average',
        description: 'The time calculated from when the request was sent by AFDX edge to the backend until AFDX received the last response byte from the backend.',
        type: 'raw',
        unit: 'ms',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_cdn_profiles_originlatency_average_milliseconds{%(queriesSelector)s}',
            legendCustomTemplate: '',
            exprWrappers: [['avg(', ')']],
          },
        },
      },
    },
  }
