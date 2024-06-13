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
        name: 'Top 10 Buckets - Object Count',
        description: 'Number of objects stored.',
        type: 'gauge',
        unit: 'locale',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count{%(queriesSelector)s}',
            exprWrappers: [['topk(10,', ')']],
          },
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_blobcount_average_count{%(queriesSelector)s}',
            exprWrappers: [['topk(10,', ')']],
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
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_containercount_average_count{%(queriesSelector)s}',
          },
        },
      },

      apiRequestCount: {
        name: 'API Requests',
        description: 'Count of API requests',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (bucket_name, method, response_code) (rate(stackdriver_gcs_bucket_storage_googleapis_com_api_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{bucket_name}}: {{method}} - {{response_code}}',
          },
          azuremonitor: {
            expr: 'sum by (resourceName, dimensionApiname, dimensionResponsetype) (azure_microsoft_storage_storageaccounts_blobservices_transactions_total_count{dimensionApiname!="",%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceName}}: {{dimensionApiname}} - {{dimensionResponsetype}}',
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
        name: 'Top 10 Buckets - Total Bytes',
        description: 'Total bytes stored',
        type: 'gauge',
        unit: 'bytes',
        rangeFunction: 'none',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_total_bytes{%(queriesSelector)s}',
            exprWrappers: [['topk(10,', ')']],
          },
          azuremonitor: {
            expr: 'azure_microsoft_storage_storageaccounts_blobservices_blobcapacity_average_bytes{%(queriesSelector)s}',
            exprWrappers: [['topk(10,', ')']],
          },
        },
      },
    },
  }
