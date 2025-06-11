local g = import './g.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(this): {
    database:
      [
        g.panel.row.new('Database'),
        this.grafana.panels.databaseWriteStallDurationPanel
        + g.panel.timeSeries.gridPos.withW(12),
        this.grafana.panels.databaseReadStallDurationPanel
        + g.panel.timeSeries.gridPos.withW(12),
        this.grafana.panels.transactionLogExpansionsPanel
        + g.panel.timeSeries.gridPos.withW(24),
      ],
  },
}
