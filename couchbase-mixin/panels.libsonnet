local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,
      local barGauge = g.panel.barGauge,

      //
      // Bucket Overview Dashboard Panels
      //

      bucket_topBucketsByMemoryUsedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by memory used',
          targets=[
            signals.bucket.bucketMemoryUsed.asTarget(),
          ],
          description='Memory used for the top buckets.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bucket_topBucketsByDiskUsedPanel:
        barGauge.new(
          'Top buckets by disk used'
        )
        + barGauge.queryOptions.withTargets([
          signals.bucket.bucketDiskUsed.asTarget(),
        ])
        + barGauge.standardOptions.withUnit('decbytes')
        + barGauge.standardOptions.withMin(0)
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('light-green')
          + barGauge.thresholdStep.withValue(null),
        ])
        + barGauge.panelOptions.withDescription('Disk used for the top buckets.'),

      bucket_topBucketsByCurrentItemsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by current items',
          targets=[
            signals.bucket.bucketCurrentItems.asTarget(),
          ],
          description='Number of active items for the largest buckets.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bucket_topBucketsByOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by operations',
          targets=[
            signals.bucket.bucketOperationsWithOp.asTarget(),
          ],
          description='Rate of operations for the busiest buckets.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bucket_topBucketsByOperationsFailedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by operations failed',
          targets=[
            signals.bucket.bucketOperationsFailed.asTarget(),
          ],
          description='Rate of operations failed for the most problematic buckets.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bucket_topBucketsByHighPriorityRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by high priority requests',
          targets=[
            signals.bucket.bucketHighPriorityRequests.asTarget(),
          ],
          description='Rate of high priority requests processed by the KV engine for the top buckets.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bucket_bottomBucketsByCacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bottom buckets by cache hit ratio',
          targets=[
            signals.bucket.bucketCacheHitRatio.asTarget(),
          ],
          description='Worst buckets by cache hit ratio.'
        )
        + g.panel.timeSeries.standardOptions.withMax(1)
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(true),

      bucket_topBucketsByVBucketsCountPanel:
        barGauge.new(title='Top buckets by vBuckets count')
        + barGauge.queryOptions.withTargets([
          signals.bucket.bucketVBucketsCount.asTarget(),
        ])
        + barGauge.panelOptions.withDescription('The number of vBuckets for the top buckets.')
        + barGauge.standardOptions.withMin(0)
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('light-green')
          + barGauge.thresholdStep.withValue(null),
        ])
        + barGauge.standardOptions.withUnit('none'),

      bucket_topBucketsByVBucketQueueMemoryPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by vBucket queue memory',
          targets=[
            signals.cluster.topBucketsByVBucketQueueMemory.asTarget(),
          ],
          description='Memory occupied by the queue for a virtual bucket for the top buckets.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      //
      // Node Overview Dashboard Panels
      //

      node_memoryUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory utilization',
          targets=[
            signals.node.memoryUtilization.asTarget(),
          ],
          description='Percentage of memory allocated to Couchbase on this node actually in use.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_cpuUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'CPU utilization',
          targets=[
            signals.node.cpuUtilization.asTarget(),
          ],
          description='CPU utilization percentage across all available cores on this Couchbase node.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_totalMemoryUsedByServicePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Total memory used by service',
          targets=[
            signals.node.dataServiceMemoryUsed.asTarget(),
            signals.node.indexServiceMemoryUsed.asTarget(),
            signals.node.analyticsServiceMemoryUsed.asTarget(),
          ],
          description='Memory used by the index, analytics, and data services for a node.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_backupSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Backup size',
          targets=[
            signals.node.backupSize.asTarget(),
          ],
          description='Size of the backup for a node.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_currentConnectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Current connections',
          targets=[
            signals.node.currentConnections.asTarget(),
          ],
          description='Number of active connections to a node.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_httpResponseCodesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP response codes',
          targets=[
            signals.node.httpResponseCodes.asTarget(),
          ],
          description='Rate of HTTP response codes handled by the cluster manager.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_httpRequestMethodsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP request methods',
          targets=[
            signals.node.httpRequestMethods.asTarget(),
          ],
          description='Rate of HTTP request methods handled by the cluster manager.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_queryServiceRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Query service requests',
          targets=[
            signals.query.queryServiceRequestsTotal.asTarget(),
            signals.query.queryServiceErrors.asTarget(),
            signals.query.queryServiceInvalidRequests.asTarget(),
          ],
          description='Rate of N1QL requests processed by the query service for a node.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_queryServiceRequestProcessingTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Query service request processing time',
          targets=[
            signals.query.queryServiceRequests.asTarget(),
            signals.query.queryServiceRequests250ms.asTarget(),
            signals.query.queryServiceRequests500ms.asTarget(),
            signals.query.queryServiceRequests1000ms.asTarget(),
            signals.query.queryServiceRequests5000ms.asTarget(),
          ],
          description='Rate of queries grouped by processing time.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_indexServiceRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Index service requests',
          targets=[
            signals.index.indexServiceRequests.asTarget(),
          ],
          description='Rate of index service requests served.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      node_indexCacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Index cache hit ratio',
          targets=[
            signals.index.indexCacheHitRatio.asTarget(),
          ],
          description='Ratio at which cache scans result in a hit rather than a miss.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(true),

      node_averageScanLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average scan latency',
          targets=[
            signals.index.indexAverageScanLatency.asTarget(),
          ],
          description='Average time to serve a scan request per index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ns')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      //
      // Cluster Overview Dashboard Panels
      //

      cluster_topNodesByMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top nodes by memory usage',
          targets=[
            signals.cluster.topNodesByMemoryUsage.asTarget(),
          ],
          description='Top nodes by memory usage across the Couchbase cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_topNodesByHTTPRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top nodes by HTTP requests',
          targets=[
            signals.cluster.topNodesByHTTPRequests.asTarget(),
          ],
          description='Rate of HTTP requests handled by the cluster manager for the top nodes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_topNodesByQueryServiceRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top nodes by query service requests',
          targets=[
            signals.cluster.topNodesByQueryServiceRequests.asTarget(),
          ],
          description='Rate of N1QL requests processed by the query service for the top nodes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_topNodesByIndexAverageScanLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top nodes by index average scan latency',
          targets=[
            signals.cluster.topNodesByIndexAverageScanLatency.asTarget(),
          ],
          description='Average time to serve an index service scan request for the top nodes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ns')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_xdcrReplicationRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'XDCR replication rate',
          targets=[
            signals.cluster.xdcrReplicationRate.asTarget(),
          ],
          description='Rate of replication through the Cross Data Center Replication feature.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_xdcrDocsReceivedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'XDCR docs received',
          targets=[
            signals.cluster.xdcrDocsReceived.asTarget(),
          ],
          description='The rate of mutations received by this cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('mut/sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_localBackupSizePanel:
        barGauge.new(
          'Local backup size'
        )
        + barGauge.queryOptions.withTargets([
          signals.cluster.localBackupSize.asTarget(),
        ])
        + barGauge.panelOptions.withDescription('Size of the local backup for a node.'),

      cluster_topBucketsByMemoryUsedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by memory used',
          targets=[
            signals.cluster.topBucketsByMemoryUsed.asTarget(),
          ],
          description='Memory used for the top buckets across the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_topBucketsByDiskUsedPanel:
        barGauge.new(
          'Top buckets by disk used'
        )
        + barGauge.queryOptions.withTargets([
          signals.cluster.topBucketsByDiskUsed.asTarget(),
        ])
        + barGauge.standardOptions.withUnit('decbytes')
        + barGauge.standardOptions.withMin(0)
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('light-green')
          + barGauge.thresholdStep.withValue(null),
        ])
        + barGauge.panelOptions.withDescription('Disk used for the top buckets across the cluster.'),

      cluster_topBucketsByOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by operations',
          targets=[
            signals.cluster.topBucketsByOperations.asTarget(),
          ],
          description='Rate of operations for the busiest buckets across the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_topBucketsByOperationsFailedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by operations failed',
          targets=[
            signals.cluster.topBucketsByOperationsFailed.asTarget(),
          ],
          description='Rate of operations failed for the most problematic buckets across the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cluster_topBucketsByVBucketsCountPanel:
        barGauge.new(title='Top buckets by vBuckets count')
        + barGauge.queryOptions.withTargets([
          signals.cluster.topBucketsByVBucketsCount.asTarget(),
        ])
        + barGauge.panelOptions.withDescription('The number of vBuckets for the top buckets across the cluster.')
        + barGauge.standardOptions.withMin(0)
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('light-green')
          + barGauge.thresholdStep.withValue(null),
        ])
        + barGauge.standardOptions.withUnit('none'),

      cluster_topBucketsByVBucketQueueMemoryPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top buckets by vBucket queue memory',
          targets=[
            signals.cluster.topBucketsByVBucketQueueMemory.asTarget(),
          ],
          description='Memory occupied by the queue for a virtual bucket for the top buckets across the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
