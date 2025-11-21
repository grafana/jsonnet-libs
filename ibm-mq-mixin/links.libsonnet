local g = import './g.libsonnet';

{
  new(this): {
    local link = g.dashboard.link,
    clusterOverview:
      link.link.new('IBM MQ cluster overview', '/d/' + this.config.uid + '-cluster-overview')
      + link.link.options.withKeepTime(true),
    queueManagerOverview:
      link.link.new('IBM MQ queue manager overview', '/d/' + this.config.uid + '-queue-manager-overview')
      + link.link.options.withKeepTime(true),
    queueOverview:
      link.link.new('IBM MQ queue overview', '/d/' + this.config.uid + '-queue-overview')
      + link.link.options.withKeepTime(true),
    topicsOverview:
      link.link.new('IBM MQ topics overview', '/d/' + this.config.uid + '-topics-overview')
      + link.link.options.withKeepTime(true),
  },
}
