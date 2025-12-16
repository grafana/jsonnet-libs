local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      clusterOverview:
        link.link.new(this.config.dashboardNamePrefix + ' cluster overview', '/d/' + this.grafana.dashboards['apache-hbase-cluster-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      regionServerOverview:
        link.link.new(this.config.dashboardNamePrefix + ' RegionServer overview', '/d/' + this.grafana.dashboards['apache-hbase-regionserver-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      otherDashboards:
        link.dashboards.new('All ' + this.config.dashboardNamePrefix + ' dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['apache-hbase-logs.json'].uid)
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
