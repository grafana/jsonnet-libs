local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals):: {
    // Helper to convert stat panel queries to instant queries for current status
    local withInstantQuery = {
      targets: std.map(function(t) t { instant: true }, super.targets),
    },

    // No data mappings by severity
    local noDataRed = { type: 'special', options: { match: 'null', result: { text: 'No data', color: 'red' } } },
    local noDataOrange = { type: 'special', options: { match: 'null', result: { text: 'No data', color: 'orange' } } },
    local noDataYellow = { type: 'special', options: { match: 'null', result: { text: 'No data', color: 'yellow' } } },
    local noDataNeutral = { type: 'special', options: { match: 'null', result: { text: 'No data', color: 'white' } } },

    local statWithThresholds =
      commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withReduceOptions({ calcs: ['lastNotNull'] })
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value'),

    // PostgreSQL Up/Down status
    up:
      signals.health.up.asStat()
      + withInstantQuery
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
        noDataRed,
      ]),

    uptime:
      signals.health.uptime.asStat()
      + withInstantQuery
      + commonlib.panels.system.stat.uptime.stylize()
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },  // Just restarted
        { value: 300, color: 'yellow' },  // 5 minutes
        { value: 3600, color: 'green' },  // 1 hour+
      ])
      + g.panel.stat.standardOptions.withMappings([noDataRed]),

    // Helper to convert gauge panel queries to instant queries
    local withInstantQueryGauge = {
      targets: std.map(function(t) t { instant: true }, super.targets),
    },

    // Connection utilization gauge
    connectionUtilization:
      signals.health.connectionUtilization.asGauge()
      + withInstantQueryGauge
      + g.panel.gauge.standardOptions.withUnit('percentunit')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.7, color: 'yellow' },
        { value: 0.85, color: 'orange' },
        { value: 0.95, color: 'red' },
      ])
      + g.panel.gauge.standardOptions.withMappings([noDataOrange])
      + g.panel.gauge.options.withMinVizHeight(200)
      + g.panel.gauge.options.withMinVizWidth(200)
      + g.panel.gauge.options.withShowThresholdLabels(false),

    connectionUtilizationStat:
      signals.health.connectionUtilization.asStat()
      + withInstantQuery
      + statWithThresholds
      + g.panel.stat.standardOptions.withUnit('percentunit')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.7, color: 'yellow' },
        { value: 0.85, color: 'orange' },
        { value: 0.95, color: 'red' },
      ])
      + g.panel.stat.standardOptions.withMappings([noDataOrange]),

    // Cache hit ratio gauge
    cacheHitRatio:
      signals.health.cacheHitRatio.asGauge()
      + withInstantQueryGauge
      + g.panel.gauge.standardOptions.withUnit('percentunit')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 0.8, color: 'orange' },
        { value: 0.9, color: 'yellow' },
        { value: 0.95, color: 'green' },
      ])
      + g.panel.gauge.standardOptions.withMappings([noDataYellow])
      + g.panel.gauge.options.withMinVizHeight(200)
      + g.panel.gauge.options.withMinVizWidth(200)
      + g.panel.gauge.options.withShowThresholdLabels(false),

    // Cache hit ratio stat
    cacheHitRatioStat:
      signals.health.cacheHitRatio.asStat()
      + withInstantQuery
      + statWithThresholds
      + g.panel.stat.standardOptions.withUnit('percentunit')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 0.8, color: 'orange' },
        { value: 0.9, color: 'yellow' },
        { value: 0.95, color: 'green' },
      ])
      + g.panel.stat.standardOptions.withMappings([noDataYellow]),

    // Replication lag - N/A for primaries
    replicationLag:
      signals.health.replicationLag.asStat()
      + withInstantQuery
      + statWithThresholds
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 5, color: 'yellow' },
        { value: 30, color: 'orange' },
        { value: 60, color: 'red' },
      ])
      + g.panel.stat.standardOptions.withMappings([noDataNeutral]),

    // Deadlocks
    deadlocks:
      signals.health.deadlocks.asStat()
      + withInstantQuery
      + statWithThresholds
      + g.panel.stat.options.withReduceOptions({ calcs: ['diff'] })
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ])
      + g.panel.stat.standardOptions.withMappings([noDataYellow]),

    nodeRole:
      signals.health.isReplica.asStat()
      + withInstantQuery
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.withMappings([
        {
          type: 'value',
          options: {
            '0': { text: 'PRIMARY', color: 'blue', index: 0 },
            '1': { text: 'REPLICA', color: 'purple', index: 1 },
          },
        },
        noDataRed,
      ]),

    // Connected replicas count - N/A for replicas
    connectedReplicas:
      signals.health.connectedReplicas.asStat()
      + withInstantQuery
      + statWithThresholds
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'yellow' },
        { value: 1, color: 'green' },
      ])
      + g.panel.stat.standardOptions.withMappings([noDataNeutral]),

    // Replication slot lag - N/A if no slots
    replicationSlotLag:
      signals.health.replicationSlotLag.asStat()
      + withInstantQuery
      + statWithThresholds
      + g.panel.stat.standardOptions.withUnit('bytes')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 10485760, color: 'yellow' },  // 10MB
        { value: 104857600, color: 'orange' },  // 100MB
        { value: 1073741824, color: 'red' },  // 1GB
      ])
      + g.panel.stat.standardOptions.withMappings([noDataNeutral]),
  },
}
