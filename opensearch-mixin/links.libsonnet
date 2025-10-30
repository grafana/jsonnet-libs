local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      opensearchClusterOverview:
        link.link.new('Opensearch Cluster Overview', '/d/' + this.grafana.dashboards['opensearch-cluster-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      // opensearchNodeOverview:
      //   link.link.new('Opensearch Node Overview', '/d/' + this.grafana.dashboards['opensearch-node-overview.json'].uid)
      //   + link.link.options.withKeepTime(true),

      // opensearchSearchAndIndexOverview:
      //   link.link.new('Opensearch Search and Index Overview', '/d/' + this.grafana.dashboards['opensearch-search-and-index-overview.json'].uid)
      //   + link.link.options.withKeepTime(true),

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
          link.link.new('Opensearch Logs', '/d/' + this.grafana.dashboards['opensearch-logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
