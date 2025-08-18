local g = import './g.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(this): {
    // Zone overview metrics
    zoneOverview:
      g.panel.row.new('Zone overview')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.requestsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.cachedRequestsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.threatsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.bandwidthPanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),

    // Zone bandwidth metrics
    zoneBandwidth:
      g.panel.row.new('Zone bandwidth')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.sslBandwidthPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.bandwidthContentTypePanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),

    // Zone visitors metrics
    zoneVisitors:
      g.panel.row.new('Zone visitors')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.uniqueVisitorsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.browserMapPanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),

    // Zone status and location metrics
    zoneStatusLocation:
      g.panel.row.new('Zone status and location')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.requestsStatusPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.colocationRequestsPanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),

    // Pool metrics
    pools:
      g.panel.row.new('Load balancer pools')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.poolStatusPanel + g.panel.stat.gridPos.withW(12),
          this.grafana.panels.poolRequestsPanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),

    // Worker metrics
    workers:
      g.panel.row.new('Workers')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.workerCpuTimePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.workerDurationPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.workerRequestsPanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.workerErrorsPanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),
  },
}
