local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      overview:
        link.link.new('Istio overview', '/d/' + this.grafana.dashboards['overview.json'].uid)
        + link.link.options.withKeepTime(true),
      servicesOverview:
        link.link.new('Istio services overview', '/d/' + this.grafana.dashboards['servicesOverview.json'].uid)
        + link.link.options.withKeepTime(true),
      workloadsOverview:
        link.link.new('Istio workloads overview', '/d/' + this.grafana.dashboards['workloadsOverview.json'].uid)
        + link.link.options.withKeepTime(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Istio logs', '/d/' + this.grafana.dashboards['logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
