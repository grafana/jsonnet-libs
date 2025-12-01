local g = import './g.libsonnet';

{
  new(this):
    {
      local panels = this.grafana.panels,

      // Overview dashboard rows
      overviewRow:
        g.panel.row.new('Overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.overviewNodesUpPanel { gridPos+: { w: 8, h: 6 } },
          panels.overviewDatabasesUpPanel { gridPos+: { w: 8, h: 6 } },
          panels.overviewShardsUpPanel { gridPos+: { w: 8, h: 6 } },
          panels.overviewClusterTotalMemoryUsedPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewClusterTotalConnectionsPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewClusterTotalRequestsPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewClusterTotalKeysPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewClusterCacheHitRatioPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewClusterEvictionsVsExpiredObjectsPanel { gridPos+: { w: 12, h: 6 } },
        ]),

      overviewNodesKPIsRow:
        g.panel.row.new('Nodes KPIs')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.overviewNodeRequestsPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewNodeAverageLatencyPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewNodeMemoryUtilizationPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewNodeCPUUtilizationPanel { gridPos+: { w: 12, h: 6 } },
        ]),

      overviewDatabaseKPIsRow:
        g.panel.row.new('Database KPIs')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.overviewDatabaseOperationsPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewDatabaseAverageLatencyPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewDatabaseMemoryUtilizationPanel { gridPos+: { w: 12, h: 6 } },
          panels.overviewDatabaseCacheHitRatioPanel { gridPos+: { w: 12, h: 6 } },
        ]),

      // Nodes dashboard rows
      nodesOverviewRow:
        g.panel.row.new('Node overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.nodesNodeUpPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesDatabaseUpPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesShardsUpPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesInventoryPanel { gridPos+: { w: 24 } },
        ]),

      nodesMetricsRow:
        g.panel.row.new('Node metrics')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.nodesNodeRequestsPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesNodeAverageLatencyPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesNodeCPUUtilizationPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesNodeMemoryUtilizationPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesNodeEphmeralFreeStoragePanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesNodePersistentFreeStoragePanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesNodeNetworkIngressPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesNodeNetworkEgressPanel { gridPos+: { w: 8, h: 6 } },
          panels.nodesNodeClientConnectionsPanel { gridPos+: { w: 8, h: 6 } },
        ]),

      // Database dashboard rows
      databasesOverviewRow:
        g.panel.row.new('Database overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.databasesDatabaseUpPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesShardsUpPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesNodesUpPanel { gridPos+: { w: 8, h: 6 } },
        ]),

      databasesMetricsRow:
        g.panel.row.new('Database metrics')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.databasesDatabaseOperationsPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesDatabaseLatencyPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesDatabaseConnectionsPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesDatabaseKeysPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesDatabaseCacheHitRatioPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesDatabaseMemoryUtilizationPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesDatabaseEvictionsVsExpiredObjectsPanel { gridPos+: { w: 12, h: 6 } },
          panels.databasesDatabaseMemoryFragmentationRatioPanel { gridPos+: { w: 12, h: 6 } },
          panels.databasesDatabaseLUAHeapSizePanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesDatabaseNetworkIngressPanel { gridPos+: { w: 8, h: 6 } },
          panels.databasesDatabaseNetworkEgressPanel { gridPos+: { w: 8, h: 6 } },
        ]),

      databasesCRDBRow:
        g.panel.row.new('Active-Active')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.databasesSyncStatusPanel { gridPos+: { w: 6, h: 6 } },
          panels.databasesLocalLagPanel { gridPos+: { w: 6, h: 6 } },
          panels.databasesCRDBIngressCompressedPanel { gridPos+: { w: 6, h: 6 } },
          panels.databasesCRDBIngressDecompressedPanel { gridPos+: { w: 6, h: 6 } },
        ]),
    },
}
