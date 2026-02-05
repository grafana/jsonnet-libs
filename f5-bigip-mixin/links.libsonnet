local g = import './g.libsonnet';

{
  local link = g.dashboard.link,

  new(this): {
    f5BigipClusterOverview:
      link.link.new(this.config.dashboardNamePrefix + ' cluster overview', '/d/' + this.grafana.dashboards['bigip-cluster-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),

    f5BigipNodeOverview:
      link.link.new(this.config.dashboardNamePrefix + ' node overview', '/d/' + this.grafana.dashboards['bigip-node-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),

    f5BigipPoolOverview:
      link.link.new(this.config.dashboardNamePrefix + ' pool overview', '/d/' + this.grafana.dashboards['bigip-pool-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),

    f5BigipVirtualServerOverview:
      link.link.new(this.config.dashboardNamePrefix + ' virtual server overview', '/d/' + this.grafana.dashboards['bigip-virtual-server-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),

    otherDashboards:
      link.dashboards.new('All dashboards', this.config.dashboardTags)
      + link.dashboards.options.withIncludeVars(true)
      + link.dashboards.options.withKeepTime(true)
      + link.dashboards.options.withAsDropdown(true),
  } + if this.config.enableLokiLogs then {
    f5BigipLogs:
      link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['bigip-logs.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),
  } else {},
}
