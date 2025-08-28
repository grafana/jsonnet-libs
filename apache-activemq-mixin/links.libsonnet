local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      clusterOverview:
        link.link.new(this.config.dashboardNamePrefix + ' cluster overview', '/d/' + this.grafana.dashboards['apache-activemq-cluster-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      instanceOverview:
        link.link.new(this.config.dashboardNamePrefix + ' instance overview', '/d/' + this.grafana.dashboards['apache-activemq-instance-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      activemqQueues:
        link.link.new(this.config.dashboardNamePrefix + ' queue overview', '/d/' + this.grafana.dashboards['apache-activemq-queue-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      activemqTopics:
        link.link.new(this.config.dashboardNamePrefix + ' topic overview', '/d/' + this.grafana.dashboards['apache-activemq-topic-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      otherDashboards:
        link.dashboards.new('All dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          link.link.new(this.config.dashboardNamePrefix + ' Logs', '/d/' + this.grafana.dashboards['apache-activemq-logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
