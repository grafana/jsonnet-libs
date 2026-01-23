{
  new(signals, config):
    (import './cluster.libsonnet').new(signals, config) +
    (import './elections.libsonnet').new(signals, config) +
    (import './operations.libsonnet').new(signals, config) +
    (import './performance.libsonnet').new(signals, config) +
    (import './sharding.libsonnet').new(signals, config),
}
