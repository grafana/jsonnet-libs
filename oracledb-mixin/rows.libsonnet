local g = import './g.libsonnet';

{
  new(this): {
    // Database status and connection metrics
    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.databaseStatusPanel + g.panel.stat.gridPos.withW(4),
          this.grafana.panels.sessionsPanel + g.panel.timeSeries.gridPos.withW(10),
          this.grafana.panels.processesPanel + g.panel.timeSeries.gridPos.withW(10),
        ]
      ),

    // Wait time metrics
    waittimes:
      g.panel.row.new('Wait time')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.applicationWaitTimePanel + g.panel.timeSeries.gridPos.withW(6),
          this.grafana.panels.commitWaitTimePanel + g.panel.timeSeries.gridPos.withW(6),
          this.grafana.panels.concurrencyWaitTimePanel + g.panel.timeSeries.gridPos.withW(6),
          this.grafana.panels.configurationWaitTimePanel + g.panel.timeSeries.gridPos.withW(6),
          this.grafana.panels.networkWaitTimePanel + g.panel.timeSeries.gridPos.withW(6),
          this.grafana.panels.schedulerWaitTimePanel + g.panel.timeSeries.gridPos.withW(6),
          this.grafana.panels.systemIOWaitTimePanel + g.panel.timeSeries.gridPos.withW(6),
          this.grafana.panels.userIOWaitTimePanel + g.panel.timeSeries.gridPos.withW(6),
        ]
      ),

    // Tablespace metrics
    tablespace:
      g.panel.row.new('Tablespace')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.tablespaceSizePanel + g.panel.timeSeries.gridPos.withW(24),
        ]
      ),
  },
}
