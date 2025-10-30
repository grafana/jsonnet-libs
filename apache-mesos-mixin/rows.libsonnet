local g = import './g.libsonnet';

{
  new(this):
    {
      local panels = this.grafana.panels,

      masterOverview:
        g.panel.row.new('Master overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.masterUptimePanel + g.panel.timeSeries.gridPos.withW(4) + g.panel.timeSeries.gridPos.withH(6),
          panels.cpusAvailablePanel + g.panel.timeSeries.gridPos.withW(5) + g.panel.timeSeries.gridPos.withH(6),
          panels.memoryAvailablePanel + g.panel.timeSeries.gridPos.withW(5) + g.panel.timeSeries.gridPos.withH(6),
          panels.gpusAvailablePanel + g.panel.timeSeries.gridPos.withW(5) + g.panel.timeSeries.gridPos.withH(6),
          panels.diskAvailablePanel + g.panel.timeSeries.gridPos.withW(5) + g.panel.timeSeries.gridPos.withH(6),
          panels.memoryUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.diskUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.eventsInQueuePanel + g.panel.timeSeries.gridPos.withW(12),
          panels.messagesPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.registrarStatePanel + g.panel.timeSeries.gridPos.withW(18),
          panels.registrarLogRecoveredPanel + g.panel.timeSeries.gridPos.withW(6),
          panels.allocationRunsPanel + g.panel.timeSeries.gridPos.withW(6),
          panels.allocationDurationPanel + g.panel.timeSeries.gridPos.withW(6),
          panels.allocationLatencyPanel + g.panel.timeSeries.gridPos.withW(6),
          panels.eventQueueDispatchesPanel + g.panel.timeSeries.gridPos.withW(6),
        ]),
      agentOverview:
        g.panel.row.new('Agent overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.agentMemoryUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.agentDiskUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
        ]),
    },
}
