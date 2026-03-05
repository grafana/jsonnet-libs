local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

{
  new(this): {
    local instanceLabel = xtd.array.slice(this.config.instanceLabels, -1)[0],
    groups: [
      {
        name: this.config.uid,
        rules: [
          {
            alert: 'DragonflyHighMemoryUsage',
            expr: |||
              100 * dragonfly_memory_used_bytes{%(filteringSelector)s} / clamp_min(dragonfly_memory_max_bytes{%(filteringSelector)s}, 1) > %(alertsHighMemoryUsageCritical)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Dragonfly memory usage is critically high.',
              description: 'Memory usage on {{ $labels.%s }} is above %s%%. Current value is {{ $value | printf "%%.2f" }}%%.' % [
                instanceLabel,
                this.config.alertsHighMemoryUsageCritical,
              ],
            },
          },
          {
            alert: 'DragonflyHighMemoryUsageWarning',
            expr: |||
              100 * dragonfly_memory_used_bytes{%(filteringSelector)s} / clamp_min(dragonfly_memory_max_bytes{%(filteringSelector)s}, 1) > %(alertsHighMemoryUsageWarning)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Dragonfly memory usage is high.',
              description: 'Memory usage on {{ $labels.%s }} is above %s%%. Current value is {{ $value | printf "%%.2f" }}%%.' % [
                instanceLabel,
                this.config.alertsHighMemoryUsageWarning,
              ],
            },
          },
          {
            alert: 'DragonflyHighConnectedClients',
            expr: |||
              dragonfly_connected_clients{%(filteringSelector)s} > %(alertsHighConnectedClients)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Dragonfly has high number of connected clients.',
              description: 'Connected clients on {{ $labels.%s }} is above %s. Current value is {{ $value | printf "%%.0f" }}.' % [
                instanceLabel,
                this.config.alertsHighConnectedClients,
              ],
            },
          },
          {
            alert: 'DragonflyLowKeyspaceHitRate',
            expr: |||
              100 * sum by (job, instance) (rate(dragonfly_keyspace_hits_total{%(filteringSelector)s}[5m])) / clamp_min(sum by (job, instance) (rate(dragonfly_keyspace_hits_total{%(filteringSelector)s}[5m]) + rate(dragonfly_keyspace_misses_total{%(filteringSelector)s}[5m])), 0.001) < (100 - %(alertsHighKeyspaceMissRate)s)
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Dragonfly keyspace hit rate is low.',
              description: 'Keyspace hit rate on {{ $labels.%s }} is below %s%%. Current hit rate is {{ $value | printf "%%.2f" }}%%.' % [
                instanceLabel,
                this.config.alertsHighKeyspaceMissRate,
              ],
            },
          },
        ],
      },
    ],
  },
}
