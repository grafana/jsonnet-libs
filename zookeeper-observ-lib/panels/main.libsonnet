{
  new(signals):: {
    zookeeper: (import './zookeeper.libsonnet').new(signals),
    latency: (import './latency.libsonnet').new(signals),
  },
}
