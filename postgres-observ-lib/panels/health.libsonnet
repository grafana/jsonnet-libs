local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals):: {
    local statWithThresholds =
      commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withReduceOptions({ calcs: ['lastNotNull'] })
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value'),

    // PostgreSQL Up/Down status
    up:
      signals.health.up.asStat()
      + statWithThresholds
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 1, color: 'green' },
      ])
      + g.panel.stat.standardOptions.withMappings([
        {
          type: 'value',
          options: {
            '0': { text: 'DOWN', color: 'red', index: 0 },
            '1': { text: 'UP', color: 'green', index: 1 },
          },
        },
      ]),

    uptime:
      signals.health.uptime.asStat()
      + commonlib.panels.system.stat.uptime.stylize()
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },  // Just restarted
        { value: 300, color: 'yellow' },  // 5 minutes
        { value: 3600, color: 'green' },  // 1 hour+
      ]),

    // Connection utilization gauge
    connectionUtilization:
      signals.health.connectionUtilization.asGauge()
      + g.panel.gauge.standardOptions.withUnit('percentunit')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.7, color: 'yellow' },
        { value: 0.85, color: 'orange' },
        { value: 0.95, color: 'red' },
      ])
      + g.panel.gauge.options.withMinVizHeight(200)
      + g.panel.gauge.options.withMinVizWidth(200)
      + g.panel.gauge.options.withShowThresholdLabels(false),

    connectionUtilizationStat:
      signals.health.connectionUtilization.asStat()
      + statWithThresholds
      + g.panel.stat.standardOptions.withUnit('percentunit')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.7, color: 'yellow' },
        { value: 0.85, color: 'orange' },
        { value: 0.95, color: 'red' },
      ]),

    // Cache hit ratio gauge
    cacheHitRatio:
      signals.health.cacheHitRatio.asGauge()
      + g.panel.gauge.standardOptions.withUnit('percentunit')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 0.8, color: 'orange' },
        { value: 0.9, color: 'yellow' },
        { value: 0.95, color: 'green' },
      ])
      + g.panel.gauge.options.withMinVizHeight(200)
      + g.panel.gauge.options.withMinVizWidth(200)
      + g.panel.gauge.options.withShowThresholdLabels(false),

    // Cache hit ratio stat
    cacheHitRatioStat:
      signals.health.cacheHitRatio.asStat()
      + statWithThresholds
      + g.panel.stat.standardOptions.withUnit('percentunit')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 0.8, color: 'orange' },
        { value: 0.9, color: 'yellow' },
        { value: 0.95, color: 'green' },
      ]),

    // Replication lag
    replicationLag:
      signals.health.replicationLag.asStat()
      + statWithThresholds
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 5, color: 'yellow' },
        { value: 30, color: 'orange' },
        { value: 60, color: 'red' },
      ]),

    // Deadlocks
    deadlocks:
      signals.health.deadlocks.asStat()
      + statWithThresholds
      + g.panel.stat.options.withReduceOptions({ calcs: ['diff'] })
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ]),

    nodeRole:
      signals.health.isReplica.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.withMappings([
        {
          type: 'value',
          options: {
            '0': { text: 'PRIMARY', color: 'blue', index: 0 },
            '1': { text: 'REPLICA', color: 'purple', index: 1 },
          },
        },
      ]),

    // Connected replicas count
    connectedReplicas:
      signals.health.connectedReplicas.asStat()
      + statWithThresholds
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'yellow' },
        { value: 1, color: 'green' },
      ]),

    // Replication slot lag
    replicationSlotLag:
      signals.health.replicationSlotLag.asStat()
      + statWithThresholds
      + g.panel.stat.standardOptions.withUnit('bytes')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 10485760, color: 'yellow' },  // 10MB
        { value: 104857600, color: 'orange' },  // 100MB
        { value: 1073741824, color: 'red' },  // 1GB
      ]),
  },
}
