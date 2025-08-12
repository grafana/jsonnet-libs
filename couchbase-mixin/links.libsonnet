local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      couchbaseBucketOverview:
        link.link.new('Couchbase Bucket Overview', '/d/' + this.grafana.dashboards['couchbase-bucket-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      couchbaseNodeOverview:
        link.link.new('Couchbase Node Overview', '/d/' + this.grafana.dashboards['couchbase-node-overview.json'].uid)
        + link.link.options.withKeepTime(true),

      couchbaseClusterOverview:
        link.link.new('Couchbase Cluster Overview', '/d/' + this.grafana.dashboards['couchbase-cluster-overview.json'].uid)
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
          link.link.new('Logs', '/d/' + this.grafana.dashboards['logs.json'].uid)
          + link.link.options.withKeepTime(true),
      }
    else {},
}
