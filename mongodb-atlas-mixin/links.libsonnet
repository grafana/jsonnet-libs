local g = import './g.libsonnet';

{
  new(this): {
    local link = g.dashboard.link,
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
    shardingOverview:
      link.link.new('MongoDB Atlas sharding overview', '/d/' + this.config.uid + '-sharding-overview')
      + link.link.options.withKeepTime(true),
  },
}
