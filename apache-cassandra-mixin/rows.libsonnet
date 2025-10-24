local g = import './g.libsonnet';

{
  new(this):
    {
      local panels = this.grafana.panels,
      overviewRow:
        g.panel.row.new('Overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.overviewNumberClustersPanel { gridPos+: { w: 6 } },
          panels.overviewNumberOfNodesPanel { gridPos+: { w: 6 } },
          panels.overviewNumberOfDownNodesPanel { gridPos+: { w: 6 } },
          panels.overviewTotalDiskUsagePanel { gridPos+: { w: 6 } },
          panels.overviewConnectionTimeoutsPanel { gridPos+: { w: 12 } },
          panels.overviewAverageKeyCacheHitRatioPanel { gridPos+: { w: 12 } },
          panels.overviewTasksPanel { gridPos+: { w: 12 } },
          panels.overviewDiskUsagePanel { gridPos+: { w: 12 } },
          panels.overviewWritesPanel { gridPos+: { w: 12 } },
          panels.overviewReadsPanel { gridPos+: { w: 12 } },
          panels.overviewWriteAverageLatencyPanel { gridPos+: { w: 12 } },
          panels.overviewReadAverageLatencyPanel { gridPos+: { w: 12 } },
          panels.overviewWriteLatencyHeatmapPanel { gridPos+: { w: 12 } },
          panels.overviewReadLatencyHeatmapPanel { gridPos+: { w: 12 } },
          panels.overviewWriteLatencyQuartilesPanel { gridPos+: { w: 12 } },
          panels.overviewReadLatencyQuartilesPanel { gridPos+: { w: 12 } },
        ]),

      overviewClientRequestsRow:
        g.panel.row.new('Client requests')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.overviewWriteRequestsPanel { gridPos+: { w: 8 } },
          panels.overviewWriteRequestsTimedOutPanel { gridPos+: { w: 8 } },
          panels.overviewWriteRequestsUnavailablePanel { gridPos+: { w: 8 } },
          panels.overviewReadRequestsPanel { gridPos+: { w: 8 } },
          panels.overviewReadRequestsTimedOutPanel { gridPos+: { w: 8 } },
          panels.overviewReadRequestsUnavailablePanel { gridPos+: { w: 8 } },
        ]),

      // Nodes dashboard rows
      nodesRow:
        g.panel.row.new('Nodes')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.nodesDiskUsagePanel { gridPos+: { w: 8 } },
          panels.nodesMemoryUsagePanel { gridPos+: { w: 8 } },
          panels.nodesCpuUsagePanel { gridPos+: { w: 8 } },
          panels.nodesGarbageCollectionDurationPanel { gridPos+: { w: 12 } },
          panels.nodesGarbageCollectionsPanel { gridPos+: { w: 12 } },
          panels.nodesKeycacheHitRatePanel { gridPos+: { w: 6 } },
          panels.nodesHintMessagesPanel { gridPos+: { w: 6 } },
          panels.nodesPendingCompactionTasksPanel { gridPos+: { w: 6 } },
          panels.nodesBlockedCompactionTasksPanel { gridPos+: { w: 6 } },
          panels.nodesWritesPanel { gridPos+: { w: 12 } },
          panels.nodesReadsPanel { gridPos+: { w: 12 } },
          panels.nodesWriteAverageLatencyPanel { gridPos+: { w: 12 } },
          panels.nodesReadAverageLatencyPanel { gridPos+: { w: 12 } },
          panels.nodesWriteLatencyQuartilesPanel { gridPos+: { w: 8 } },
          panels.nodesReadLatencyQuartilesPanel { gridPos+: { w: 8 } },
          panels.nodesCrossnodeLatencyPanel { gridPos+: { w: 8 } },
        ]),

      // Keyspaces dashboard rows
      keyspacesRow:
        g.panel.row.new('Keyspaces')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.keyspacesCountPanel { gridPos+: { w: 12 } },
          panels.keyspacesTotalDiskSpaceUsedPanel { gridPos+: { w: 12 } },
          panels.keyspacesPendingCompactionsPanel { gridPos+: { w: 12 } },
          panels.keyspacesMaxPartitionSizePanel { gridPos+: { w: 12 } },
          panels.keyspacesWritesPanel { gridPos+: { w: 12 } },
          panels.keyspacesReadsPanel { gridPos+: { w: 12 } },
          panels.keyspacesRepairJobsStartedPanel { gridPos+: { w: 12 } },
          panels.keyspacesRepairJobsCompletedPanel { gridPos+: { w: 12 } },
          panels.keyspacesWriteLatencyPanel { gridPos+: { w: 12 } },
          panels.keyspacesReadLatencyPanel { gridPos+: { w: 12 } },
        ]),

    },
}
