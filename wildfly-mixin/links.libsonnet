local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      wildflyOverview:
        link.link.new('Wildfly Overview', '/d/' + this.grafana.dashboards['wildfly-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      wildflyDatasource:
        link.link.new('Wildfly Datasource', '/d/' + this.grafana.dashboards['wildfly-datasource.json'].uid)
        + link.link.options.withKeepTime(true),

      otherDashboards:
        link.dashboards.new('All dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Wildfly logs', '/d/' + this.grafana.dashboards['wildfly-logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
