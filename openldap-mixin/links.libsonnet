local g = import './g.libsonnet';
{
  new(this):
    {
      openldapOverview:
        g.dashboard.link.link.new('OpenLDAP overview', '/d/' + this.grafana.dashboards['overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          g.dashboard.link.link.new('OpenLDAP logs', '/d/' + this.grafana.dashboards['logs.json'].uid)
          + g.dashboard.link.link.options.withKeepTime(true)
          + g.dashboard.link.link.options.withIncludeVars(true),
      }
    else {},
}
