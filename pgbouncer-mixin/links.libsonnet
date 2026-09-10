local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      pgbouncerOverview:
        link.link.new('PgBouncer overview', '/d/' + this.grafana.dashboards['pgbouncer-overview.json'].uid)
        + link.link.options.withKeepTime(true),
      pgbouncerClusterOverview:
        link.link.new('PgBouncer cluster overview', '/d/' + this.grafana.dashboards['pgbouncer-cluster-overview.json'].uid)
        + link.link.options.withKeepTime(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('PgBouncer logs', '/d/' + this.grafana.dashboards['pgbouncer-logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
