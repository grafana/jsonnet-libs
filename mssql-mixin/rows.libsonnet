local g = import './g.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(this): {
    // Connection and performance metrics
    connections:
      g.panel.row.new('Overview')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.connectionsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.batchRequestsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.severeErrorsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.deadlocksPanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),

    // Memory management metrics
    memory:
      g.panel.row.new('Memory')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.osMemoryUsagePanel + g.panel.timeSeries.gridPos.withW(24),
          this.grafana.panels.memoryManagerPanel + g.panel.timeSeries.gridPos.withW(16),
          this.grafana.panels.committedMemoryUtilizationPanel + g.panel.gauge.gridPos.withW(8),
        ]
      ),

    // Pages and buffer cache metrics
    pages:
      g.panel.row.new('Pages')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.pageFileMemoryPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.bufferCacheHitPercentagePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.pageCheckpointsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.pageFaultsPanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),

    // Database I/O metrics
    database:
      g.panel.row.new('Database')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.databaseWriteStallDurationPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.databaseReadStallDurationPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.transactionLogExpansionsPanel + g.panel.timeSeries.gridPos.withW(24),
        ]
      ),
  },
}
