local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    discoveryMetric: {
      // v2 metrics for stackdriver are Beta as of this writing, and will show stats for all objects, including soft-deleted.
      // Given that they are Beta, we'll use the (implied) v1 metrics for now.
      stackdriver: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count',
      azuremonitor: 'azure_microsoft_storage_storageaccounts_blobservices_blobcount_average_count',
    },
    signals: {
      availability: {
        name: 'Availability',
        description: 'Percent availability by API request.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_availability_average_percent{%(queriesSelector)s}',
          },
        },
      },

      objectCountTotal: {
        name: 'Object Count',
        description: 'Number of objects stored.',
        type: 'raw',
        unit: 'locale',
        sources: {
          // There is a v2 of this
          stackdriver: {
            expr: 'sum(stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count{%(queriesSelector)s})',
          },
          azuremonitor: {
            expr: 'sum(azure_microsoft_storage_storageaccounts_blobservices_blobcount_average_count{%(queriesSelector)s})',
          },
        },
      },

      objectCount: {
        name: 'Object Count',
        description: 'Number of objects stored.',
        type: 'gauge',
        unit: 'locale',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count{%(queriesSelector)s}',
          },
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_blobcount_average_count{%(queriesSelector)s}',
          },
        },
      },

      objectCountTopK: {
        name: 'Top 5 Buckets - Object Count',
        description: 'Number of objects stored.',
        type: 'gauge',
        unit: 'locale',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count{%(queriesSelector)s}',
            exprWrappers: [['topk(5,', ')']],
          },
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_blobcount_average_count{%(queriesSelector)s}',
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      bucketCount: {
        name: 'Bucket Count',
        description: 'Number of storage buckets.',
        type: 'raw',
        unit: 'locale',
        sources: {
          stackdriver: {
            expr: 'count(sum by (bucket_name) (stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count{%(queriesSelector)s}))',
          },
          azuremonitor: {
            expr: 'sum by (resourceName) (azure_microsoft_storage_storageaccounts_blobservices_containercount_average_count{%(queriesSelector)s})',
          },
        },
      },

      // stackdriver response_code="OK"
      // azuremonitor dimensionResponseType="Success"

      apiRequestByTypeCount: {
        name: 'API requests by type',
        description: 'Count of all API requests',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (method) (rate(stackdriver_gcs_bucket_storage_googleapis_com_api_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{method}}',
          },
          azuremonitor: {
            expr: 'sum by (dimensionApiname) (azure_microsoft_storage_storageaccounts_blobservices_transactions_total_count{dimensionApiname!="",%(queriesSelector)s})',
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
          stackdriver: {
            expr: 'sum by (method) (rate(stackdriver_gcs_bucket_storage_googleapis_com_api_request_count{response_code!="OK", %(queriesSelector)s}[$__rate_interval])) / ' + s.signals.apiRequestByTypeCount.sources.stackdriver.expr,
            legendCustomTemplate: '{{method}}',
          },
          azuremonitor: {
            expr: 'sum by (dimensionApiname) (azure_microsoft_storage_storageaccounts_blobservices_transactions_total_count{dimensionApiname!="",dimensionResponseType!="Success",%(queriesSelector)s}) / ' + s.signals.apiRequestByTypeCount.sources.azuremonitor.expr,
            legendCustomTemplate: '{{dimensionApiname}}',
          },
        },
      },

      networkRx: {
        name: 'received',
        description: 'Total bytes received over the network',
        type: 'counter',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_network_received_bytes_count{%(queriesSelector)s}',
          },
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_ingress_total_bytes{%(queriesSelector)s}',
          },
        },
      },

      networkTx: {
        name: 'transmitted',
        description: 'Total bytes sent over the network',
        type: 'counter',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_network_sent_bytes_count{%(queriesSelector)s}',
          },
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_egress_total_bytes{%(queriesSelector)s}',
          },
        },
      },

      // TODO: Have not tested the azure queries for network. It's likely that these are gauges, and need to drop the `increase` aggregator
      networkThroughputTopK: {
        name: 'Network bits throughput',
        description: 'Total network throughput in bits for the selected timerange',
        type: 'raw',
        unit: 'bits',
        sources: {
          stackdriver: {
            expr: |||
              topk(5, sum by (job, bucket_name) (increase(stackdriver_gcs_bucket_storage_googleapis_com_network_received_bytes_count{%(queriesSelector)s}[$__range]))
              + sum by (job, bucket_name) (increase(stackdriver_gcs_bucket_storage_googleapis_com_network_sent_bytes_count{%(queriesSelector)s}[$__range])))
            |||,
          },
          azuremonitor: {
            expr: |||
              topk(5, sum by (job, resourceName) (increase(azure_microsoft_storage_storageaccounts_blobservices_ingress_total_bytes{%(queriesSelector)s}[$__range]))
              + sum by (job, resourceName) (increase(azure_microsoft_storage_storageaccounts_blobservices_egress_total_bytes{%(queriesSelector)s}[$__range])))
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
          stackdriver: {
            expr: 'sum by (job, bucket_name) (increase(stackdriver_gcs_bucket_storage_googleapis_com_network_received_bytes_count{%(queriesSelector)s}[$__range])) and ' + s.signals.networkThroughputTopK.sources.stackdriver.expr,
          },
          azuremonitor: {
            expr: 'sum by (job, resourceName) (increase(azure_microsoft_storage_storageaccounts_blobservices_ingress_total_bytes{%(queriesSelector)s}[$__range])) and ' + s.signals.networkThroughputTopK.sources.azuremonitor.expr,
          },
        },
      },

      networkTxTopK: {
        name: 'Network bits transmitted',
        description: 'Total network throughput in bits for the selected timerange',
        type: 'raw',
        unit: 'bits',
        sources: {
          stackdriver: {
            expr: 'sum by (job, bucket_name) (increase(stackdriver_gcs_bucket_storage_googleapis_com_network_sent_bytes_count{%(queriesSelector)s}[$__range])) and ' + s.signals.networkThroughputTopK.sources.stackdriver.expr,
          },
          azuremonitor: {
            expr: 'increase(azure_microsoft_storage_storageaccounts_blobservices_egress_total_bytes{%(queriesSelector)s}[$__range]) and ' + s.signals.networkThroughputTopK.sources.azuremonitor.expr,
          },
        },
      },

      totalBytesTotal: {
        name: 'Total Bytes',
        description: 'Total bytes stored',
        type: 'raw',
        unit: 'bytes',
        sources: {
          // There is a v2 of this
          stackdriver: {
            expr: 'sum(stackdriver_gcs_bucket_storage_googleapis_com_storage_total_bytes{%(queriesSelector)s})',
          },
          // Azure reports blob and index (data lake) storage separately. This query combines them, but perhaps when/if we have an index
          // dashboard it would make sense to report these separately?
          // See also: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-storage-storageaccounts-blobservices-metrics
          azuremonitor: {
            expr: |||
              sum(azure_microsoft_storage_storageaccounts_blobservices_blobcapacity_average_bytes{%(queriesSelector)s}) +
              sum(azure_microsoft_storage_storageaccounts_blobservices_indexcapacity_average_bytes{%(queriesSelector)s})
            |||,
          },
        },
      },

      totalBytes: {
        name: 'Total Bytes',
        description: 'Total bytes stored',
        type: 'gauge',
        unit: 'bytes',
        rangeFunction: 'none',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_total_bytes{%(queriesSelector)s}',
          },
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_blobcapacity_average_bytes{%(queriesSelector)s}',
          },
        },
      },

      totalBytesTopK: {
        name: 'Top 5 Buckets - Total Bytes',
        description: 'Total bytes stored',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_total_bytes{%(queriesSelector)s}',
            exprWrappers: [['topk(5,', ')']],
          },
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_blobcapacity_average_bytes{%(queriesSelector)s}',
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },
    },
  }
