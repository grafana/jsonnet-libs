local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      apacheMesosOverview:
        link.link.new('Apache Mesos overview', '/d/' + this.grafana.dashboards['apache-mesos-overview.json'].uid)
        + link.link.options.withKeepTime(true),
    }
    + if this.config.enableLokiLogs then {
      logs:
        link.link.new('Apache Mesos logs', '/d/' + this.grafana.dashboards['apache-mesos-logs.json'].uid)
        + link.link.options.withKeepTime(true),
    } else {},
}
