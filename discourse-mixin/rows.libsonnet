local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    // discourse-overview rows
    overviewRow:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.trafficByResponseCode { gridPos: { h: 6, w: 12 } },
        panels.activeRequests { gridPos: { h: 6, w: 12 } },
        panels.queuedRequests { gridPos: { h: 6, w: 12 } },
        panels.pageViews { gridPos: { h: 6, w: 12 } },
      ]),

    latencyRow:
      g.panel.row.new('Latency')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.latestMedianRequestTime { gridPos: { h: 6, w: 12 } },
        panels.topicMedianRequestTime { gridPos: { h: 6, w: 12 } },
        panels.latest99thPercentileRequestTime { gridPos: { h: 6, w: 12 } },
        panels.topic99thPercentileRequestTime { gridPos: { h: 6, w: 12 } },
      ]),

    // discourse-jobs rows
    jobStatsRow:
      g.panel.row.new('Job statistics')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.sidekiqWorkers { gridPos: { h: 5, w: 8 } },
        panels.webWorkers { gridPos: { h: 5, w: 8 } },
        panels.sidekiqQueued { gridPos: { h: 5, w: 8 } },
      ]),

    jobCountsRow:
      g.panel.row.new('Job counts')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.scheduledJobCount { gridPos: { h: 6, w: 12 } },
        panels.sidekiqJobCount { gridPos: { h: 6, w: 12 } },
      ]),

    jobDurationRow:
      g.panel.row.new('Duration')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.scheduledJobDuration { gridPos: { h: 6, w: 12 } },
        panels.sidekiqJobDuration { gridPos: { h: 6, w: 12 } },
      ]),

    memoryRow:
      g.panel.row.new('Memory')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.usedRSSMemory { gridPos: { h: 6, w: 12 } },
        panels.v8HeapSize { gridPos: { h: 6, w: 12 } },
      ]),
  },
}
