local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      hadoopNameNodeOverview:
        link.link.new(this.config.dashboardNamePrefix + ' NameNode overview', '/d/' + this.grafana.dashboards['apache-hadoop-namenode-overview.json'].uid)
        + link.link.options.withKeepTime(true),
      hadoopDataNodeOverview:
        link.link.new(this.config.dashboardNamePrefix + ' DataNode overview', '/d/' + this.grafana.dashboards['apache-hadoop-datanode-overview.json'].uid)
        + link.link.options.withKeepTime(true),
      hadoopNodeManagerOverview:
        link.link.new(this.config.dashboardNamePrefix + ' NodeManager overview', '/d/' + this.grafana.dashboards['apache-hadoop-nodemanager-overview.json'].uid)
        + link.link.options.withKeepTime(true),
      hadoopResourceManagerOverview:
        link.link.new(this.config.dashboardNamePrefix + ' ResourceManager overview', '/d/' + this.grafana.dashboards['apache-hadoop-resourcemanager-overview.json'].uid)
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
          link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['apache-hadoop-logs-overview.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
