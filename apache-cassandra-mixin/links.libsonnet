local g = import './g.libsonnet';

{
  new(this): {
    local link = g.dashboard.link,
    apacheCassandraOverview:
      link.link.new('Apache Cassandra overview', '/d/' + this.grafana.dashboards['apache-cassandra-overview.json'].uid),
    apacheCassandraNodes:
      link.link.new('Apache Cassandra nodes', '/d/' + this.grafana.dashboards['apache-cassandra-nodes.json'].uid),
    apacheCassandraKeyspaces:
      link.link.new('Apache Cassandra keyspaces', '/d/' + this.grafana.dashboards['apache-cassandra-keyspaces.json'].uid),
    dashboards:
      link.dashboards.new('All Apache Cassandra dashboards', '/d/' + this.config.dashboardTags)
      + link.dashboards.options.withKeepTime(true)
      + link.dashboards.options.withIncludeVars(true)
      + link.dashboards.options.withAsDropdown(true),
  },
}
