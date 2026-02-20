local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      dockerOverview:
        link.link.new(
          this.config.dashboardNamePrefix + 'Docker overview',
          '/d/' + this.grafana.dashboards['docker-overview.json'].uid
        )
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      otherDashboards:
        link.dashboards.new('All Docker dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(false),
    }
    + if this.config.enableLokiLogs then
      {
        logs:
          link.link.new(
            this.config.dashboardNamePrefix + 'Docker logs',
            '/d/' + this.grafana.dashboards['docker-logs.json'].uid
          )
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
