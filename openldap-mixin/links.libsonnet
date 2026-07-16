local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      openldapOverview:
        link.link.new('OpenLDAP overview', '/d/' + this.grafana.dashboards['overview.json'].uid)
        + link.link.options.withKeepTime(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('OpenLDAP logs', '/d/' + this.grafana.dashboards['logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
