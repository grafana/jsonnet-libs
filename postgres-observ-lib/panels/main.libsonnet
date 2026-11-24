{
  new(this):: {
    local signals = this.signals,
    local config = this.config,
    health: (import './health.libsonnet').new(signals, config),
    problems: (import './problems.libsonnet').new(signals),
    performance: (import './performance.libsonnet').new(signals),
    maintenance: (import './maintenance.libsonnet').new(signals, config),
    queries: (import './queries.libsonnet').new(signals, config),
    settings: (import './settings.libsonnet').new(signals, config),
    cluster: (import './cluster.libsonnet').new(signals, config, this.grafana.dashboards),
  },
}
