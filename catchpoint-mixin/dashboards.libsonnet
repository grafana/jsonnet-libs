local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local panels = this.grafana.panels;
    local stat = g.panel.stat;
    {
      overview:
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
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
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.overviewVariables, uid + '-overview', tags, links { catchpointOverview+:: {} }, annotations, timezone, refresh, period),
      testNameOverview:
        g.dashboard.new(prefix + ' web performance by test')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
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
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.testNameVariable, uid + '-testname-overview', tags, links { catchpointTestNameOverview+:: {} }, annotations, timezone, refresh, period),
      nodeNameOverview:
        g.dashboard.new(prefix + ' web performance by node')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
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
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.nodeNameVariable, uid + '-nodename-overview', tags, links { catchpointNodeNameOverview+:: {} }, annotations, timezone, refresh, period),
    },

  //Apply common options(uids, tags, annotations etc..) to all dashboards above
  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars),
}
