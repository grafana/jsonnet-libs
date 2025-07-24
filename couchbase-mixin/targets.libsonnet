local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;

{
  new(this): {
    local vars = this.grafana.variables,
    local clusterSelector = vars.clusterSelector,
    local nodeSelector = vars.nodeSelector,
    local bucketSelector = vars.bucketSelector,

    //
    // Cluster Overview Dashboard Targets
    //

    // Top nodes metrics
    topNodesByMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(job, couchbase_cluster, instance) (sys_mem_actual_used{%(clusterSelector)s})) / (sum by(job, couchbase_cluster, instance) (clamp_min(sys_mem_actual_free{%(clusterSelector)s}, 1)) + sum by(couchbase_cluster, instance, job) (sys_mem_actual_used{%(clusterSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    topNodesByHTTPRequests:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(job, couchbase_cluster, instance) (rate(cm_http_requests_total{%(clusterSelector)s}[$__rate_interval])))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    topNodesByQueryServiceRequests:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(job, instance, couchbase_cluster) (rate(n1ql_requests{%(clusterSelector)s}[$__rate_interval])))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    topNodesByIndexAverageScanLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, avg by(instance, couchbase_cluster, job) (index_avg_scan_latency{%(clusterSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    // XDCR metrics
    xdcrReplicationRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(couchbase_cluster, job) (rate(xdcr_data_replicated_bytes{%(clusterSelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}}'),

    xdcrDocsReceived:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, couchbase_cluster) (rate(xdcr_docs_received_from_dcp_total{%(clusterSelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}}'),

    // Backup metrics
    localBackupSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(couchbase_cluster, job, instance) (backup_data_size{%(clusterSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    // Top buckets metrics (cluster level)
    topBucketsByMemoryUsed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(bucket, couchbase_cluster, job) (kv_mem_used_bytes{%(clusterSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{bucket}}'),

    topBucketsByDiskUsed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(job, couchbase_cluster, bucket) (couch_docs_actual_disk_size{%(clusterSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{bucket}}'),

    clusterTopBucketsByOperations:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(couchbase_cluster, job, bucket) (rate(kv_ops{%(clusterSelector)s}[$__rate_interval])))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{bucket}}'),

    clusterTopBucketsByOperationsFailed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(couchbase_cluster, job, bucket) (rate(kv_ops_failed{%(clusterSelector)s}[$__rate_interval])))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{bucket}}'),

    clusterTopBucketsByVBucketsCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(couchbase_cluster, job, bucket) (kv_num_vbuckets{%(clusterSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{bucket}}'),

    clusterTopBucketsByVBucketQueueMemory:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(couchbase_cluster, job, bucket) (kv_vb_queue_memory_bytes{%(clusterSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{bucket}}'),

    //
    // Node Overview Dashboard Targets
    //

    // Node system metrics
    memoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sys_mem_actual_used{%(nodeSelector)s} / (clamp_min(sys_mem_actual_free{%(nodeSelector)s} + sys_mem_actual_used{%(nodeSelector)s}, 1))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    cpuUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(couchbase_cluster, job, instance) (sys_cpu_utilization_rate{%(nodeSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    // Memory by service
    totalMemoryUsedByService:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(couchbase_cluster, instance, job) (kv_mem_used_bytes{%(nodeSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - data'),

    totalMemoryUsedByIndexService:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'index_memory_used_total{%(nodeSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - index'),

    totalMemoryUsedByAnalyticsService:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'cbas_direct_memory_used_bytes{%(nodeSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - analytics'),

    // Node backup and connections
    backupSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(couchbase_cluster, instance, job) (backup_data_size{%(nodeSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    currentConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'kv_curr_connections{%(nodeSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    // HTTP metrics
    httpResponseCodes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, instance, couchbase_cluster, code) (rate(cm_http_requests_total{%(nodeSelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - {{code}}'),

    httpRequestMethods:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, instance, couchbase_cluster, method) (rate(cm_http_requests_total{%(nodeSelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - {{method}}'),

    // Query service metrics
    queryServiceRequests:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(n1ql_requests{%(nodeSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - >0ms'),

    queryServiceRequestsTotal:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(n1ql_requests{%(nodeSelector)s}[$__rate_interval]) + rate(n1ql_invalid_requests{%(nodeSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - total'),

    queryServiceErrors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(n1ql_errors{%(nodeSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - error'),

    queryServiceInvalidRequests:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(n1ql_invalid_requests{%(nodeSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - invalid'),

    // Query service latency buckets
    queryServiceRequests250ms:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(n1ql_requests_250ms{%(nodeSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - >250ms'),

    queryServiceRequests500ms:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(n1ql_requests_500ms{%(nodeSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - >500ms'),

    queryServiceRequests1000ms:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(n1ql_requests_1000ms{%(nodeSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - >1000ms'),

    queryServiceRequests5000ms:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(n1ql_requests_5000ms{%(nodeSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - >5000ms'),

    // Index service metrics
    indexServiceRequests:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(couchbase_cluster, instance, job) (rate(index_num_requests{%(nodeSelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    indexCacheHitRatio:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(couchbase_cluster, job, instance) (increase(index_cache_hits{%(nodeSelector)s}[$__rate_interval])) / (clamp_min(sum by(couchbase_cluster, job, instance) (increase(index_cache_hits{%(nodeSelector)s}[$__rate_interval])), 1) + sum by(couchbase_cluster, job, instance) (increase(index_cache_misses{%(nodeSelector)s}[$__rate_interval])))' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}}'),

    indexAverageScanLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(couchbase_cluster, index, instance, job) (index_avg_scan_latency{%(nodeSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{couchbase_cluster}} - {{instance}} - {{index}}'),

    //
    // Bucket Overview Dashboard Targets
    //

    // Detailed bucket metrics (instance-level)
    bucketTopBucketsByMemoryUsed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, kv_mem_used_bytes{%(bucketSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{instance}} - {{bucket}}'),

    topBucketsByDiskUsedDetailed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, couch_docs_actual_disk_size{%(bucketSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{instance}} - {{bucket}}'),

    topBucketsByCurrentItems:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(couchbase_cluster, job, bucket) (kv_curr_items{%(bucketSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{instance}} - {{bucket}}'),

    // Bucket operations
    topBucketsByOperationsWithOp:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(bucket, couchbase_cluster, instance, job, op) (rate(kv_ops{%(bucketSelector)s}[$__rate_interval])))' % vars
      )
      + prometheusQuery.withLegendFormat('{{instance}} - {{bucket}} - {{op}}'),

    topBucketsByOperationsFailedDetailed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(bucket, couchbase_cluster, instance, job) (rate(kv_ops_failed{%(bucketSelector)s}[$__rate_interval])))' % vars
      )
      + prometheusQuery.withLegendFormat('{{instance}} - {{bucket}}'),

    topBucketsByHighPriorityRequests:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(bucket, couchbase_cluster, instance, job) (kv_num_high_pri_requests{%(bucketSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{instance}} - {{bucket}}'),

    // Bucket cache and performance
    bottomBucketsByCacheHitRatio:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'bottomk(5, sum by(couchbase_cluster, job, instance, bucket) (increase(index_cache_hits{%(bucketSelector)s}[$__rate_interval])) / (clamp_min(sum by(couchbase_cluster, job, instance, bucket) (increase(index_cache_hits{%(bucketSelector)s}[$__rate_interval])), 1) + sum by(couchbase_cluster, job, instance, bucket) (increase(index_cache_misses{%(bucketSelector)s}[$__rate_interval]))))' % vars
      )
      + prometheusQuery.withLegendFormat('{{instance}} - {{bucket}}'),

    // Bucket vBuckets
    bucketTopBucketsByVBucketsCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, sum by(bucket, couchbase_cluster, instance, job) (kv_num_vbuckets{%(bucketSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('{{instance}} - {{bucket}}'),
  },
}
