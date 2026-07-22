local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this):
    {
      mongodbOverview:
        link.link.new('MongoDB overview', '/d/' + this.grafana.dashboards['mongodb-overview.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      mongodbInstance:
        link.link.new('MongoDB instance', '/d/' + this.grafana.dashboards['mongodb-instance.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      mongodbReplicaset:
        link.link.new('MongoDB replica set', '/d/' + this.grafana.dashboards['mongodb-replicaset.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),

      mongodbCluster:
        link.link.new('MongoDB cluster', '/d/' + this.grafana.dashboards['mongodb-cluster.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    } + if this.config.enableLokiLogs then
      {
        logs:
          link.link.new('MongoDB logs', '/d/' + this.grafana.dashboards['mongodb-logs.json'].uid)
          + link.link.options.withKeepTime(true)
          + link.link.options.withIncludeVars(true),
      }
    else {},
}
