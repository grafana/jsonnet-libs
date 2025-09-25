local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      gitlabOverview:
        link.link.new('GitLab overview', '/d/' + this.grafana.dashboards['gitlab-overview.json'].uid)
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
          link.link.new('GitLab logs', '/d/' + this.grafana.dashboards['gitlab-logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
