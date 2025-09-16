local commonlib = import 'common-lib/common/main.libsonnet';


function(this)
  local groupAggListWithInstance = std.join(',', this.groupLabels) + (if std.length(this.instanceLabels) > 0 then ',' + std.join(',', this.instanceLabels) else '');
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)) + ' - {{bucket}}',
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'kv_mem_used_bytes',
    },
    signals: {
      // Bucket memory and disk usage
      bucketMemoryUsed: {
        name: 'Bucket memory used',
        nameShort: 'Memory',
        type: 'gauge',
        description: 'Memory used for the top buckets.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk(5, kv_mem_used_bytes{%(queriesSelector)s})',
          },
        },
      },
      bucketDiskUsed: {
        name: 'Bucket disk used',
        nameShort: 'Disk',
        type: 'gauge',
        description: 'Disk used for the top buckets.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk(5, couch_docs_actual_disk_size{%(queriesSelector)s})',
          },
        },
      },
      bucketCurrentItems: {
        name: 'Bucket current items',
        nameShort: 'Items',
        type: 'gauge',
        description: 'Number of active items for the largest buckets.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(couchbase_cluster, job, bucket) (kv_curr_items{%(queriesSelector)s}))',
          },
        },
      },

      // Bucket operations
      bucketOperationsWithOp: {
        name: 'Bucket operations by operation type',
        nameShort: 'Operations',
        type: 'raw',
        description: 'Rate of operations for the busiest buckets by operation type.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(bucket, ' + groupAggListWithInstance + ', op) (rate(kv_ops{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{instance}} - {{bucket}} - {{op}}',
          },
        },
      },
      bucketOperationsFailed: {
        name: 'Bucket operations failed',
        nameShort: 'Failed Ops',
        type: 'raw',
        description: 'Rate of operations failed for the most problematic buckets.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(bucket, ' + groupAggListWithInstance + ') (rate(kv_ops_failed{%(queriesSelector)s}[$__rate_interval])))',
          },
        },
      },
      bucketHighPriorityRequests: {
        name: 'Bucket high priority requests',
        nameShort: 'High Priority',
        type: 'gauge',
        description: 'Rate of high priority requests processed by the KV engine for the top buckets.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(bucket, ' + groupAggListWithInstance + ') (kv_num_high_pri_requests{%(queriesSelector)s}))',
          },
        },
      },

      // Bucket cache performance
      bucketCacheHitRatio: {
        name: 'Bucket cache hit ratio',
        nameShort: 'Cache hit %',
        type: 'raw',
        description: 'Worst buckets by cache hit ratio.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'bottomk(5, sum by(bucket, ' + groupAggListWithInstance + ') (increase(index_cache_hits{%(queriesSelector)s}[$__interval:] offset $__interval)) / (clamp_min(sum by(bucket, ' + groupAggListWithInstance + ') (increase(index_cache_hits{%(queriesSelector)s}[$__interval:] offset $__interval)), 1) + sum by(bucket, ' + groupAggListWithInstance + ') (increase(index_cache_misses{%(queriesSelector)s}[$__interval:] offset $__interval))))',
          },
        },
      },

      // Bucket vBuckets
      bucketVBucketsCount: {
        name: 'Bucket vBuckets count',
        nameShort: 'vBuckets count',
        type: 'raw',
        description: 'The number of vBuckets for the top buckets.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk(5, sum by(bucket, ' + groupAggListWithInstance + ') (kv_num_vbuckets{%(queriesSelector)s}))',
          },
        },
      },
    },
  }
