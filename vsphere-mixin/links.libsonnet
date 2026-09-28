local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    // Dashboard keys are '<uid>-<name>.json', so build them from config.uid rather than
    // repeating the prefix as a literal.
    local uid = g.util.string.slugify(this.config.uid);
    {
      vSphereOverview:
        link.link.new('vSphere overview', '/d/' + this.grafana.dashboards[uid + '-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      vSphereClusters:
        link.link.new('vSphere clusters', '/d/' + this.grafana.dashboards[uid + '-clusters.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      vSphereVirtualMachines:
        link.link.new('vSphere virtual machines', '/d/' + this.grafana.dashboards[uid + '-virtual-machines.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
      vSphereHosts:
        link.link.new('vSphere hosts', '/d/' + this.grafana.dashboards[uid + '-hosts.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('vSphere logs', '/d/' + this.grafana.dashboards[uid + '-logs.json'].uid)
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
