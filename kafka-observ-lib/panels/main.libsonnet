{
  new(signals):: {
    consumerGroup: (import './consumerGroup.libsonnet').new(signals),
    topic: (import './topic.libsonnet').new(signals),
  },
}
