local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      veleroClusterOverview:
        link.link.new('Velero cluster overview', '/d/' + this.grafana.dashboards.clusterOverview.uid)
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
