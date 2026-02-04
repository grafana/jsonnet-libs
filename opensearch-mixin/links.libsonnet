local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      opensearchClusterOverview:
        link.link.new('Opensearch cluster overview', '/d/' + this.grafana.dashboards['opensearch-cluster-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      opensearchNodeOverview:
        link.link.new('Opensearch node overview', '/d/' + this.grafana.dashboards['opensearch-node-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      opensearchSearchAndIndexOverview:
        link.link.new('Opensearch search and index overview', '/d/' + this.grafana.dashboards['opensearch-search-and-index-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    } + if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('Opensearch logs', '/d/' + this.grafana.dashboards['opensearch-logs.json'].uid)
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
