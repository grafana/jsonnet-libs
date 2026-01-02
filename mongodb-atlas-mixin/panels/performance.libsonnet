local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {

    //
    // Performance Overview dashboard panels
    //

    // Memory and hardware panels
    memoryPerformance:
      commonlib.panels.generic.timeSeries.base.new('Memory', targets=[
        signals.performance.memoryResidentByInstance.asTarget(),
        signals.performance.memoryVirtualByInstance.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The amount of RAM and virtual memory being used by the database process.')
      + g.panel.timeSeries.standardOptions.withUnit('mbytes')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    hardwareCPUInterruptServiceTimePerformance:
      commonlib.panels.generic.timeSeries.base.new('Hardware CPU interrupt service time / $__interval', targets=[
        signals.performance.cpuIrqTimeByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The amount of time spent servicing CPU interrupts.')
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    diskSpacePerformance:
      commonlib.panels.disk.timeSeries.usage.new('Disk space', targets=[
        signals.performance.diskSpaceFree.asTarget(),
        signals.performance.diskSpaceUsed.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription("The amount of free and used disk space on this node's hardware.")
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    diskSpaceUtilizationPerformance:
      commonlib.panels.generic.timeSeries.base.new('Disk space utilization', targets=[
        signals.performance.diskSpaceUtilizationByInstance.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription("The disk space utilization for this node's hardware.")
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    networkRequestsPerformance:
      commonlib.panels.generic.timeSeries.base.new('Network requests', targets=[
        signals.performance.networkRequestsByInstance.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of distinct requests the node has received.')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    slowNetworkRequestsPerformance:
      commonlib.panels.network.timeSeries.traffic.new('Slow network requests', targets=[
        signals.performance.networkSlowDNSByInstance.asTarget(),
        signals.performance.networkSlowSSLByInstance.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of slow DNS and SSL operations received by this node.')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last*', 'min', 'mean', 'max']),

    networkThroughputPerformance:
      commonlib.panels.generic.timeSeries.base.new('Network throughput', targets=[
        signals.performance.networkBytesInByInstance.asTarget(),
        signals.performance.networkBytesOutByInstance.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of bytes sent and received by the node over a network connection.')
      + g.panel.timeSeries.standardOptions.withUnit('Bps')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    hardwareIOPerformance:
      commonlib.panels.disk.timeSeries.iops.new('Hardware I/O', targets=[
        signals.performance.diskReadCountByInstance.asTarget(),
        signals.performance.diskWriteCountByInstance.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription("The rate of read and write I/O's processed by this node.")
      + g.panel.timeSeries.standardOptions.withUnit('iops')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    hardwareIOWaitTimePerformance:
      commonlib.panels.generic.timeSeries.base.new('Hardware I/O wait time / $__interval', targets=[
        signals.performance.diskReadTimeByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.performance.diskWriteTimeByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription("The amount of time the node has spent waiting for read and write I/O's to process.")
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    currentConnections:
      commonlib.panels.network.timeSeries.base.new('Current connections', targets=[
        signals.performance.connectionsCurrent.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The current number of active connections.')
      + g.panel.timeSeries.standardOptions.withUnit('conn')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    activeConnections:
      commonlib.panels.network.timeSeries.base.new('Active connections', targets=[
        signals.performance.connectionsActive.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The current number of connections with operations in progress.')
      + g.panel.timeSeries.standardOptions.withUnit('conn')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    dbLockDeadlocksExclusive:
      commonlib.panels.generic.timeSeries.base.new('Database exclusive lock deadlocks / $__interval', targets=[
        signals.performance.dbDeadlockExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database exclusive lock deadlocks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    dbLockDeadlocksIntentExclusive:
      commonlib.panels.generic.timeSeries.base.new('Database intent-exclusive lock deadlocks / $__interval', targets=[
        signals.performance.dbDeadlockIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database intent-exclusive lock deadlocks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    dbLockDeadlocksShared:
      commonlib.panels.generic.timeSeries.base.new('Database shared lock deadlocks / $__interval', targets=[
        signals.performance.dbDeadlockShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database shared lock deadlocks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    dbLockDeadlocksIntentShared:
      commonlib.panels.generic.timeSeries.base.new('Database intent-shared lock deadlocks / $__interval', targets=[
        signals.performance.dbDeadlockIntentShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database intent-shared lock deadlocks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    // Section 3: Database Lock Deadlocks (By Instance)
    dbLockDeadlocksExclusiveByInstance:
      commonlib.panels.generic.timeSeries.base.new('Database exclusive lock deadlocks / $__interval', targets=[
        signals.performance.dbDeadlockExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database exclusive lock deadlocks per instance.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockDeadlocksIntentExclusiveByInstance:
      commonlib.panels.generic.timeSeries.base.new('Database intent-exclusive lock deadlocks / $__interval', targets=[
        signals.performance.dbDeadlockIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database intent-exclusive lock deadlocks per instance.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockDeadlocksSharedByInstance:
      commonlib.panels.generic.timeSeries.base.new('Database shared lock deadlocks / $__interval', targets=[
        signals.performance.dbDeadlockSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database shared lock deadlocks per instance.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockDeadlocksIntentSharedByInstance:
      commonlib.panels.generic.timeSeries.base.new('Database intent-shared lock deadlocks / $__interval', targets=[
        signals.performance.dbDeadlockIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database intent-shared lock deadlocks per instance.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 4: Database Lock Wait Counts (Cluster)
    dbLockWaitCountExclusive:
      commonlib.panels.generic.timeSeries.base.new('Database exclusive lock wait count / $__interval', targets=[
        signals.performance.dbWaitCountExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database exclusive locks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    dbLockWaitCountIntentExclusive:
      commonlib.panels.generic.timeSeries.base.new('Database intent-exclusive lock wait count / $__interval', targets=[
        signals.performance.dbWaitCountIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database intent-exclusive locks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    dbLockWaitCountShared:
      commonlib.panels.generic.timeSeries.base.new('Database shared lock wait count / $__interval', targets=[
        signals.performance.dbWaitCountShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database shared locks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    dbLockWaitCountIntentShared:
      commonlib.panels.generic.timeSeries.base.new('Database intent-shared lock wait count / $__interval', targets=[
        signals.performance.dbWaitCountIntentShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database intent-shared locks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    // Section 5: Database Lock Wait Counts (By Instance)
    dbLockWaitCountExclusiveByInstance:
      commonlib.panels.generic.timeSeries.base.new('Database exclusive lock wait count / $__interval', targets=[
        signals.performance.dbWaitCountExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database exclusive locks per instance.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockWaitCountIntentExclusiveByInstance:
      commonlib.panels.generic.timeSeries.base.new('Database intent-exclusive lock wait count / $__interval', targets=[
        signals.performance.dbWaitCountIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database intent-exclusive locks per instance.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockWaitCountSharedByInstance:
      commonlib.panels.generic.timeSeries.base.new('Database shared lock wait count / $__interval', targets=[
        signals.performance.dbWaitCountSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database shared locks per instance.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockWaitCountIntentSharedByInstance:
      commonlib.panels.generic.timeSeries.base.new('Database intent-shared lock wait count / $__interval', targets=[
        signals.performance.dbWaitCountIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database intent-shared locks per instance.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 6: Database Lock Acquisition Time
    dbLockAcqTimeExclusive:
      commonlib.panels.generic.timeSeries.base.new('Database exclusive lock acquisition time / $__interval', targets=[
        signals.performance.dbAcqTimeExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring database exclusive locks.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockAcqTimeIntentExclusive:
      commonlib.panels.generic.timeSeries.base.new('Database intent-exclusive lock acquisition time / $__interval', targets=[
        signals.performance.dbAcqTimeIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring database intent-exclusive locks.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockAcqTimeShared:
      commonlib.panels.generic.timeSeries.base.new('Database shared lock acquisition time / $__interval', targets=[
        signals.performance.dbAcqTimeShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring database shared locks.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockAcqTimeIntentShared:
      commonlib.panels.generic.timeSeries.base.new('Database intent-shared lock acquisition time / $__interval', targets=[
        signals.performance.dbAcqTimeIntentShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring database intent-shared locks.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 7: Collection Lock Deadlocks
    collLockDeadlocksExclusive:
      commonlib.panels.generic.timeSeries.base.new('Collection exclusive lock deadlocks / $__interval', targets=[
        signals.performance.collDeadlockExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection exclusive lock deadlocks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockDeadlocksIntentExclusive:
      commonlib.panels.generic.timeSeries.base.new('Collection intent-exclusive lock deadlocks / $__interval', targets=[
        signals.performance.collDeadlockIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection intent-exclusive lock deadlocks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockDeadlocksShared:
      commonlib.panels.generic.timeSeries.base.new('Collection shared lock deadlocks / $__interval', targets=[
        signals.performance.collDeadlockShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection shared lock deadlocks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockDeadlocksIntentShared:
      commonlib.panels.generic.timeSeries.base.new('Collection intent-shared lock deadlocks / $__interval', targets=[
        signals.performance.collDeadlockIntentShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection intent-shared lock deadlocks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 8: Collection Lock Wait Counts
    collLockWaitCountExclusive:
      commonlib.panels.generic.timeSeries.base.new('Collection exclusive lock wait count / $__interval', targets=[
        signals.performance.collWaitCountExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for collection exclusive locks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockWaitCountIntentExclusive:
      commonlib.panels.generic.timeSeries.base.new('Collection intent-exclusive lock wait count / $__interval', targets=[
        signals.performance.collWaitCountIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for collection intent-exclusive locks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockWaitCountShared:
      commonlib.panels.generic.timeSeries.base.new('Collection shared lock wait count / $__interval', targets=[
        signals.performance.collWaitCountShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for collection shared locks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockWaitCountIntentShared:
      commonlib.panels.generic.timeSeries.base.new('Collection intent-shared lock wait count / $__interval', targets=[
        signals.performance.collWaitCountIntentShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for collection intent-shared locks.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 9: Collection Lock Acquisition Time
    collLockAcqTimeExclusive:
      commonlib.panels.generic.timeSeries.base.new('Collection exclusive lock acquisition time / $__interval', targets=[
        signals.performance.collAcqTimeExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring collection exclusive locks.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockAcqTimeIntentExclusive:
      commonlib.panels.generic.timeSeries.base.new('Collection intent-exclusive lock acquisition time / $__interval', targets=[
        signals.performance.collAcqTimeIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring collection intent-exclusive locks.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockAcqTimeShared:
      commonlib.panels.generic.timeSeries.base.new('Collection shared lock acquisition time / $__interval', targets=[
        signals.performance.collAcqTimeShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring collection shared locks.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockAcqTimeIntentShared:
      commonlib.panels.generic.timeSeries.base.new('Collection intent-shared lock acquisition time / $__interval', targets=[
        signals.performance.collAcqTimeIntentShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring collection intent-shared locks.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
  },
}
