local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      clickhouseReplica:
        link.link.new(this.config.dashboardNamePrefix + ' replica', '/d/' + this.grafana.dashboards['clickhouse-replica.json'].uid)
        + link.link.options.withKeepTime(true),

      clickhouseOverview:
        link.link.new(this.config.dashboardNamePrefix + ' overview', '/d/' + this.grafana.dashboards['clickhouse-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      clickhouseLatency:
        link.link.new(this.config.dashboardNamePrefix + ' latency', '/d/' + this.grafana.dashboards['clickhouse-latency.json'].uid)
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
          link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
