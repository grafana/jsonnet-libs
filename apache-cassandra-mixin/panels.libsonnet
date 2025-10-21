local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // Cassandra overview panels
      overviewNumberClustersPanel:
        g.panel.stat.new('Number of clusters')
        + g.panel.stat.queryOptions.withTargets([
          signals.overview.clusterCount.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('The number of unique jobs being reported.')
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      overviewNumberOfNodesPanel:
        g.panel.stat.new('Number of nodes')
        + g.panel.stat.queryOptions.withTargets([
          signals.overview.nodeCount.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('Number of down nodes in the cluster.')
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),


      overviewNumberOfDownNodesPanel:
        g.panel.stat.new('Number of down nodes')
        + g.panel.stat.queryOptions.withTargets([
          signals.overview.downNodeCount.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('Number of down nodes in the cluster.')
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),


      overviewConnectionTimeoutsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Connection timeouts',
          targets=[signals.overview.connectionTimeouts.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of timeouts experienced from each node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewAverageKeyCacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average key cache hit ratio',
          targets=[signals.overview.averageKeyCacheHitRatio.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The average key cache hit ratio being reported.')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      overviewWriteAverageLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Write average latency',
          targets=[signals.overview.writeAverageLatency.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average write latency for the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      overviewReadAverageLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Read average latency',
          targets=[signals.overview.readAverageLatency.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average read latency for the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      overviewTasksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Tasks',
          targets=[
            signals.overview.largeDroppedTasks.asTarget(),
            signals.overview.largeActiveTasks.asTarget(),
            signals.overview.largePendingTasks.asTarget(),
            signals.overview.smallDroppedTasks.asTarget(),
            signals.overview.smallActiveTasks.asTarget(),
            signals.overview.smallPendingTasks.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of tasks that a connection has either completed, dropped, or is pending.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      overviewTotalDiskUsagePanel:
        g.panel.stat.new('Total disk usage')
        + g.panel.stat.queryOptions.withTargets([
          signals.overview.totalDiskUsage.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('The total number of bytes being used by Apache Cassandra for storage.')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.standardOptions.withUnit('bytes')
        + g.panel.stat.options.withGraphMode('none'),

      overviewDiskUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk usage',
          targets=[signals.overview.diskUsagePanel.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of bytes used by each node of the cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      overviewWritesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Writes',
          targets=[signals.overview.writes.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of local writes aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      overviewReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Reads',
          targets=[signals.overview.reads.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of local reads aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      overviewWriteLatencyHeatmapPanel:
        g.panel.heatmap.new(
          'Write latency heatmap',
        )
        + g.panel.heatmap.queryOptions.withTargets([
          signals.overview.writeLatencyHeatmap.asTarget(),
        ])
        + g.panel.heatmap.panelOptions.withDescription('Local write latency heatmap for this cluster.')
        + g.panel.heatmap.options.withCalculate(true)
        + g.panel.heatmap.options.color.withScheme('Oranges'),

      overviewReadLatencyHeatmapPanel:
        g.panel.heatmap.new(
          'Read latency heatmap',
        )
        + g.panel.heatmap.queryOptions.withTargets([
          signals.overview.readLatencyHeatmap.asTarget(),
        ])
        + g.panel.heatmap.panelOptions.withDescription('Local read latency heatmap for this cluster.')
        + g.panel.heatmap.options.withCalculate(true)
        + g.panel.heatmap.options.color.withScheme('Oranges'),

      overviewWriteLatencyQuartilesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Write latency quartiles',
          targets=[
            signals.overview.writeLatencyQuartilesP95.asTarget(),
            signals.overview.writeLatencyQuartilesP99.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Local write latency quartiles for this cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      overviewReadLatencyQuartilesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Read latency quartiles',
          targets=[
            signals.overview.readLatencyQuartilesP95.asTarget(),
            signals.overview.readLatencyQuartilesP99.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Local read latency quartiles for this cluster.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      // Client request panels
      overviewWriteRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Write requests',
          targets=[signals.overview.writeRequests.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Rate of standard client write requests.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      overviewWriteRequestsTimedOutPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Write requests timed out',
          targets=[signals.overview.writeRequestsTimedOut.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Standard client write requests returning timed out exceptions.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      overviewWriteRequestsUnavailablePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Write requests unavailable',
          targets=[signals.overview.writeRequestsUnavailable.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Standard client write requests returning unavailable exceptions.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      overviewReadRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Read requests',
          targets=[signals.overview.readRequests.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Rate of standard client read requests.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      overviewReadRequestsTimedOutPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Read requests timed out',
          targets=[signals.overview.readRequestsTimedOut.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Standard client read requests returning timed out exceptions.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      overviewReadRequestsUnavailablePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Read requests unavailable',
          targets=[signals.overview.readRequestsUnavailable.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Standard client read requests returning unavailable exceptions.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      // Cassandra nodes panels
      nodesDiskUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk usage',
          targets=[signals.nodes.storageLoadCount.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of bytes being used by this node.')
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      nodesMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory usage',
          targets=[signals.nodes.memoryUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The JVM memory usage of this node.')
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      nodesCpuUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'CPU usage',
          targets=[signals.nodes.cpuUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The JVM CPU usage of this node.')
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      nodesGarbageCollectionDurationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Garbage collection duration',
          targets=[signals.nodes.gcDurationPanel.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The amount of time spent performing the most recent garbage collection on this node.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      nodesGarbageCollectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Garbage collections',
          targets=[signals.nodes.gcCollections.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of times garbage collection was performed on this node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      nodesKeycacheHitRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Keycache hit rate',
          targets=[signals.nodes.keycacheHitRate.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The keycache hit rate for this node.')
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      nodesHintMessagesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Hint messages',
          targets=[signals.nodes.hintMessages.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of hint messages written to this node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      nodesPendingCompactionTasksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Pending compaction tasks',
          targets=[signals.nodes.pendingCompactionTasks.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of currently pending compaction tasks on this node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      nodesBlockedCompactionTasksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Blocked compaction tasks',
          targets=[signals.nodes.blockedCompactionTasks.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of currently blocked compaction tasks on this node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      nodesWritesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Writes',
          targets=[signals.nodes.writes.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of local writes across all keyspaces for this node.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15),

      nodesReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Reads',
          targets=[signals.nodes.reads.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of local reads across all keyspaces for this node.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15),

      nodesWriteAverageLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Write average latency',
          targets=[signals.nodes.writeAverageLatency.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average write latency for the node.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15),

      nodesReadAverageLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Read average latency',
          targets=[signals.nodes.readAverageLatency.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average read latency for the node.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15),

      nodesWriteLatencyQuartilesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Write latency quartiles',
          targets=[
            signals.nodes.writeLatencyP95.asTarget(),
            signals.nodes.writeLatencyP99.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Local write latency quartiles for the nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      nodesReadLatencyQuartilesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Read latency quartiles',
          targets=[
            signals.nodes.readLatencyP95.asTarget(),
            signals.nodes.readLatencyP99.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Local read latency quartiles for the nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      nodesCrossnodeLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cross-node latency',
          targets=[
            signals.nodes.crossNodeLatencyP95.asTarget(),
            signals.nodes.crossNodeLatencyP99.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription("The cross-node latency from the node's perspective.")
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      // Cassandra keyspaces panels
      keyspacesCountPanel:
        g.panel.stat.new('Keyspaces count')
        + g.panel.stat.queryOptions.withTargets([
          signals.keyspaces.keyspacesCount.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('The total count of the amount of keyspaces being reported.')
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.options.withGraphMode('area'),

      keyspacesTotalDiskSpaceUsedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Keyspace total disk space used',
          targets=[signals.keyspaces.keyspacesTotalDiskSpaceUsed.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Total amount of disk space used by keyspaces.')
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20),

      keyspacesPendingCompactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Keyspace pending compactions',
          targets=[signals.keyspaces.keyspacesPendingCompactions.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of compaction operations a keyspace is pending to perform.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20),

      keyspacesMaxPartitionSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Keyspace max partition size',
          targets=[signals.keyspaces.keyspacesMaxPartitionSize.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Max partition size for keyspaces.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),

      keyspacesWritesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Writes',
          targets=[signals.keyspaces.writes.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of writes performed on the keyspace.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      keyspacesReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Reads',
          targets=[signals.keyspaces.reads.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of reads performed on the keyspace.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      keyspacesRepairJobsStartedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Repair jobs started',
          targets=[signals.keyspaces.repairJobsStarted.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of repair jobs started per keyspace.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      keyspacesRepairJobsCompletedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Repair jobs completed',
          targets=[signals.keyspaces.repairJobsCompleted.asTarget() { interval: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of repair jobs that were completed.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      keyspacesWriteLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Keyspace write latency',
          targets=[
            signals.keyspaces.keyspaceWriteLatencyP95.asTarget() + g.query.prometheus.withLegendFormat('{{ keyspace }} - p95'),
            signals.keyspaces.keyspaceWriteLatencyP99.asTarget() + g.query.prometheus.withLegendFormat('{{ keyspace }} - p99'),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The 95th and 99th percentils of local write latency for keyspaces.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      keyspacesReadLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Keyspace read latency',
          targets=[
            signals.keyspaces.keyspaceReadLatencyP95.asTarget() + g.query.prometheus.withLegendFormat('{{ keyspace }} - p95'),
            signals.keyspaces.keyspaceReadLatencyP99.asTarget() + g.query.prometheus.withLegendFormat('{{ keyspace }} - p99'),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average local read latency for keyspaces.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

    },
}
