local g = import './g.libsonnet';
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
    local rows = this.grafana.rows;
    {
      'catchpoint-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                rows.overviewErrors,
                rows.overviewContentHandling,
                rows.overviewRequests,
                rows.overviewConnectivity,
              ]
            )
          )
        )
        // hide link to self
        + root.applyCommon(vars.overviewVariables, uid + '-overview', tags, links { catchpointOverview+:: {} }, annotations, timezone, refresh, period),
      'catchpoint-testname-overview.json':
        g.dashboard.new(prefix + ' web performance by test')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                rows.testNameErrorsAndContent,
                rows.testNameContentHandling,
                rows.testNameResponse,
                rows.testNameNetworkActivity,
                rows.testNameRequest,
              ]
            )
          )
        )
        // hide link to self
        + root.applyCommon(vars.testNameVariables, uid + '-testname-overview', tags, links { catchpointTestNameOverview+:: {} }, annotations, timezone, refresh, period),
      'catchpoint-nodename-overview.json':
        g.dashboard.new(prefix + ' web performance by node')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                rows.nodeNameErrorsAndContent,
                rows.nodeNameContentHandling,
                rows.nodeNameResponse,
                rows.nodeNameNetworkActivity,
                rows.nodeNameRequest,
              ]
            )
          )
        )
        // hide link to self
        + root.applyCommon(vars.nodeNameVariables, uid + '-nodename-overview', tags, links { catchpointNodeNameOverview+:: {} }, annotations, timezone, refresh, period),
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
