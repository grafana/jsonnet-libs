local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      catchpointOverview:
        link.link.new('Catchpoint overview', '/d/' + this.grafana.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
      catchpointTestNameOverview:
        link.link.new('Catchpoint web performance by tests', '/d/' + this.grafana.dashboards.testNameOverview.uid)
        + link.link.options.withKeepTime(true),
      catchpointNodeNameOverview:
        link.link.new('Catchpoint web performance by nodes', '/d/' + this.grafana.dashboards.nodeNameOverview.uid)
        + link.link.options.withKeepTime(true),
    },
}
