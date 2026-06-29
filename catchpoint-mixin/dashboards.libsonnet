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
    local rows = this.grafana.rows;
    {
      'overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(rows.overview, 12, 6)
        )
        // hide link to self
        + root.applyCommon(vars.overviewVariables, uid + '-overview', tags, links { catchpointOverview+:: {} }, annotations, timezone, refresh, period),
      'testNameOverview.json':
        g.dashboard.new(prefix + ' web performance by test')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(rows.testNameOverview, 12, 6)
        )
        // hide link to self
        + root.applyCommon(vars.testNameVariable, uid + '-testname-overview', tags, links { catchpointTestNameOverview+:: {} }, annotations, timezone, refresh, period),
      'nodeNameOverview.json':
        g.dashboard.new(prefix + ' web performance by node')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(rows.nodeNameOverview, 12, 6)
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
