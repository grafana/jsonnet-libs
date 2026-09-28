local g = import './g.libsonnet';
{
  new(this):
    {
      pgbouncerOverview:
        g.dashboard.link.link.new('PgBouncer overview', '/d/' + this.grafana.dashboards['pgbouncer-overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),
      pgbouncerClusterOverview:
        g.dashboard.link.link.new('PgBouncer cluster overview', '/d/' + this.grafana.dashboards['pgbouncer-cluster-overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          g.dashboard.link.link.new('PgBouncer logs', '/d/' + this.grafana.dashboards['pgbouncer-logs.json'].uid)
          + g.dashboard.link.link.options.withKeepTime(true)
          + g.dashboard.link.link.options.withIncludeVars(true),
      }
    else {},
}
