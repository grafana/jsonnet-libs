local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    discoveryMetric: {
      azuremonitor: 'azure_microsoft_storage_storageaccounts_queueservices_queuecount_average_count',
      azuremonitor_agentless: self.azuremonitor,
    },
    signals: {
      availability: {
        name: 'Availability',
        description: 'Percent availability by API request.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_queueservices_availability_average_percent{%(queriesSelector)s}',
          },
        },
      },

      messageCountTotal: {
        name: 'Message count',
        description: 'Number of messages stored.',
        type: 'raw',
        unit: 'locale',
        sources: {
          azuremonitor: {
            expr: 'sum(azure_microsoft_storage_storageaccounts_queueservices_queuemessagecount_average_count{%(queriesSelector)s})',
          },
        },
      },

      messageCount: {
        name: 'Message count',
        description: 'Number of messages stored.',
        type: 'gauge',
        unit: 'locale',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_queueservices_queuemessagecount_average_count{%(queriesSelector)s}',
          },
        },
      },

      messageCountTopK: {
        name: 'Top 5 queues - message count',
        description: 'Number of messages stored.',
        type: 'gauge',
        unit: 'locale',
        sources: {
          azuremonitor: {
            expr: 'max_over_time(azure_microsoft_storage_storageaccounts_queueservices_queuemessagecount_average_count{%(queriesSelector)s}[$__range])',
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      queueCount: {
        name: 'Queue count',
        description: 'Number of message queues.',
        type: 'gauge',
        unit: 'locale',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_queueservices_queuecount_average_count{%(queriesSelector)s}',
          },
        },
      },

      // azuremonitor dimensionResponseType="Success"

      apiRequestByTypeCount: {
        name: 'API requests by type',
        description: 'Count of all API requests',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum by (dimensionApiname) (azure_microsoft_storage_storageaccounts_queueservices_transactions_total_count{dimensionApiname!="",%(queriesSelector)s})',
            legendCustomTemplate: '{{dimensionApiname}}',
          },
        },
      },

      apiRequestErrorRate: {
        name: 'API error rate by type',
        description: 'Percentage of api request failure by type',
        type: 'raw',
        unit: 'percentunit',
        sources: {
          azuremonitor: {
            expr: 'sum by (dimensionApiname) (azure_microsoft_storage_storageaccounts_queueservices_transactions_total_count{dimensionApiname!="",dimensionResponseType!="Success",%(queriesSelector)s}) / ' + s.signals.apiRequestByTypeCount.sources.azuremonitor.expr,
            legendCustomTemplate: '{{dimensionApiname}}',
          },
        },
      },

      networkRx: {
        name: 'received',
        description: 'Total bytes received over the network',
        type: 'gauge',
        unit: 'bps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_queueservices_ingress_total_bytes{%(queriesSelector)s}',
          },
        },
      },

      networkTx: {
        name: 'transmitted',
        description: 'Total bytes sent over the network',
        type: 'gauge',
        unit: 'bps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_queueservices_egress_total_bytes{%(queriesSelector)s}',
          },
        },
      },

      networkThroughputTopK: {
        name: 'Network bits throughput',
        description: 'Total network throughput in bits for the selected timerange',
        type: 'raw',
        unit: 'bits',
        sources: {
          azuremonitor: {
            expr: |||
              topk(5, sum by (job, resourceName) (sum_over_time(azure_microsoft_storage_storageaccounts_queueservices_ingress_total_bytes{%(queriesSelector)s}[$__range]))
              + sum by (job, resourceName) (sum_over_time(azure_microsoft_storage_storageaccounts_queueservices_egress_total_bytes{%(queriesSelector)s}[$__range])))
            |||,
          },
        },
      },

      networkRxTopK: {
        name: 'Network bits received',
        description: 'Total network throughput in bits for the selected timerange',
        type: 'raw',
        unit: 'bits',
        sources: {
          azuremonitor: {
            expr: 'sum by (job, resourceName) (sum_over_time(azure_microsoft_storage_storageaccounts_queueservices_ingress_total_bytes{%(queriesSelector)s}[$__range])) and ' + s.signals.networkThroughputTopK.sources.azuremonitor.expr,
          },
        },
      },

      networkTxTopK: {
        name: 'Network bits transmitted',
        description: 'Total network throughput in bits for the selected timerange',
        type: 'raw',
        unit: 'bits',
        sources: {
          azuremonitor: {
            expr: 'sum by (job, resourceName) (sum_over_time(azure_microsoft_storage_storageaccounts_queueservices_egress_total_bytes{%(queriesSelector)s}[$__range])) and ' + s.signals.networkThroughputTopK.sources.azuremonitor.expr,
          },
        },
      },

      totalBytesTotal: {
        name: 'Total bytes',
        description: 'Total bytes stored',
        type: 'raw',
        unit: 'bytes',
        sources: {
          azuremonitor: {
            expr: |||
              sum(max_over_time(azure_microsoft_storage_storageaccounts_queueservices_queuecapacity_average_bytes{%(queriesSelector)s}[$__range]))
            |||,
          },
        },
      },

      totalBytes: {
        name: 'Total bytes',
        description: 'Total bytes stored',
        type: 'gauge',
        unit: 'bytes',
        rangeFunction: 'none',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_queueservices_queuecapacity_average_bytes{%(queriesSelector)s}',
          },
        },
      },

      totalBytesTopK: {
        name: 'Top 5 buckets - total bytes',
        description: 'Total bytes stored',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          azuremonitor: {
            expr: 'max_over_time(azure_microsoft_storage_storageaccounts_queueservices_queuecapacity_average_bytes{%(queriesSelector)s}[$__range])',
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },
    },
  }
