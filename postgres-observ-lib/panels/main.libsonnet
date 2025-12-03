{
  new(signals, config):: {
    health: (import './health.libsonnet').new(signals),
    problems: (import './problems.libsonnet').new(signals),
    performance: (import './performance.libsonnet').new(signals),
    maintenance: (import './maintenance.libsonnet').new(signals),
    queries: (import './queries.libsonnet').new(signals),
  },
}
