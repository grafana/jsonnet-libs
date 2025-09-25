local g = import './g.libsonnet';

{
  new(this): {
    overviewRow:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.userSessionsPanel { gridPos+: { w: 8 } },
        this.grafana.panels.avgRequestLatencyPanel { gridPos+: { w: 8 } },
        this.grafana.panels.topRequestsPanel { gridPos+: { w: 8 } },
        this.grafana.panels.trafficByResponseCodePanel { gridPos+: { w: 24 } },
      ]),

    pipelineActivityRow:
      g.panel.row.new('Pipeline Activity')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.jobActivationsPanel { gridPos+: { w: 24 } },
        this.grafana.panels.pipelinesCreatedPanel { gridPos+: { w: 12 } },
        this.grafana.panels.pipelineBuildsCreatedPanel { gridPos+: { w: 12 } },
        this.grafana.panels.buildTraceOperationsPanel { gridPos+: { w: 24 } },
      ]),
  },
}
