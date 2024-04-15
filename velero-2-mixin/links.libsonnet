local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      veleroClusterOverview:
        link.link.new('Velero cluster view', '/d/' + this.grafana.dashboards.clusterOverview.uid)
        + link.link.options.withKeepTime(true),
      veleroOverview:
        link.link.new('Velero overview', '/d/' + this.grafana.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Velero logs', '/d/' + this.grafana.dashboards.logs.uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
