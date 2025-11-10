local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // Overview panels - Status panels
      overviewNodesUpPanel:
        g.panel.barGauge.new('Nodes up')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.overview.nodeUp.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Up/down status for each node in the cluster.')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withValue(0) + g.panel.barGauge.standardOptions.threshold.step.withColor('red'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(1) + g.panel.barGauge.standardOptions.threshold.step.withColor('green'),
        ])
        + g.panel.barGauge.options.withDisplayMode('basic')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withShowUnfilled(true),

      overviewDatabasesUpPanel:
        g.panel.barGauge.new('Databases up')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.overview.databaseUp.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Up/down status for each database in the cluster.')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.withMax(1)
        + g.panel.barGauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withValue(0) + g.panel.barGauge.standardOptions.threshold.step.withColor('red'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(1) + g.panel.barGauge.standardOptions.threshold.step.withColor('green'),
        ])
        + g.panel.barGauge.options.withDisplayMode('basic')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withShowUnfilled(true),

      overviewShardsUpPanel:
        g.panel.barGauge.new('Shards up')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.overview.shardUp.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Up/down status for each shard in the cluster.')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withValue(0) + g.panel.barGauge.standardOptions.threshold.step.withColor('red'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(1) + g.panel.barGauge.standardOptions.threshold.step.withColor('green'),
        ])
        + g.panel.barGauge.options.withDisplayMode('basic')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withShowUnfilled(true),

      // Overview panels - Cluster metrics
      overviewClusterTotalRequestsPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Cluster total requests',
          targets=[signals.overview.clusterTotalRequests.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Total requests handled by endpoints aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewClusterTotalMemoryUsedPanel:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Cluster total memory used',
          targets=[signals.overview.clusterTotalMemoryUsed.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Total memory used by each database in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      overviewClusterTotalConnectionsPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Cluster total connections',
          targets=[signals.overview.clusterTotalConnections.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Total connections to each database in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewClusterTotalKeysPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster total keys',
          targets=[signals.overview.clusterTotalKeys.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Total cluster key count for each database in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewClusterCacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster cache hit ratio',
          targets=[signals.overview.clusterCacheHitRatio.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Ratio of database cache key hits against hits and misses.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      overviewClusterEvictionsVsExpiredObjectsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster evictions vs expired objects',
          targets=[
            signals.overview.clusterEvictedObjects.asTarget(),
            signals.overview.clusterExpiredObjects.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Sum of key evictions and expirations in the cluster by database.')
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      // Overview panels - Node KPIs
      overviewNodeRequestsPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Node requests',
          targets=[signals.overview.nodeRequests.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Endpoint request rate for each node in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      overviewNodeAverageLatencyPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Node average latency',
          targets=[signals.overview.nodeAverageLatency.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average latency for each node in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      overviewNodeMemoryUtilizationPanel:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Node memory utilization',
          targets=[signals.overview.nodeMemoryUtilization.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Memory utilization % for each node in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      overviewNodeCPUUtilizationPanel:
        commonlib.panels.cpu.timeSeries.base.new(
          'Node CPU utilization',
          targets=[
            signals.overview.nodeCPUSystem.asTarget(),
            signals.overview.nodeCPUUser.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('CPU utilization for each node in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      // Overview panels - Database KPIs
      overviewDatabaseOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database operations',
          targets=[signals.overview.databaseOperations.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Rate of requests handled by each database in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      overviewDatabaseAverageLatencyPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Database average latency',
          targets=[signals.overview.databaseAverageLatency.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average latency for each database in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      overviewDatabaseMemoryUtilizationPanel:
        commonlib.panels.memory.timeSeries.base.new(
          'Database memory utilization',
          targets=[signals.overview.databaseMemoryUtilization.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Calculated memory utilization % for each database in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      overviewDatabaseCacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database cache hit ratio',
          targets=[signals.overview.databaseCacheHitRatio.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Calculated cache hit rate for each database in the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      // Nodes dashboard panels
      nodesNodeUpPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Nodes up',
          targets=[signals.nodes.nodeUp.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Displays up/down status for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      nodesDatabaseUpPanel:
        g.panel.barGauge.new('Database up')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.nodes.databaseUp.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Displays up/down status for the databases of the selected node(s).')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withValue(null) + g.panel.barGauge.standardOptions.threshold.step.withColor('transparent'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(0) + g.panel.barGauge.standardOptions.threshold.step.withColor('red'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(1) + g.panel.barGauge.standardOptions.threshold.step.withColor('green'),
        ])
        + g.panel.barGauge.options.withDisplayMode('basic')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withShowUnfilled(true),

      nodesShardsUpPanel:
        g.panel.barGauge.new('Shards up')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.nodes.shardUp.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Displays up/down status for the shards on the selected node.')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withValue(null) + g.panel.barGauge.standardOptions.threshold.step.withColor('transparent'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(0) + g.panel.barGauge.standardOptions.threshold.step.withColor('red'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(1) + g.panel.barGauge.standardOptions.threshold.step.withColor('green'),
        ])
        + g.panel.barGauge.options.withDisplayMode('basic')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withShowUnfilled(true),

      nodesNodeRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Node requests',
          targets=[signals.nodes.nodeRequests.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Total endpoint request rate for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      nodesNodeAverageLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Node average latency',
          targets=[signals.nodes.nodeAverageLatency.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average latency for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      nodesNodeMemoryUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Node memory utilization',
          targets=[signals.nodes.nodeMemoryUtilization.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Memory utilization % for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      nodesNodeCPUUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Node CPU utilization',
          targets=[
            signals.nodes.nodeCPUSystem.asTarget(),
            signals.nodes.nodeCPUUser.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('CPU utilization for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      nodesNodeEphmeralFreeStoragePanel:
        commonlib.panels.disk.timeSeries.base.new(
          'Node ephemeral free storage',
          targets=[signals.nodes.nodeEphmeralFreeStorage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Ephemeral storage available for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      nodesNodePersistentFreeStoragePanel:
        commonlib.panels.disk.timeSeries.base.new(
          'Node persistent free storage',
          targets=[signals.nodes.nodePersistentFreeStorage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Persistent storage available for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      nodesNodeNetworkIngressPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Node network ingress',
          targets=[signals.nodes.nodeNetworkIngress.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Network ingress for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('binBps'),

      nodesNodeNetworkEgressPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Node network egress',
          targets=[signals.nodes.nodeNetworkEgress.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Network egress for the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('binBps'),

      nodesNodeClientConnectionsPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Node client connections',
          targets=[signals.nodes.nodeClientConnections.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of client connections to the selected node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),


      // Database dashboard panels
      databasesDatabaseUpPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database up',
          targets=[signals.databases.databaseUp.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Displays up/down status for the selected database.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      databasesShardsUpPanel:
        g.panel.barGauge.new('Shards up')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.databases.shardUp.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Displays up/down status for each shard related to the database.')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.withMax(1)
        + g.panel.barGauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withValue(null) + g.panel.barGauge.standardOptions.threshold.step.withColor('green'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(0) + g.panel.barGauge.standardOptions.threshold.step.withColor('red'),
          g.panel.barGauge.standardOptions.threshold.step.withValue(1) + g.panel.barGauge.standardOptions.threshold.step.withColor('green'),
        ])
        + g.panel.barGauge.options.withDisplayMode('basic')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withShowUnfilled(true),

      databasesNodesUpPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Nodes up',
          targets=[signals.databases.nodeUp.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Displays up/down status for each node related to the database.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      databasesDatabaseOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database operations',
          targets=[
            signals.databases.databaseReadRequests.asTarget(),
            signals.databases.databaseWriteRequests.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Rate of read and write requests.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      databasesDatabaseLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database latency',
          targets=[
            signals.databases.databaseReadLatency.asTarget(),
            signals.databases.databaseWriteLatency.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average latency for read and write requests.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      databasesDatabaseKeysPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database key count',
          targets=[signals.databases.databaseKeys.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of keys in the database.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      databasesDatabaseCacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database cache hit ratio',
          targets=[signals.databases.databaseCacheHitRatio.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Calculated cache hit rate for the database.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      databasesDatabaseEvictionsVsExpiredObjectsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database evictions vs expired objects',
          targets=[
            signals.databases.databaseEvictedObjects.asTarget(),
            signals.databases.databaseExpiredObjects.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of evicted and expired objects from the database.')
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      databasesDatabaseMemoryUtilizationPanel:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Database memory utilization',
          targets=[signals.databases.databaseMemoryUtilization.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Calculated memory utilization % of the database compared to the limit.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      databasesDatabaseMemoryFragmentationRatioPanel:
        commonlib.panels.memory.timeSeries.base.new(
          'Database memory fragmentation ratio',
          targets=[signals.databases.databaseMemoryFragmentationRatio.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('RAM fragmentation ratio between RSS and allocated RAM.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      databasesDatabaseLUAHeapSizePanel:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Database LUA heap size',
          targets=[signals.databases.databaseLUAHeapSize.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('LUA scripting heap size.')
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      databasesDatabaseNetworkIngressPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Database network ingress',
          targets=[signals.databases.databaseNetworkIngress.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Rate of incoming network traffic.')
        + g.panel.timeSeries.standardOptions.withUnit('binBps'),

      databasesDatabaseNetworkEgressPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Database network egress',
          targets=[signals.databases.databaseNetworkEgress.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Rate of outgoing network traffic.')
        + g.panel.timeSeries.standardOptions.withUnit('binBps'),

      databasesDatabaseConnectionsPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Database connections',
          targets=[signals.databases.databaseConnections.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of client connections.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      databasesSyncStatusPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Sync status',
          targets=[signals.databases.syncStatus.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Sync status for CRDB traffic (0=in-sync, 1=syncing, 2=out of sync).')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      databasesLocalLagPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Local lag',
          targets=[signals.databases.localLag.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Lag between source and destination for CRDB traffic.')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      databasesCRDBIngressCompressedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'CRDB ingress compressed',
          targets=[signals.databases.crdbIngressCompressed.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Rate of compressed network traffic to the CRDB.')
        + g.panel.timeSeries.standardOptions.withUnit('binBps'),

      databasesCRDBIngressDecompressedPanel:
        commonlib.panels.network.timeSeries.base.new(
          'CRDB ingress decompressed',
          targets=[signals.databases.crdbIngressDecompressed.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Rate of decompressed network traffic to the CRDB.')
        + g.panel.timeSeries.standardOptions.withUnit('binBps'),
    },
}
