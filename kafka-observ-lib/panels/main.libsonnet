{
  new(signals, config):: {
    broker: (import './broker.libsonnet').new(signals),
    cluster: (import './cluster.libsonnet').new(signals),
    consumerGroup: (import './consumerGroup.libsonnet').new(signals),
    conversion: (import './conversion.libsonnet').new(signals),
    replicaManager: (import './replicaManager.libsonnet').new(signals),
    topic: (import './topic.libsonnet').new(signals),
    totalTime: (import './totalTime.libsonnet').new(signals, config),
    zookeeperClient: (import './zookeeperClient.libsonnet').new(signals, config),
  },
}
