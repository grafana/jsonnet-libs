local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      cloudOverview:
        link.link.new('OpenStack cloud overview', '/d/' + this.grafana.dashboards.cloudOverview.uid)
        + link.link.options.withKeepTime(true),
      novaNeutronOverview:
        link.link.new('OpenStack nova and neutron overview', '/d/' + this.grafana.dashboards.novaNeutronOverview.uid)
        + link.link.options.withKeepTime(true),
      cinderGlanceOverviewOverview:
        link.link.new('OpenStack cinder and glance overview', '/d/' + this.grafana.dashboards.cinderGlanceOverview.uid)
        + link.link.options.withKeepTime(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('OpenStack logs', '/d/' + this.grafana.dashboards.logs.uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
