local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      aerospikeOverview:
        link.link.new(this.config.dashboardNamePrefix + ' overview', '/d/' + this.grafana.dashboards['aerospike-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      aerospikeInstanceOverview:
        link.link.new(this.config.dashboardNamePrefix + ' instance overview', '/d/' + this.grafana.dashboards['aerospike-instance-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      aerospikeNamespaceOverview:
        link.link.new(this.config.dashboardNamePrefix + ' namespace overview', '/d/' + this.grafana.dashboards['aerospike-namespace-overview.json'].uid)
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
          link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['aerospike-logs-overview.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
