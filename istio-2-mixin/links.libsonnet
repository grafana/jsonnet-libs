local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      overview:
        link.link.new('Istio overview', '/d/' + this.grafana.dashboards['istio-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      servicesOverview:
        link.link.new('Istio services overview', '/d/' + this.grafana.dashboards['istio-services-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      workloadsOverview:
        link.link.new('Istio workloads overview', '/d/' + this.grafana.dashboards['istio-workloads-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Istio logs', '/d/' + this.grafana.dashboards['istio-logs.json'].uid)
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
