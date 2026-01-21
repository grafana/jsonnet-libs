local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {

    //
    // Operations Overview dashboard panels
    //

    insertOperations:
      commonlib.panels.generic.timeSeries.base.new('Insert operations', targets=[
        signals.operations.opCountersInsert.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of insert operations.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    queryOperations:
      commonlib.panels.generic.timeSeries.base.new('Query operations', targets=[
        signals.operations.opCountersQuery.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of query operations.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    updateOperations:
      commonlib.panels.generic.timeSeries.base.new('Update operations', targets=[
        signals.operations.opCountersUpdate.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of update operations.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    deleteOperations:
      commonlib.panels.generic.timeSeries.base.new('Delete operations', targets=[
        signals.operations.opCountersDelete.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of delete operations.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    // Operations dashboard - connections
    currentConnectionsOperations:
      commonlib.panels.network.timeSeries.base.new('Current connections', targets=[
        signals.operations.connectionsCurrent.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of incoming connections from clients to the node.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    activeConnectionsOperations:
      commonlib.panels.generic.timeSeries.base.new('Active connections', targets=[
        signals.operations.connectionsActive.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of connections that currently have operations in progress.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    // Read/write operations (stacked)
    readwriteOperationsOperations:
      commonlib.panels.generic.timeSeries.base.new('Read and write operations', targets=[
        signals.operations.opLatenciesReadsOpsByInstanceStacked.asTarget(),
        signals.operations.opLatenciesWritesOpsByInstanceStacked.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of read and write operations performed by the node.')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    readwriteLatencyOperations:
      commonlib.panels.generic.timeSeries.base.new('Read and write latency / $__interval', targets=[
        signals.operations.opLatenciesReadsLatencyByInstanceStacked.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.opLatenciesWritesLatencyByInstanceStacked.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The latency time for read and write operations performed by this node.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    // Operations dashboard - database locks
    databaseDeadlocksOperations:
      commonlib.panels.generic.timeSeries.base.new('Database deadlocks / $__interval', targets=[
        signals.operations.dbDeadlockExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbDeadlockIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbDeadlockSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbDeadlockIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of deadlocks that have occurred for the database lock.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    databaseWaitCountOperations:
      commonlib.panels.generic.timeSeries.base.new('Database wait count / $__interval', targets=[
        signals.operations.dbWaitCountExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbWaitCountIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbWaitCountSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbWaitCountIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database lock acquisitions that had to wait.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    databaseWaitTimeOperations:
      commonlib.panels.generic.timeSeries.base.new('Database wait time / $__interval', targets=[
        signals.operations.dbAcqTimeExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbAcqTimeIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbAcqTimeSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.dbAcqTimeIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent waiting for the database lock acquisition.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Operations dashboard - collection locks
    collectionDeadlocksOperations:
      commonlib.panels.generic.timeSeries.base.new('Collection deadlocks / $__interval', targets=[
        signals.operations.collDeadlockExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collDeadlockIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collDeadlockSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collDeadlockIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of deadlocks that have occurred for the collection lock.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collectionWaitCountOperations:
      commonlib.panels.generic.timeSeries.base.new('Collection wait count / $__interval', targets=[
        signals.operations.collWaitCountExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collWaitCountIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collWaitCountSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collWaitCountIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection lock acquisitions that had to wait.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collectionWaitTimeOperations:
      commonlib.panels.generic.timeSeries.base.new('Collection wait time / $__interval', targets=[
        signals.operations.collAcqTimeExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collAcqTimeIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collAcqTimeSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.operations.collAcqTimeIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent waiting for the collection lock acquisition.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
  },
}