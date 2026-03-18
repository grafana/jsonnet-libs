local g = import './g.libsonnet';

{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = this.config.uid;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    {
      'alerts-overview.json':
        g.dashboard.new(prefix + 'Alerts overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.alertsOverview,
              ]
            )
          ), setPanelIDs=false
        )
        + root.applyCommon(
          this.signals.alerts.getVariablesMultiChoice(),
          uid + '-alerts-overview',
          tags,
          links,
          annotations,
          timezone,
          refresh,
          period
        ),
    },

  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period)::
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),
}
