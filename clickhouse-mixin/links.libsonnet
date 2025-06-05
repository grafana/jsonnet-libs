local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      clickhouseReplica:
        link.link.new(this.config.dashboardNamePrefix + ' Replica', '/d/' + this.grafana.dashboards['clickhouse-replica'].uid)
        + link.link.options.withKeepTime(true),

      clickhouseOverview:
        link.link.new(this.config.dashboardNamePrefix + ' Overview', '/d/' + this.grafana.dashboards['clickhouse-overview'].uid)
        + link.link.options.withKeepTime(true),

      clickhouseLatency:
        link.link.new(this.config.dashboardNamePrefix + ' Latency', '/d/' + this.grafana.dashboards['clickhouse-latency'].uid)
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
          link.link.new('Logs', '/d/' + this.grafana.dashboards['clickhouse-logs'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
