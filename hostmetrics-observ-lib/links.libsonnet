local g = import './g.libsonnet';

{
  new(this): {
    local link = g.dashboard.link,
    local prefix = this.config.dashboardNamePrefix,
    local backTo(title, file) =
      link.link.new('Back to ' + prefix + title, '/d/' + this.grafana.dashboards[file].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),

    backToFleet: backTo('fleet overview', 'hostmetrics-fleet.json'),
    backToHostSummary: backTo('host summary', 'hostmetrics-nodes.json'),
    otherDashboards:
      link.dashboards.new('All ' + prefix + 'dashboards', this.config.dashboardTags)
      + link.dashboards.options.withIncludeVars(true)
      + link.dashboards.options.withKeepTime(true)
      + link.dashboards.options.withAsDropdown(true),
  },
}
