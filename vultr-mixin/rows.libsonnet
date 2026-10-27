local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.instanceCountStat { gridPos+: { h: 6, w: 6 } },
        panels.bandwidthUsageStat { gridPos+: { h: 6, w: 18 } },
        panels.instanceList { gridPos+: { h: 12, w: 24 } },
      ]),

    compute:
      g.panel.row.new('Compute')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.cpuUsage { gridPos+: { h: 8, w: 12 } },
        panels.diskOperations { gridPos+: { h: 8, w: 12 } },
      ]),

    network:
      g.panel.row.new('Network')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.networkTraffic { gridPos+: { h: 8, w: 12 } },
        panels.bandwidthUsed { gridPos+: { h: 8, w: 12 } },
      ]),

    gpu:
      g.panel.row.new('GPU')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels([
        panels.gpuUtilization { gridPos+: { h: 8, w: 12 } },
        panels.gpuMemoryUsed { gridPos+: { h: 8, w: 12 } },
        panels.gpuTemperature { gridPos+: { h: 8, w: 12 } },
        panels.gpuPower { gridPos+: { h: 8, w: 12 } },
      ]),
  },
}
