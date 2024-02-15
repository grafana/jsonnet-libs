local g = import './g.libsonnet';
{
  new(this):
    {
      local link = g.dashboard.link,
      backToOverview:
        link.link.new('Back to Istio overview', '/d/' + this.grafana.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
      backToServicesOverview:
        link.link.new('Back to Istio services overview', '/d/' + this.grafana.dashboards.servicesOverview.uid)
        + link.link.options.withKeepTime(true),
      backToWorkloadsOverview:
        link.link.new('Back to Istio workloads overview', '/d/' + this.grafana.dashboards.workloadsOverview.uid)
        + link.link.options.withKeepTime(true),
    },
}
