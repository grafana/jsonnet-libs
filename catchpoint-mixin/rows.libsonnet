local g = import './g.libsonnet';

// Row layout for each dashboard. All positioning lives here: every panel carries
// an explicit gridPos width and height, so dashboards.libsonnet only has to
// assemble the rows.
{
  new(this):
    {
      local panels = this.grafana.panels,

      overviewErrors:
        g.panel.row.new('Errors')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.topErrorsByTestName { gridPos+: { w: 16, h: 6 } },
          panels.alertsPanel { gridPos+: { w: 8, h: 6 } },
        ]),

      overviewContentHandling:
        g.panel.row.new('Content handling and loading')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.topAvgLoadTimeTestName { gridPos+: { w: 12, h: 6 } },
          panels.topAvgTotalLoadTimeNodeName { gridPos+: { w: 12, h: 6 } },
          panels.topAvgDocumentCompletionTimeTestName { gridPos+: { w: 12, h: 6 } },
          panels.topAvgDocumentCompletionTimeNodeName { gridPos+: { w: 12, h: 6 } },
        ]),

      overviewRequests:
        g.panel.row.new('Requests')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.bottomAvgRequestRatioTestName { gridPos+: { w: 12, h: 6 } },
          panels.bottomAvgRequestSuccessRatioNodeName { gridPos+: { w: 12, h: 6 } },
        ]),

      overviewConnectivity:
        g.panel.row.new('Connectivity')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.topAvgConnectionSetupTimeTestName { gridPos+: { w: 12, h: 6 } },
          panels.topAvgConnectionSetupTimeNodeName { gridPos+: { w: 12, h: 6 } },
          panels.topAvgContentLoadingTimeTestName { gridPos+: { w: 12, h: 6 } },
          panels.topAvgContentLoadingTimeNodeName { gridPos+: { w: 12, h: 6 } },
          panels.topAvgRedirectsTestName { gridPos+: { w: 12, h: 6 } },
          panels.topAvgRedirectsNodeName { gridPos+: { w: 12, h: 6 } },
        ]),

      testNameErrorsAndContent:
        g.panel.row.new('Errors and content types')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.errors { gridPos+: { w: 8, h: 6 } },
          panels.contentTypesLoadedBySize { gridPos+: { w: 8, h: 6 } },
          panels.contentLoadedByType { gridPos+: { w: 8, h: 6 } },
        ]),

      testNameContentHandling:
        g.panel.row.new('Content handling and loading')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.pageCompletionTime { gridPos+: { w: 16, h: 6 } },
          panels.clientProcessing { gridPos+: { w: 8, h: 6 } },
          panels.DNSResolution { gridPos+: { w: 24, h: 6 } },
          panels.contentHandling { gridPos+: { w: 24, h: 6 } },
          panels.additionalDelay { gridPos+: { w: 24, h: 6 } },
        ]),

      testNameResponse:
        g.panel.row.new('Response')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.responseContentSize { gridPos+: { w: 12, h: 6 } },
          panels.totalContentSize { gridPos+: { w: 12, h: 6 } },
        ]),

      testNameNetworkActivity:
        g.panel.row.new('Network activity')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.networkConnections { gridPos+: { w: 8, h: 6 } },
          panels.hostsContacted { gridPos+: { w: 8, h: 6 } },
          panels.cacheAccess { gridPos+: { w: 8, h: 6 } },
        ]),

      testNameRequest:
        g.panel.row.new('Request')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.requestSucessRatio { gridPos+: { w: 12, h: 6 } },
          panels.redirections { gridPos+: { w: 12, h: 6 } },
        ]),

      nodeNameErrorsAndContent:
        g.panel.row.new('Errors and content types')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.errorsNodeName { gridPos+: { w: 8, h: 6 } },
          panels.contentTypesLoadedBySizeNodeName { gridPos+: { w: 8, h: 6 } },
          panels.contentLoadedByTypeNodeName { gridPos+: { w: 8, h: 6 } },
        ]),

      nodeNameContentHandling:
        g.panel.row.new('Content handling and loading')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.pageCompletionTimeNodeName { gridPos+: { w: 16, h: 6 } },
          panels.clientProcessingNodeName { gridPos+: { w: 8, h: 6 } },
          panels.DNSResolutionNodeName { gridPos+: { w: 24, h: 6 } },
          panels.contentHandlingNodeName { gridPos+: { w: 24, h: 6 } },
          panels.additionalDelayNodeName { gridPos+: { w: 24, h: 6 } },
        ]),

      nodeNameResponse:
        g.panel.row.new('Response')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.responseContentSizeNodeName { gridPos+: { w: 12, h: 6 } },
          panels.totalContentSizeNodeName { gridPos+: { w: 12, h: 6 } },
        ]),

      nodeNameNetworkActivity:
        g.panel.row.new('Network activity')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.networkConnectionsNodeName { gridPos+: { w: 8, h: 6 } },
          panels.hostsContactedNodeName { gridPos+: { w: 8, h: 6 } },
          panels.cacheAccessNodeName { gridPos+: { w: 8, h: 6 } },
        ]),

      nodeNameRequest:
        g.panel.row.new('Request')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.requestSucessRatioNodeName { gridPos+: { w: 12, h: 6 } },
          panels.redirectionsNodeName { gridPos+: { w: 12, h: 6 } },
        ]),
    },
}
