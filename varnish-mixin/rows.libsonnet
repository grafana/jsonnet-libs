local g = import './g.libsonnet';

{
  new(this):
    {
      varnishOverview:
        g.panel.row.new('Overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.backendConnectionsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.sessionsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.requestsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.cacheHitRatioPanel { gridPos+: { w: 12 } },
          this.grafana.panels.memoryUsedPanel { gridPos+: { w: 12 } },
          this.grafana.panels.cacheEventsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.networkPanel { gridPos+: { w: 12 } },
          this.grafana.panels.threadsPanel { gridPos+: { w: 12 } },
        ]),

     varnishStats: 
      g.panel.row.new('Stats')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
          this.grafana.panels.cacheHitRatePanel { gridPos+: { w: 3, h: 4 } },
          this.grafana.panels.frontendRequestsPanel { gridPos+: { w: 3, h: 4 } },
          this.grafana.panels.backendRequestsPanel { gridPos+: { w: 3, h: 4 } },
          this.grafana.panels.sessionsRatePanel { gridPos+: { w: 3, h: 4 } },
          this.grafana.panels.cacheHitsPanel { gridPos+: { w: 3, h: 4 } },
          this.grafana.panels.cacheHitPassPanel { gridPos+: { w: 3, h: 4 } },
          this.grafana.panels.sessionQueueLengthPanel { gridPos+: { w: 3, h: 4 } },
          this.grafana.panels.poolsPanel { gridPos+: { w: 3, h: 4 } },
      ]),
    },
}
