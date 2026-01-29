local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      wildflyOverview:
        link.link.new('Wildfly overview', '/d/' + this.grafana.dashboards['wildfly-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      wildflyDatasource:
        link.link.new('Wildfly datasource', '/d/' + this.grafana.dashboards['wildfly-datasource.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Wildfly logs', '/d/' + this.grafana.dashboards['wildfly-logs.json'].uid)
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
