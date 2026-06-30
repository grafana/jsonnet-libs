local g = import './g.libsonnet';

// Panel groupings for each dashboard. Each row is a flat list of row markers and
// panels (with per-panel gridPos width overrides) consumed by
// g.util.grid.wrapPanels in dashboards.libsonnet.
{
  new(this):
    {
      local panels = this.grafana.panels,

      overview: [
        g.panel.row.new('Errors'),
        panels.topErrorsByTestName { gridPos+: { w: 16 } },
        panels.alertsPanel { gridPos+: { w: 8 } },
        g.panel.row.new('Content handling and loading'),
        panels.topAvgLoadTimeTestName,
        panels.topAvgTotalLoadTimeNodeName,
        panels.topAvgDocumentCompletionTimeTestName,
        panels.topAvgDocumentCompletionTimeNodeName,
        g.panel.row.new('Requests'),
        panels.bottomAvgRequestRatioTestName,
        panels.bottomAvgRequestSuccessRatioNodeName,
        g.panel.row.new('Connectivity'),
        panels.topAvgConnectionSetupTimeTestName,
        panels.topAvgConnectionSetupTimeNodeName,
        panels.topAvgContentLoadingTimeTestName,
        panels.topAvgContentLoadingTimeNodeName,
        panels.topAvgRedirectsTestName,
        panels.topAvgRedirectsNodeName,
      ],

      testNameOverview: [
        g.panel.row.new('Errors and content types'),
        panels.errors { gridPos+: { w: 8 } },
        panels.contentTypesLoadedBySize { gridPos+: { w: 8 } },
        panels.contentLoadedByType { gridPos+: { w: 8 } },
        g.panel.row.new('Content handling and loading'),
        panels.pageCompletionTime { gridPos+: { w: 16 } },
        panels.clientProcessing { gridPos+: { w: 8 } },
        panels.DNSResolution { gridPos+: { w: 24 } },
        panels.contentHandling { gridPos+: { w: 24 } },
        panels.additionalDelay { gridPos+: { w: 24 } },
        g.panel.row.new('Response'),
        panels.responseContentSize,
        panels.totalContentSize,
        g.panel.row.new('Network activity'),
        panels.networkConnections { gridPos+: { w: 8 } },
        panels.hostsContacted { gridPos+: { w: 8 } },
        panels.cacheAccess { gridPos+: { w: 8 } },
        g.panel.row.new('Request'),
        panels.requestSucessRatio,
        panels.redirections,
      ],

      nodeNameOverview: [
        g.panel.row.new('Errors and content types'),
        panels.errorsNodeName { gridPos+: { w: 8 } },
        panels.contentTypesLoadedBySizeNodeName { gridPos+: { w: 8 } },
        panels.contentLoadedByTypeNodeName { gridPos+: { w: 8 } },
        g.panel.row.new('Content handling and loading'),
        panels.pageCompletionTimeNodeName { gridPos+: { w: 16 } },
        panels.clientProcessingNodeName { gridPos+: { w: 8 } },
        panels.DNSResolutionNodeName { gridPos+: { w: 24 } },
        panels.contentHandlingNodeName { gridPos+: { w: 24 } },
        panels.additionalDelayNodeName { gridPos+: { w: 24 } },
        g.panel.row.new('Response'),
        panels.responseContentSizeNodeName,
        panels.totalContentSizeNodeName,
        g.panel.row.new('Network activity'),
        panels.networkConnectionsNodeName { gridPos+: { w: 8 } },
        panels.hostsContactedNodeName { gridPos+: { w: 8 } },
        panels.cacheAccessNodeName { gridPos+: { w: 8 } },
        g.panel.row.new('Request'),
        panels.requestSucessRatioNodeName,
        panels.redirectionsNodeName,
      ],
    },
}
