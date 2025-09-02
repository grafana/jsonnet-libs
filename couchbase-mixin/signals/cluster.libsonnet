local commonlib = import 'common-lib/common/main.libsonnet';


function(this)
  local groupAggListWithInstance = std.join(',', this.groupLabels) + (if std.length(this.instanceLabels) > 0 then ',' + std.join(',', this.instanceLabels) else '');
  local groupAggListWithoutInstance = std.join(',', this.groupLabels);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: '{{couchbase_cluster}} - ' + std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'sys_mem_actual_used',
    },
    signals: {
      // Top nodes metrics
      topNodesByMemoryUsage: {
        name: 'Top nodes by memory usage',
        nameShort: 'Memory',
        type: 'raw',
        description: 'Top nodes by memory usage across the Couchbase cluster.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(' + groupAggListWithInstance + ') (sys_mem_actual_used{%(queriesSelector)s})) / (sum by(' + groupAggListWithInstance + ') (clamp_min(sys_mem_actual_free{%(queriesSelector)s}, 1)) + sum by(' + groupAggListWithInstance + ') (sys_mem_actual_used{%(queriesSelector)s}))',
          },
        },
      },
      topNodesByHTTPRequests: {
        name: 'Top nodes by HTTP requests',
        nameShort: 'HTTP requests',
        type: 'raw',
        description: 'Rate of HTTP requests handled by the cluster manager for the top nodes.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(' + groupAggListWithInstance + ') (rate(cm_http_requests_total{%(queriesSelector)s}[$__rate_interval])))',
          },
        },
      },
      topNodesByQueryServiceRequests: {
        name: 'Top nodes by query service requests',
        nameShort: 'N1QL requests',
        type: 'raw',
        description: 'Rate of N1QL requests processed by the query service for the top nodes.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(' + groupAggListWithInstance + ') (rate(n1ql_requests{%(queriesSelector)s}[$__rate_interval])))',
          },
        },
      },
      topNodesByIndexAverageScanLatency: {
        name: 'Top nodes by index average scan latency',
        nameShort: 'Scan latency',
        type: 'raw',
        description: 'Average time to serve an index service scan request for the top nodes.',
        unit: 'ns',
        sources: {
          prometheus: {
            expr: 'topk(5, avg by(' + groupAggListWithInstance + ') (index_avg_scan_latency{%(queriesSelector)s}))',
          },
        },
      },

      // XDCR metrics
      xdcrReplicationRate: {
        name: 'XDCR replication rate',
        nameShort: 'XDCR rate',
        type: 'raw',
        description: 'Rate of replication through the Cross Data Center Replication feature.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ') (rate(xdcr_data_replicated_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}}',
          },
        },
      },
      xdcrDocsReceived: {
        name: 'XDCR docs received',
        nameShort: 'XDCR docs',
        type: 'raw',
        description: 'The rate of mutations received by this cluster.',
        unit: 'mut/sec',
        sources: {
          prometheus: {
            expr: 'sum by(' + std.join(',', this.groupLabels) + ') (rate(xdcr_docs_received_from_dcp_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}}',
          },
        },
      },

      // Backup metrics
      localBackupSize: {
        name: 'Local backup size',
        nameShort: 'Backup size',
        type: 'raw',
        description: 'Size of the local backup for a node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ') (backup_data_size{%(queriesSelector)s})',
          },
        },
      },

      // Top buckets metrics (cluster level)
      topBucketsByMemoryUsed: {
        name: 'Top buckets by memory used',
        nameShort: 'Bucket memory',
        type: 'raw',
        description: 'Memory used for the top buckets across the cluster.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(bucket, ' + std.join(',', this.groupLabels) + ') (kv_mem_used_bytes{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByDiskUsed: {
        name: 'Top buckets by disk used',
        nameShort: 'Bucket disk',
        type: 'raw',
        description: 'Disk used for the top buckets across the cluster.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(' + std.join(',', this.groupLabels) + ', bucket) (couch_docs_actual_disk_size{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByOperations: {
        name: 'Top buckets by operations',
        nameShort: 'Bucket ops',
        type: 'raw',
        description: 'Rate of operations for the busiest buckets across the cluster.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(' + groupAggListWithoutInstance + ', bucket) (rate(kv_ops{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByOperationsFailed: {
        name: 'Top buckets by operations failed',
        nameShort: 'Bucket failed ops',
        type: 'raw',
        description: 'Rate of operations failed for the most problematic buckets across the cluster.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(' + groupAggListWithoutInstance + ', bucket) (rate(kv_ops_failed{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByVBucketsCount: {
        name: 'Top buckets by vBuckets count',
        nameShort: 'vBuckets count',
        type: 'raw',
        description: 'The number of vBuckets for the top buckets across the cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(' + groupAggListWithoutInstance + ', bucket) (kv_num_vbuckets{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByVBucketQueueMemory: {
        name: 'Top buckets by vBucket queue memory',
        nameShort: 'vBucket memory',
        type: 'raw',
        description: 'Memory occupied by the queue for a virtual bucket for the top buckets across the cluster.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(' + groupAggListWithoutInstance + ', bucket) (kv_vb_queue_memory_bytes{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
    },
  }
