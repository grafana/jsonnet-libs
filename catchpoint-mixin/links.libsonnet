local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      catchpointOverview:
        link.link.new('Catchpoint overview', '/d/' + this.grafana.dashboards['catchpoint-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      catchpointTestNameOverview:
        link.link.new('Catchpoint web performance by tests', '/d/' + this.grafana.dashboards['catchpoint-testname-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      catchpointNodeNameOverview:
        link.link.new('Catchpoint web performance by nodes', '/d/' + this.grafana.dashboards['catchpoint-nodename-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    },
}
