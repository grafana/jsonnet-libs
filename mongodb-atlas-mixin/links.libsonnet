local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
    clusterOverview:
      link.link.new('MongoDB Atlas cluster overview', '/d/' + this.grafana.dashboards['mongodb-atlas-cluster-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),
    electionsOverview:
      link.link.new('MongoDB Atlas elections overview', '/d/' + this.grafana.dashboards['mongodb-atlas-elections-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),
    operationsOverview:
      link.link.new('MongoDB Atlas operations overview', '/d/' + this.grafana.dashboards['mongodb-atlas-operations-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),
    performanceOverview:
      link.link.new('MongoDB Atlas performance overview', '/d/' + this.grafana.dashboards['mongodb-atlas-performance-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),
    otherDashboards:
      link.dashboards.new('All dashboards', this.config.dashboardTags)
      + link.dashboards.options.withIncludeVars(true)
      + link.dashboards.options.withKeepTime(true)
      + link.dashboards.options.withAsDropdown(true),
  } + if this.config.enableShardingOverview then {
    shardingOverview:
      link.link.new('MongoDB Atlas sharding overview', '/d/' + this.grafana.dashboards['mongodb-atlas-sharding-overview.json'].uid)
      + link.link.options.withKeepTime(true)
      + link.link.options.withIncludeVars(true),
  } else {
    shardingOverview: {},
  },
}
