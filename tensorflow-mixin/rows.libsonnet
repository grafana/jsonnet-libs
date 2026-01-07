local g = import './g.libsonnet';
local panels = import './panels.libsonnet';

{
  new(panels): {
    tensorflowOverview:
      [
        g.panel.row.new('Overview') + g.panel.row.withCollapsed(false) + g.panel.row.withPanels([
          panels.serving_modelRequestRatePanel { gridPos+: { w: 24 } },
          panels.serving_modelPredictRequestLatencyPanel { gridPos+: { w: 12 } },
          panels.serving_modelPredictRuntimeLatencyPanel { gridPos+: { w: 12 } },
        ]),
      ],
    tensorflowServingOverview:
      [
        g.panel.row.new('Serving overview') + g.panel.row.withCollapsed(false) + g.panel.row.withPanels([
          panels.core_graphBuildCallsPanel { gridPos+: { w: 12 } },
          panels.core_graphRunsPanel { gridPos+: { w: 12 } },
          panels.core_graphBuildTimePanel { gridPos+: { w: 12 } },
          panels.core_graphRunTimePanel { gridPos+: { w: 12 } },
          panels.serving_batchQueuingLatencyPanel { gridPos+: { w: 12 } },
          panels.serving_batchQueueThroughputPanel { gridPos+: { w: 12 } },
        ]),
      ],
  },
}
