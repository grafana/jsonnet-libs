local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      pgbouncerOverview:
        link.link.new('OpenLDAP overview', '/d/' + this.grafana.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('OpenLDAP logs', '/d/' + this.grafana.dashboards.logs.uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
