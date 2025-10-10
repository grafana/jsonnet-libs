local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      prestoOverview:
        link.link.new('Presto overview', '/d/' + this.grafana.dashboards['presto-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      prestoCoordinator:
        link.link.new('Presto coordinator', '/d/' + this.grafana.dashboards['presto-coordinator.json'].uid)
        + link.link.options.withKeepTime(true),

      prestoWorker:
        link.link.new('Presto worker', '/d/' + this.grafana.dashboards['presto-worker.json'].uid)
        + link.link.options.withKeepTime(true),

      otherDashboards:
        link.dashboards.new('All dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    } +
    if this.config.enableLokiLogs then {
      logs:
        link.link.new('Presto logs', '/d/' + this.grafana.dashboards['presto-logs.json'].uid)
        + link.link.options.withKeepTime(true),
    } else {},
}
