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
      clusterOverview:
        g.dashboard.new(prefix + 'Cluster overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.clientsWaitingConnections { gridPos+: { w: 4, h: 4 } },
              .panel.row.new('Queries'),
              panels.queriesPooled { gridPos+: { w: 12 } }, 
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.singleInstance, uid + '-cluster-overview', tags, links { veleroClusterOverview+:: {} }, annotations, timezone, refresh, period),
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
