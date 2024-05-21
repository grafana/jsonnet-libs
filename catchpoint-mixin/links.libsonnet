local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      catchpointOverview:
        link.link.new('Catchpoint overview', '/d/' + this.grafana.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
      catchpointTestNameOverview:
        link.link.new('Catchpoint test name', '/d/' + this.grafana.dashboards.testNameOverview.uid)
        + link.link.options.withKeepTime(true),
      catchpointNodeNameOverview:
        link.link.new('Catchpoint node name machines', '/d/' + this.grafana.dashboards.nodeNameOverview.uid)
        + link.link.options.withKeepTime(true),
    },
}
