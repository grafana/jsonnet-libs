local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      microsoftIISOverview:
        link.link.new('Microsoft IIS overview', '/d/' + this.grafana.dashboards['microsoft-iis-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      microsoftIISApplications:
        link.link.new('Microsoft IIS applications', '/d/' + this.grafana.dashboards['microsoft-iis-applications.json'].uid)
        + link.link.options.withKeepTime(true),

      microsoftIISDashboards:
        link.dashboards.new('All dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Microsoft IIS Logs', '/d/' + this.grafana.dashboards['microsoft-iis-logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
