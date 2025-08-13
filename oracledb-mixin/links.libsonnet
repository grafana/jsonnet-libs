local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this)::
    {
      oracledbOverview:
        link.link.new('OracleDB overview', '/d/' + this.grafana.dashboards['oracledb-overview.json'].uid)
        + link.link.options.withKeepTime(true),

    }
    + if this.config.enableLokiLogs then {
      logs:
        g.dashboard.link.link.new('Logs', '/d/' + this.grafana.dashboards['logs.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true),
    } else {},
}
