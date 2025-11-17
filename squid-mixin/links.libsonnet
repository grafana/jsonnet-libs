local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      squidOverview:
        link.link.new('Squid overview', '/d/' + this.grafana.dashboards['squid-overview.json'].uid)
        + link.link.options.withKeepTime(true),
    } + if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Squid logs', '/d/' + this.grafana.dashboards['squid-logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
