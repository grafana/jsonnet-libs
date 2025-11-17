local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
    clusterOverview:
      link.link.new('MongoDB Atlas cluster overview', '/d/' + this.config.uid + '-cluster-overview')
      + link.link.options.withKeepTime(true),
    electionsOverview:
      link.link.new('MongoDB Atlas elections overview', '/d/' + this.config.uid + '-elections-overview')
      + link.link.options.withKeepTime(true),
    operationsOverview:
      link.link.new('MongoDB Atlas operations overview', '/d/' + this.config.uid + '-operations-overview')
      + link.link.options.withKeepTime(true),
    performanceOverview:
      link.link.new('MongoDB Atlas performance overview', '/d/' + this.config.uid + '-performance-overview')
      + link.link.options.withKeepTime(true),
  } + if this.config.enableShardingOverview then {
    shardingOverview:
      link.link.new('MongoDB Atlas sharding overview', '/d/' + this.config.uid + '-sharding-overview')
      + link.link.options.withKeepTime(true),
  } else {
    shardingOverview: {},
  } + {
    otherDashboards:
      link.dashboards.new('All dashboards', this.config.dashboardTags)
      + link.dashboards.options.withIncludeVars(true)
      + link.dashboards.options.withKeepTime(true)
      + link.dashboards.options.withAsDropdown(true),
  },
}
