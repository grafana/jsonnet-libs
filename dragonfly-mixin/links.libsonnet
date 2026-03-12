local g = import './g.libsonnet';
{
  new(this):
    {
      dragonflyOverview:
        g.dashboard.link.link.new('Dragonfly overview', '/d/' + this.grafana.dashboards['overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true),
      dragonflyClusterOverview:
        g.dashboard.link.link.new('Dragonfly cluster overview', '/d/' + this.grafana.dashboards['clusterOverview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true),
    },
}
