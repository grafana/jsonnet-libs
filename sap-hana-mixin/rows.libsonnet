local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    // System overview rows
    systemReplication:
      g.panel.row.new('System replication')
      + g.panel.row.withPanels([
        panels.replicaStatus { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
        panels.averageReplicationShipDelay { gridPos: { h: 6, w: 16, x: 8, y: 0 } },
      ]),

    systemResources:
      g.panel.row.new('System resources')
      + g.panel.row.withPanels([
        panels.cpuUsage { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.diskUsage { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
        panels.physicalMemoryUsage { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
        panels.sapHanaMemoryUsage { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
        panels.memoryAllocationLimit { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
        panels.schemaMemoryUsage { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
      ]),

    systemNetwork:
      g.panel.row.new('Network I/O')
      + g.panel.row.withPanels([
        panels.networkIOThroughput { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.networkIOThroughputByInterface { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),

    systemDisk:
      g.panel.row.new('Disk I/O')
      + g.panel.row.withPanels([
        panels.diskIOThroughput { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.diskIOThroughputByDisk { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),

    systemSQL:
      g.panel.row.new('SQL performance')
      + g.panel.row.withPanels([
        panels.avgSqlExecutionTime { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.sqlLockTime { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
        panels.sqlTopTimeConsumers { gridPos: { h: 6, w: 24, x: 0, y: 6 } },
      ]),

    systemConnections:
      g.panel.row.new('Connections')
      + g.panel.row.withPanels([
        panels.totalConnections { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
        panels.connectionsByType { gridPos: { h: 6, w: 16, x: 8, y: 0 } },
      ]),

    systemStorage:
      g.panel.row.new('Storage')
      + g.panel.row.withPanels([
        panels.topTableMemory { gridPos: { h: 6, w: 24, x: 0, y: 0 } },
      ]),

    systemAlerts:
      g.panel.row.new('System alerts')
      + g.panel.row.withPanels([
        panels.currentAlerts { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
        panels.alertsDetail { gridPos: { h: 6, w: 16, x: 8, y: 0 } },
      ]),

    // Instance overview rows (similar structure but may have different panels)
    instanceOverview:
      g.panel.row.new('Instance overview')
      + g.panel.row.withPanels([
        panels.cpuUsage { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.diskUsage { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),

    instanceMemory:
      g.panel.row.new('Memory')
      + g.panel.row.withPanels([
        panels.physicalMemoryUsage { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.sapHanaMemoryUsage { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),

    instanceNetwork:
      g.panel.row.new('Network')
      + g.panel.row.withPanels([
        panels.networkIOThroughput { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.networkIOThroughputByInterface { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),

    instanceSQL:
      g.panel.row.new('SQL')
      + g.panel.row.withPanels([
        panels.avgSqlExecutionTime { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.sqlLockTime { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),
  },
}
