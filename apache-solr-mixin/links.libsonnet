local g = import './g.libsonnet';

{
  new(this): {
    local link = g.dashboard.link,

    otherDashboards:
      link.dashboards.new('Other Apache Solr dashboards', this.config.dashboardTags)
      + link.dashboards.options.withAsDropdown(false)
      + link.dashboards.options.withIncludeVars(true)
      + link.dashboards.options.withKeepTime(true),
  },
}
