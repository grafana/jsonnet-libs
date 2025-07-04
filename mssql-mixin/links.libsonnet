local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      mssqlOverview:
        link.link.new('MSSQL Overview', '/d/' + this.grafana.dashboards.mssql_overview.uid)
        + link.link.options.withKeepTime(true),

      mssqlPages:
        link.link.new('MSSQL Pages', '/d/' + this.grafana.dashboards.mssql_pages.uid)
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
          link.link.new('Logs', '/d/' + this.grafana.dashboards.logs.uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
