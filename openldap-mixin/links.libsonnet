local g = import './g.libsonnet';
{
  new(this):
    local uid = g.util.string.slugify(this.config.uid);
    {
      openldapOverview:
        g.dashboard.link.link.new('OpenLDAP overview', '/d/' + this.grafana.dashboards[uid + '-overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          g.dashboard.link.link.new('OpenLDAP logs', '/d/' + this.grafana.dashboards[uid + '-logs.json'].uid)
          + g.dashboard.link.link.options.withKeepTime(true)
          + g.dashboard.link.link.options.withIncludeVars(true),
      }
    else {},
}
