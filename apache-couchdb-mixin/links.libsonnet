local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      couchdbOverview:
        link.link.new(this.config.dashboardNamePrefix + ' overview', '/d/' + this.grafana.dashboards['couchdb-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      couchdbNodes:
        link.link.new(this.config.dashboardNamePrefix + ' nodes', '/d/' + this.grafana.dashboards['couchdb-nodes.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      otherDashboards:
        link.dashboards.new('All dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    }
    +
    if this.config.enableLokiLogs then {
      couchdbLogs:
        link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['couchdb-logs.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    } else {},
}
