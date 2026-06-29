local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      vSphereOverview:
        link.link.new('vSphere overview', '/d/' + this.grafana.dashboards['overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      vSphereClusters:
        link.link.new('vSphere clusters', '/d/' + this.grafana.dashboards['clusters.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      vSphereVirtualMachines:
        link.link.new('vSphere virtual machines', '/d/' + this.grafana.dashboards['virtualMachines.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      vSphereHosts:
        link.link.new('vSphere hosts', '/d/' + this.grafana.dashboards['hosts.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('vSphere logs', '/d/' + this.grafana.dashboards['logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
