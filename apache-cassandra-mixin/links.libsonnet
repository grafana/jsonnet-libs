local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
               apacheCassandraOverview:
                 link.link.new('Apache Cassandra overview', '/d/' + this.grafana.dashboards['apache-cassandra-overview.json'].uid),
               apacheCassandraNodes:
                 link.link.new('Apache Cassandra nodes', '/d/' + this.grafana.dashboards['apache-cassandra-nodes.json'].uid),
               apacheCassandraKeyspaces:
                 link.link.new('Apache Cassandra keyspaces', '/d/' + this.grafana.dashboards['apache-cassandra-keyspaces.json'].uid),
               dashboards:
                 link.dashboards.new('All Apache Cassandra dashboards', this.config.dashboardTags)
                 + link.dashboards.options.withKeepTime(true)
                 + link.dashboards.options.withIncludeVars(true)
                 + link.dashboards.options.withAsDropdown(true),
             }

             + if this.config.enableLokiLogs then {
               apacheCassandraLogs:
                 link.link.new('Apache Cassandra logs', '/d/' + this.grafana.dashboards['apache-cassandra-logs.json'].uid)
                 + link.link.options.withKeepTime(true),
             }
             else {},
}
