local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      overview:
        link.link.new('OpenStack overview', '/d/' + this.grafana.dashboards['openstack-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      nova:
        link.link.new('OpenStack Nova', '/d/' + this.grafana.dashboards['openstack-nova.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      neutron:
        link.link.new('OpenStack Neutron', '/d/' + this.grafana.dashboards['openstack-neutron.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      cinder:
        link.link.new('OpenStack Cinder', '/d/' + this.grafana.dashboards['openstack-cinder.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('OpenStack logs', '/d/' + this.grafana.dashboards['openstack-logs.json'].uid)
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
