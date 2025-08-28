local g = import './g.libsonnet';

{
  new(this):
    {
      local panels = this.grafana.panels,

      // Overview
      clusterOverview:
        g.panel.row.new('Overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.nodesPanel + g.panel.table.gridPos.withW(6),
          panels.namespacesPanel + g.panel.table.gridPos.withW(6),
          panels.unavailablePartitionsPanel + g.panel.stat.gridPos.withW(6),
          panels.deadPartitionsPanel + g.panel.stat.gridPos.withW(6),
          panels.topNodesByMemoryUsagePanel + g.panel.table.gridPos.withW(12),
          panels.topNodesByDiskUsagePanel + g.panel.table.gridPos.withW(6),
          panels.topNodesByDiskUsage7Panel + g.panel.table.gridPos.withW(6),
          panels.readTransactionsPanel + g.panel.stat.gridPos.withW(12),
          panels.writeTransactionsPanel + g.panel.stat.gridPos.withW(12),
          panels.udfTransactionsPanel + g.panel.stat.gridPos.withW(12),
          panels.clientConnectionsPanel + g.panel.stat.gridPos.withW(12),
        ]),

      // Instance overview
      instanceOverview:
        g.panel.row.new('Instance')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.instanceUnavailablePartitionsPanel + g.panel.stat.gridPos.withW(6),
          panels.nodeMemoryUsagePanel + g.panel.timeSeries.gridPos.withW(18),
          panels.instanceDeadPartitionsPanel + g.panel.stat.gridPos.withW(6),
          panels.instanceDiskUsagePanel + g.panel.timeSeries.gridPos.withW(9),
          panels.instanceDiskUsage7Panel + g.panel.timeSeries.gridPos.withW(9),
          panels.heapMemoryEfficiencyPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.instanceClientConnectionsPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.instanceReadTransactionsPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.instanceWriteTransactionsPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.instanceUdfTransactionsPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.cacheReadUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
        ]),

      // Namespace overview
      namespaceOverview:
        g.panel.row.new('Namespace')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.namespaceUnavailablePartitionsPanel + g.panel.stat.gridPos.withW(6),
          panels.namespaceDiskUsagePanel + g.panel.timeSeries.gridPos.withW(9),
          panels.namespaceDiskUsage7Panel + g.panel.timeSeries.gridPos.withW(9),
          panels.namespaceDeadPartitionsPanel + g.panel.stat.gridPos.withW(6),
          panels.namespaceMemoryUsagePanel + g.panel.timeSeries.gridPos.withW(9),
          panels.namespaceMemoryUsageBytesPanel + g.panel.timeSeries.gridPos.withW(9),
          panels.namespaceReadTransactionsPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.namespaceWriteTransactionsPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.namespaceUdfTransactionsPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.cacheReadUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
        ]),
    },
}
