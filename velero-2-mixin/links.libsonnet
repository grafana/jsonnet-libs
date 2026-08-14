local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      veleroClusterOverview:
        link.link.new('Velero cluster view', '/d/' + this.grafana.dashboards['clusterOverview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      veleroOverview:
        link.link.new('Velero overview', '/d/' + this.grafana.dashboards['overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Velero logs', '/d/' + this.grafana.dashboards['logs.json'].uid)
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
