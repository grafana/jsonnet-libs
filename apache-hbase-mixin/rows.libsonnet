local g = import './g.libsonnet';

{
  new(this):
    {
      local panels = this.grafana.panels,

      // ==========================
      // Cluster Overview Dashboard
      // ==========================

      clusterOverview:
        g.panel.row.new('Cluster overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.masterStatusHistoryPanel { gridPos+: { w: 24 } },
          panels.liveRegionServersPanel { gridPos+: { w: 5 } },
          panels.deadRegionServersPanel { gridPos+: { w: 5 } },
          panels.serversPanel { gridPos+: { w: 14 } },
          panels.alertsPanel { gridPos+: { w: 12 } },
          panels.jvmHeapMemoryUsagePanel { gridPos+: { w: 12 } },
          panels.connectionsPanel { gridPos+: { w: 12 } },
          panels.authenticationsPanel { gridPos+: { w: 12 } },
          panels.masterQueueSizePanel { gridPos+: { w: 12 } },
          panels.masterQueuedCallsPanel { gridPos+: { w: 12 } },
          panels.regionsInTransitionPanel { gridPos+: { w: 12 } },
          panels.oldestRegionInTransitionPanel { gridPos+: { w: 12 } },
        ]),

      // ==========================
      // RegionServer Overview Dashboard
      // ==========================

      regionServerOverview:
        g.panel.row.new('RegionServer overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.regionsPanel { gridPos+: { w: 3 } },
          panels.storeFilesPanel { gridPos+: { w: 3 } },
          panels.storeFileSizePanel { gridPos+: { w: 3 } },
          panels.rpcConnectionsPanel { gridPos+: { w: 3 } },
          panels.regionServerJvmHeapMemoryUsagePanel { gridPos+: { w: 12 } },
          panels.requestsReceivedPanel { gridPos+: { w: 16 } },
          panels.requestsOverviewPanel { gridPos+: { w: 8 } },
          panels.regionCountPanel { gridPos+: { w: 12 } },
          panels.rpcConnectionCountPanel { gridPos+: { w: 12 } },
          panels.storeFileCountPanel { gridPos+: { w: 12 } },
          panels.storeFileSizeTimeseriesPanel { gridPos+: { w: 12 } },
          panels.queuedCallsPanel { gridPos+: { w: 12 } },
          panels.slowOperationsPanel { gridPos+: { w: 12 } },
          panels.cacheHitPercentagePanel { gridPos+: { w: 12 } },
          panels.regionServerAuthenticationsPanel { gridPos+: { w: 12 } },
        ]),
    },
}
