local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    // discourse-overview rows
    overviewRow:
      g.panel.row.new('Overview')
      + g.panel.row.withPanels([
        panels.trafficByResponseCode { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.activeRequests { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
        panels.queuedRequests { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
        panels.pageViews { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
      ]),

    latencyRow:
      g.panel.row.new('Latency')
      + g.panel.row.withPanels([
        panels.latestMedianRequestTime { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.topicMedianRequestTime { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
        panels.latest99thPercentileRequestTime { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
        panels.topic99thPercentileRequestTime { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
      ]),

    // discourse-jobs rows
    jobStatsRow:
      g.panel.row.new('Job Statistics')
      + g.panel.row.withPanels([
        panels.sidekiqWorkers { gridPos: { h: 5, w: 8, x: 0, y: 0 } },
        panels.webWorkers { gridPos: { h: 5, w: 8, x: 8, y: 0 } },
        panels.sidekiqQueued { gridPos: { h: 5, w: 8, x: 16, y: 0 } },
      ]),

    jobCountsRow:
      g.panel.row.new('Job Counts')
      + g.panel.row.withPanels([
        panels.scheduledJobCount { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.sidekiqJobCount { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),

    jobDurationRow:
      g.panel.row.new('Job Duration')
      + g.panel.row.withPanels([
        panels.scheduledJobDuration { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.sidekiqJobDuration { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),

    memoryRow:
      g.panel.row.new('Memory')
      + g.panel.row.withPanels([
        panels.usedRSSMemory { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
        panels.v8HeapSize { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
      ]),
  },
}
