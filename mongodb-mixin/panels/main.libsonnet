{
  new(signals, config):
    (import './overview.libsonnet').new(signals, config) +
    (import './instance.libsonnet').new(signals, config) +
    (import './replicaset.libsonnet').new(signals, config) +
    (import './cluster.libsonnet').new(signals, config),
}
