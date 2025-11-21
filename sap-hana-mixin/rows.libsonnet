local g = import './g.libsonnet';

{
  new(this):: {
    local panels = this.grafana.panels,

    // System overview dashboard rows
    systemReplicationRow:
      g.panel.row.new('Replication')
      + g.panel.row.withPanels([
        panels.systemReplicaStatusPanel { gridPos: { h: 6, w: 9, x: 0, y: 0 } },
        panels.systemReplicationShipDelayPanel { gridPos: { h: 6, w: 15, x: 9, y: 0 } },
      ]),

    systemResourcesRow:
      g.panel.row.new('Resources')
      + g.panel.row.withPanels([
        panels.systemCpuUsagePanel { gridPos: { h: 6, w: 12, x: 0, y: 1 } },
        panels.systemDiskUsagePanel { gridPos: { h: 6, w: 12, x: 12, y: 1 } },
        panels.systemPhysicalMemoryUsagePanel { gridPos: { h: 6, w: 12, x: 0, y: 7 } },
        panels.systemHanaMemoryUsagePanel { gridPos: { h: 6, w: 12, x: 12, y: 7 } },
      ]),

    systemIORow:
      g.panel.row.new('I/O')
      + g.panel.row.withPanels([
        panels.systemNetworkIOThroughputPanel { gridPos: { h: 6, w: 12, x: 0, y: 13 } },
        panels.systemDiskIOThroughputPanel { gridPos: { h: 6, w: 12, x: 12, y: 13 } },
      ]),

    systemPerformanceRow:
      g.panel.row.new('Performance')
      + g.panel.row.withPanels([
        panels.systemAvgQueryExecutionTimePanel { gridPos: { h: 6, w: 12, x: 0, y: 19 } },
        panels.systemActiveConnectionsPanel { gridPos: { h: 6, w: 6, x: 12, y: 19 } },
        panels.systemIdleConnectionsPanel { gridPos: { h: 6, w: 6, x: 18, y: 19 } },
      ]),

    systemAlertsRow:
      g.panel.row.new('Alerts')
      + g.panel.row.withPanels([
        panels.systemAlertsPanel { gridPos: { w: 6 } },
        panels.systemRecentAlertsPanel { gridPos: { w: 18 } },
      ]),

    // Instance overview dashboard rows
    instanceResourcesRow:
      g.panel.row.new('Resources')
      + g.panel.row.withPanels([
        panels.instanceCpuUsagePanel { gridPos: { w: 12 } },
        panels.instanceDiskUsagePanel { gridPos: { w: 12 } },
        panels.instancePhysicalMemoryUsagePanel { gridPos: { w: 12 } },
        panels.instanceSchemaMemoryUsagePanel { gridPos: { w: 12 } },
      ]),

    instanceIORow:
      g.panel.row.new('I/O')
      + g.panel.row.withPanels([
        panels.instanceNetworkIOThroughputPanel { gridPos: { w: 12 } },
        panels.instanceDiskIOThroughputPanel { gridPos: { w: 12 } },
      ]),

    instancePerformanceRow:
      g.panel.row.new('Performance')
      + g.panel.row.withPanels([
        panels.instanceConnectionsPanel { gridPos: { w: 8 } },
        panels.instanceAvgQueryExecutionTimePanel { gridPos: { w: 8 } },
        panels.instanceAvgLockWaitTimePanel { gridPos: { w: 8 } },
      ]),

    instanceAlertsRow:
      g.panel.row.new('Alerts')
      + g.panel.row.withPanels([
        panels.instanceAlertsPanel { gridPos: { w: 7 } },
        panels.instanceRecentAlertsPanel { gridPos: { w: 17 } },
      ]),

    instanceOutliersRow:
      g.panel.row.new('Outliers')
      + g.panel.row.withPanels([
        panels.instanceTopTablesByMemoryPanel { gridPos: { w: 12 } },
        panels.instanceTopSQLByTimePanel { gridPos: { w: 12 } },
      ]),
  },
}
