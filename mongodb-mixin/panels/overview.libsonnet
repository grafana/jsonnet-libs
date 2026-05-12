local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {
    local tsPanel = g.panel.timeSeries,
    local withTableLegend =
      tsPanel.options.legend.withPlacement('right')
      + tsPanel.options.legend.withDisplayMode('table')
      + tsPanel.options.legend.withCalcs(['lastNotNull', 'min', 'mean', 'max']),

    local replicaSetStateMappings =
      g.panel.stat.standardOptions.mapping.ValueMap.withType()
      + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
        '0': { index: 0, text: 'STARTUP' },
        '1': { index: 1, text: 'PRIMARY' },
        '2': { index: 2, text: 'SECONDARY' },
        '3': { index: 3, text: 'RECOVERING' },
        '5': { index: 4, text: 'STARTUP2' },
        '6': { index: 5, text: 'UNKNOWN' },
        '7': { index: 6, text: 'ARBITER' },
        '8': { index: 7, text: 'DOWN' },
        '9': { index: 8, text: 'ROLLBACK' },
        '10': { index: 9, text: 'REMOVED' },
      }),

    overviewTotalInstances:
      commonlib.panels.generic.stat.base.new(
        'Total instances',
        targets=[signals.overview.totalInstances.asTarget()],
        description='Total number of MongoDB instances.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    overviewInstancesUp:
      commonlib.panels.generic.stat.base.new(
        'Instances up',
        targets=[signals.overview.instancesUp.asTarget()],
        description='Number of MongoDB instances that are up.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.standardOptions.threshold.step.withColor('green')
        + g.panel.stat.standardOptions.threshold.step.withValue(null),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    overviewInstancesDown:
      commonlib.panels.generic.stat.base.new(
        'Instances down',
        targets=[signals.overview.instancesDown.asTarget()],
        description='Number of MongoDB instances that are down.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.standardOptions.threshold.step.withColor('green')
        + g.panel.stat.standardOptions.threshold.step.withValue(null),
        g.panel.stat.standardOptions.threshold.step.withColor('green')
        + g.panel.stat.standardOptions.threshold.step.withValue(0),
        g.panel.stat.standardOptions.threshold.step.withColor('red')
        + g.panel.stat.standardOptions.threshold.step.withValue(1),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    overviewTotalConnections:
      commonlib.panels.generic.stat.base.new(
        'Total connections',
        targets=[signals.overview.totalConnections.asTarget()],
        description='Total current connections across all instances.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    overviewTotalOps:
      commonlib.panels.generic.stat.base.new(
        'Total QPS',
        targets=[signals.overview.totalOps.asTarget()],
        description='Total operations per second across all instances.'
      )
      + g.panel.stat.standardOptions.withUnit('ops')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    overviewMaxReplicationLag:
      commonlib.panels.generic.stat.base.new(
        'Max replication lag',
        targets=[signals.overview.maxReplicationLag.asTarget()],
        description='Maximum replication lag across all secondaries.'
      )
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.standardOptions.threshold.step.withColor('green')
        + g.panel.stat.standardOptions.threshold.step.withValue(null),
        g.panel.stat.standardOptions.threshold.step.withColor('yellow')
        + g.panel.stat.standardOptions.threshold.step.withValue(10),
        g.panel.stat.standardOptions.threshold.step.withColor('red')
        + g.panel.stat.standardOptions.threshold.step.withValue(60),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    // Per-instance panels
    overviewInstanceStates:
      commonlib.panels.generic.statusHistory.base.new(
        'Instance states',
        targets=[signals.overview.replicaSetStateByInstance.asTarget()],
        description='Replica set state per instance over time.'
      )
      + g.panel.statusHistory.standardOptions.withMappings([replicaSetStateMappings])
      + g.panel.statusHistory.options.withShowValue('auto'),

    overviewConnectionsByInstance:
      commonlib.panels.generic.timeSeries.base.new(
        'Connections by instance',
        targets=[signals.overview.connectionsByInstance.asTarget()],
        description='Current connections per instance.'
      )
      + withTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    overviewOpsByInstance:
      commonlib.panels.generic.timeSeries.base.new(
        'Operations by instance',
        targets=[signals.overview.opsByInstance.asTarget()],
        description='Operations per second per instance.'
      )
      + withTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    overviewReplicationLagByInstance:
      commonlib.panels.generic.timeSeries.base.new(
        'Replication lag by instance',
        targets=[signals.overview.replicationLagByInstance.asTarget()],
        description='Replication lag per instance.'
      )
      + withTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('s'),
  },
}
