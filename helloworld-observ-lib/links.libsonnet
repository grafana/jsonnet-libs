local g = import './g.libsonnet';
{
  new(this):
    {
      local link = g.dashboard.link,
      backToFleet:
        link.link.new('Back to Helloworld fleet', '/d/' + this.grafana.dashboards.fleet.uid)
        + link.link.options.withKeepTime(true),
      backToOverview:
        link.link.new('Back to Helloworld overview', '/d/' + this.grafana.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
      otherDashboards:
        link.dashboards.new('All Helloworld dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    },
}
