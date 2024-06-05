local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    discoveryMetric: {
      stackdriver: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count',
    },
    // v2 metrics are Beta as of this writing, and will show stats for all objects, including soft-deleted.
    // Given that they are Beta, we'll use the (implied) v1 metrics for now.
    signals: {
      // There is a v2 of this
      objectCountTotal: {
        name: 'Object Count',
        description: 'Number of objects stored.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count{%(queriesSelector)s}',
          },
        },
      },

      objectCount: {
        name: 'Object Count',
        description: 'Number of objects stored.',
        type: 'gauge',
        rangeFunction: 'none',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_object_count{%(queriesSelector)s}',
          },
        },
      },

      apiRequestCount: {
        name: 'API Requests',
        description: 'Rate of API requests',
        type: 'counter',
        rangeFunction: 'rate',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_api_request_count{%(queriesSelector)s}',
          },
        },
      },

      networkRx: {
        name: 'Network Received',
        description: 'Total bytes received over the network',
        type: 'gauge',
        unit: 'bytes',
        rangeFunction: 'none',
        sources: {
          stackdriver: {
            expr: 'sum by (method, bucket_name, response_code) (stackdriver_gcs_bucket_storage_googleapis_com_network_received_bytes_count{%(queriesSelector)s} > 0)',
          },
        },
      },

      networkTx: {
        name: 'Network Sent',
        description: 'Total bytes sent over the network',
        type: 'gauge',
        unit: 'bytes',
        rangeFunction: 'none',
        sources: {
          stackdriver: {
            expr: 'sum by (method, bucket_name, response_code) (stackdriver_gcs_bucket_storage_googleapis_com_network_sent_bytes_count{%(queriesSelector)s} > 0)',
          },
        },
      },

      // There is a v2 of this
      totalBytesTotal: {
        name: 'Total Bytes',
        description: 'Total bytes stored',
        type: 'gauge',
        unit: 'bytes',
        rangeFunction: 'none',
        aggLevel: 'instance',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gcs_bucket_storage_googleapis_com_storage_total_bytes{%(queriesSelector)s}',
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
        },
      },

      // There is a v2 of this
      totalByteSeconds: {  // WTF is this?

      },
    },
  }
