local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
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
            expr: 'topk(5, sum by(job, couchbase_cluster, instance) (sys_mem_actual_used{%(queriesSelector)s})) / (sum by(job, couchbase_cluster, instance) (clamp_min(sys_mem_actual_free{%(queriesSelector)s}, 1)) + sum by(couchbase_cluster, instance, job) (sys_mem_actual_used{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },
      topNodesByHTTPRequests: {
        name: 'Top nodes by HTTP requests',
        nameShort: 'HTTP Requests',
        type: 'raw',
        description: 'Rate of HTTP requests handled by the cluster manager for the top nodes.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(job, couchbase_cluster, instance) (rate(cm_http_requests_total{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },
      topNodesByQueryServiceRequests: {
        name: 'Top nodes by query service requests',
        nameShort: 'N1QL Requests',
        type: 'raw',
        description: 'Rate of N1QL requests processed by the query service for the top nodes.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(job, instance, couchbase_cluster) (rate(n1ql_requests{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },
      topNodesByIndexAverageScanLatency: {
        name: 'Top nodes by index average scan latency',
        nameShort: 'Scan Latency',
        type: 'raw',
        description: 'Average time to serve an index service scan request for the top nodes.',
        unit: 'ns',
        sources: {
          prometheus: {
            expr: 'topk(5, avg by(instance, couchbase_cluster, job) (index_avg_scan_latency{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },

      // XDCR metrics
      xdcrReplicationRate: {
        name: 'XDCR replication rate',
        nameShort: 'XDCR Rate',
        type: 'raw',
        description: 'Rate of replication through the Cross Data Center Replication feature.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'sum by(couchbase_cluster, job) (rate(xdcr_data_replicated_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}}',
          },
        },
      },
      xdcrDocsReceived: {
        name: 'XDCR docs received',
        nameShort: 'XDCR Docs',
        type: 'raw',
        description: 'The rate of mutations received by this cluster.',
        unit: 'mut/sec',
        sources: {
          prometheus: {
            expr: 'sum by(job, couchbase_cluster) (rate(xdcr_docs_received_from_dcp_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}}',
          },
        },
      },

      // Backup metrics
      localBackupSize: {
        name: 'Local backup size',
        nameShort: 'Backup',
        type: 'raw',
        description: 'Size of the local backup for a node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'sum by(couchbase_cluster, job, instance) (backup_data_size{%(queriesSelector)s})',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },

      // Top buckets metrics (cluster level)
      topBucketsByMemoryUsed: {
        name: 'Top buckets by memory used',
        nameShort: 'Bucket Memory',
        type: 'raw',
        description: 'Memory used for the top buckets across the cluster.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(bucket, couchbase_cluster, job) (kv_mem_used_bytes{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByDiskUsed: {
        name: 'Top buckets by disk used',
        nameShort: 'Bucket Disk',
        type: 'raw',
        description: 'Disk used for the top buckets across the cluster.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(job, couchbase_cluster, bucket) (couch_docs_actual_disk_size{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByOperations: {
        name: 'Top buckets by operations',
        nameShort: 'Bucket Ops',
        type: 'raw',
        description: 'Rate of operations for the busiest buckets across the cluster.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(couchbase_cluster, job, bucket) (rate(kv_ops{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByOperationsFailed: {
        name: 'Top buckets by operations failed',
        nameShort: 'Bucket Failed Ops',
        type: 'raw',
        description: 'Rate of operations failed for the most problematic buckets across the cluster.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(couchbase_cluster, job, bucket) (rate(kv_ops_failed{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByVBucketsCount: {
        name: 'Top buckets by vBuckets count',
        nameShort: 'vBuckets',
        type: 'raw',
        description: 'The number of vBuckets for the top buckets across the cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(couchbase_cluster, job, bucket) (kv_num_vbuckets{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
      topBucketsByVBucketQueueMemory: {
        name: 'Top buckets by vBucket queue memory',
        nameShort: 'vBucket Memory',
        type: 'raw',
        description: 'Memory occupied by the queue for a virtual bucket for the top buckets across the cluster.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(couchbase_cluster, job, bucket) (kv_vb_queue_memory_bytes{%(queriesSelector)s}))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{bucket}}',
          },
        },
      },
    },
  } 