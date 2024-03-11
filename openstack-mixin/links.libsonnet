local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      overview:
        link.link.new('OpenStack overview', '/d/' + this.grafana.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
      nova:
        link.link.new('OpenStack Nova', '/d/' + this.grafana.dashboards.nova.uid)
        + link.link.options.withKeepTime(true),
      neutron:
        link.link.new('OpenStack Neutron', '/d/' + this.grafana.dashboards.neutron.uid)
        + link.link.options.withKeepTime(true),
      cinder:
        link.link.new('OpenStack Nova', '/d/' + this.grafana.dashboards.cinder.uid)
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
