local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.storageUsedRatio { gridPos+: { w: 6, h: 7 } },
        panels.disksTotal { gridPos+: { w: 6, h: 7 } },
        panels.disksOffline { gridPos+: { w: 6, h: 7 } },
        panels.errors { gridPos+: { w: 6, h: 7 } },
      ]),

    storage:
      g.panel.row.new('Storage')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.storageUsed { gridPos+: { w: 8, h: 7 } },
        panels.storageAvailable { gridPos+: { w: 8, h: 7 } },
        panels.storageTotal { gridPos+: { w: 8, h: 7 } },
      ]),

    buckets:
      g.panel.row.new('Buckets')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.bucketSize { gridPos+: { w: 8, h: 7 } },
        panels.bucketObjects { gridPos+: { w: 8, h: 7 } },
        panels.bucketObjectsBySize { gridPos+: { w: 8, h: 7 } },
      ]),

    requests:
      g.panel.row.new('Requests')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.readRequests { gridPos+: { w: 8, h: 7 } },
        panels.writeRequests { gridPos+: { w: 8, h: 7 } },
        panels.deleteRequests { gridPos+: { w: 8, h: 7 } },
      ]),

    performance:
      g.panel.row.new('Performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.readLatency { gridPos+: { w: 12, h: 7 } },
        panels.internodeTraffic { gridPos+: { w: 12, h: 7 } },
      ]),
  },
}
