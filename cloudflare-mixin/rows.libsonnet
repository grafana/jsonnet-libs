local g = import './g.libsonnet';

{
  new(this): {
    // Zone overview main metrics
    zoneOverview:
      g.panel.row.new('Zone overview')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.alertsPanel + g.panel.table.gridPos.withW(12) + g.panel.table.gridPos.withH(8),
          this.grafana.panels.poolStatusPanel + g.panel.table.gridPos.withW(12) + g.panel.table.gridPos.withH(8),
          this.grafana.panels.requestsPanel + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.bandwidthPanel + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.cachedRequestsPanel + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.threatsPanel + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.sslBandwidthPanel + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.bandwidthContentTypePanel + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.browserMapPanel + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.uniqueVisitorsPanel + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.requestsStatusPanel + g.panel.timeSeries.gridPos.withW(24) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.colocationRequestsPanel + g.panel.table.gridPos.withW(24) + g.panel.table.gridPos.withH(8),
        ]
      ),

    // Worker metrics
    workers:
      g.panel.row.new('Workers')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.workerCpuTimePanel + g.panel.timeSeries.gridPos.withW(24) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.workerDurationPanel + g.panel.timeSeries.gridPos.withW(24) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.workerRequestsPanel + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
          this.grafana.panels.workerErrorsPanel + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
        ]
      ),
  },
}
