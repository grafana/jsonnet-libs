local g = import './g.libsonnet';

{
  new(this): {
    overview:
      g.dashboard.link.link.new('Discourse overview', '/d/' + this.config.uid + '-overview')
      + g.dashboard.link.link.options.withKeepTime(true),

    jobs:
      g.dashboard.link.link.new('Discourse jobs', '/d/' + this.config.uid + '-jobs')
      + g.dashboard.link.link.options.withKeepTime(true),
  },
}
