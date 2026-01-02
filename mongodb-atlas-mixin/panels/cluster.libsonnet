local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {

    //
    // Inventory table panels (for shard, config, mongos nodes)
    //

    shardNodesTable:
      commonlib.panels.generic.table.base.new(
        'Shard nodes',
        targets=[
          signals.cluster.shardNodeRepresentativeMetric.asTableTarget(),
        ],
        description='An inventory table for shard nodes in the environment.'
      )
      + g.panel.table.queryOptions.withTransformations([
        { id: 'organize', options: {
          excludeByName: { Field: true, 'Last *': true, __name__: true, job: true, org_id: true, process_port: true },
          indexByName: { Field: 6, 'Last *': 11, __name__: 7, cl_name: 1, cl_role: 2, group_id: 0, instance: 3, job: 8, org_id: 9, process_port: 10, rs_nm: 4, rs_state: 5 },
          renameByName: { cl_name: 'Cluster', cl_role: 'Role', group_id: 'Group', instance: 'Node', rs_nm: 'Replica set', rs_state: 'State' },
        } },
        { id: 'filterFieldsByName', options: {
          include: {
            names: [
              'Group',
              'Cluster',
              'Role',
              'Node',
              'Replica set',
              'State',
            ],
          },
        } },
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Role')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 150),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('State')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 100)
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' })
        + g.panel.table.fieldOverride.byName.withProperty('mappings', [
          { options: { '1': { color: 'green', index: 0, text: 'Primary' }, '2': { color: 'yellow', index: 1, text: 'Secondary' } }, type: 'value' },
        ]),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Replica set')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 250),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Cluster')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Group')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
      ])
      + g.panel.table.options.footer.withEnablePagination(true),

    configNodesTable:
      commonlib.panels.generic.table.base.new(
        'Config nodes',
        targets=[
          signals.cluster.configNodeRepresentativeMetric.asTableTarget(),
        ],
        description='An inventory table for config nodes in the environment.'
      )
      + g.panel.table.queryOptions.withTransformations([
        { id: 'organize', options: {
          excludeByName: { Field: true, 'Last *': true, __name__: true, job: true, org_id: true, process_port: true },
          indexByName: { Field: 6, 'Last *': 11, __name__: 7, cl_name: 1, cl_role: 2, group_id: 0, instance: 3, job: 8, org_id: 9, process_port: 10, rs_nm: 4, rs_state: 5 },
          renameByName: { cl_name: 'Cluster', cl_role: 'Role', group_id: 'Group', instance: 'Node', rs_nm: 'Replica set', rs_state: 'State' },
        } },
        { id: 'filterFieldsByName', options: {
          include: {
            names: [
              'Group',
              'Cluster',
              'Role',
              'Node',
              'Replica set',
              'State',
            ],
          },
        } },
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Role')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 150),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('State')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 100)
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' })
        + g.panel.table.fieldOverride.byName.withProperty('mappings', [
          { options: { '1': { color: 'green', index: 0, text: 'Primary' }, '2': { color: 'yellow', index: 1, text: 'Secondary' } }, type: 'value' },
        ]),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Replica set')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 250),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Cluster')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Group')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
      ])
      + g.panel.table.options.footer.withEnablePagination(true),

    mongosNodesTable:
      commonlib.panels.generic.table.base.new(
        'mongos nodes',
        targets=[
          signals.cluster.mongosNodeRepresentativeMetric.asTableTarget(),
        ],
        description='An inventory table for mongos nodes in the environment.'
      )
      + g.panel.table.queryOptions.withTransformations([
        { id: 'organize', options: {
          excludeByName: { Field: true, 'Last *': true, __name__: true, job: true, org_id: true, process_port: true, rs_state: true },
          indexByName: { Field: 6, 'Last *': 11, __name__: 7, cl_name: 1, cl_role: 2, group_id: 0, instance: 3, job: 8, org_id: 9, process_port: 10, rs_nm: 4, rs_state: 5 },
          renameByName: { cl_name: 'Cluster', cl_role: 'Role', group_id: 'Group', instance: 'Node', rs_nm: 'Replica set' },
        } },
        { id: 'filterFieldsByName', options: {
          include: {
            names: [
              'Group',
              'Cluster',
              'Role',
              'Node',
              'Replica set',
              'State',
            ],
          },
        } },
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Role')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 150),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Replica set')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 250),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Cluster')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Group')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
      ])
      + g.panel.table.options.footer.withEnablePagination(true),

    //
    // Performance section panels
    //

    hardwareIO:
      commonlib.panels.generic.timeSeries.base.new('Hardware I/O', targets=[
        signals.cluster.diskReadCount.asTarget(),
        signals.cluster.diskWriteCount.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription("The number of read and write I/O's processed.")
      + g.panel.timeSeries.standardOptions.withUnit('iops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last*', 'min', 'mean', 'max']),

    hardwareIOWaitTime:
      commonlib.panels.generic.timeSeries.base.new('Hardware I/O wait time / $__interval', targets=[
        signals.cluster.diskReadTime.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.diskWriteTime.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The amount of time spent waiting for I/O requests.')
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last*', 'min', 'mean', 'max']),

    hardwareCPUInterruptServiceTime:
      commonlib.panels.generic.timeSeries.base.new('Hardware CPU interrupt service time / $__interval', targets=[
        signals.cluster.cpuIrqTime.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The amount of time spent servicing CPU interrupts.')
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    memoryUsed:
      commonlib.panels.generic.timeSeries.base.new('Memory used', targets=[
        signals.cluster.memoryResident.asTarget(),
        signals.cluster.memoryVirtual.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The amount of RAM and virtual memory being used.')
      + g.panel.timeSeries.standardOptions.withUnit('mbytes')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    diskSpaceUsage:
      commonlib.panels.generic.timeSeries.base.new('Disk space usage', targets=[
        signals.cluster.diskSpaceUtilization.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The percentage of hardware space used.')
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    networkRequests:
      commonlib.panels.generic.timeSeries.base.new('Network requests', targets=[
        signals.cluster.networkRequests.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of distinct requests that the server has received.')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    networkThroughput:
      commonlib.panels.network.timeSeries.traffic.new('Network throughput', targets=[
        signals.cluster.networkBytesIn.asTarget(),
        signals.cluster.networkBytesOut.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of bytes sent and received over network connections.')
      + g.panel.timeSeries.standardOptions.withUnit('Bps')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last*', 'min', 'mean', 'max']),

    slowRequests:
      commonlib.panels.network.timeSeries.traffic.new('Slow requests', targets=[
        signals.cluster.networkSlowDNS.asTarget(),
        signals.cluster.networkSlowSSL.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of DNS and SSL operations that took longer than 1 second.')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    connections:
      commonlib.panels.network.timeSeries.base.new('Connections', targets=[
        signals.cluster.connectionsCreated.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of incoming connections to the cluster created.')
      + g.panel.timeSeries.standardOptions.withUnit('conns')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    readwriteOperations:
      commonlib.panels.disk.timeSeries.iops.new('Read/Write operations', targets=[
        signals.cluster.opLatenciesReadsOps.asTarget(),
        signals.cluster.opLatenciesWritesOps.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of read and write operations.')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    operations:
      g.panel.pieChart.new('Operations')
      + g.panel.pieChart.panelOptions.withDescription('The number of insert, query, update, and delete operations.')
      + g.panel.pieChart.queryOptions.withTargets([
        signals.cluster.opCountersInsert.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.opCountersQuery.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.opCountersUpdate.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.opCountersDelete.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.pieChart.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.pieChart.options.legend.withDisplayMode('table')
      + g.panel.pieChart.options.legend.withPlacement('bottom')
      + g.panel.pieChart.options.legend.withValues(['value'])
      + g.panel.pieChart.options.tooltip.withMode('multi')
      + g.panel.pieChart.options.tooltip.withSort('desc')
      + g.panel.pieChart.options.legend.withAsTable(true)
      + g.panel.pieChart.options.legend.withPlacement('right'),

    readwriteLatency:
      commonlib.panels.disk.timeSeries.ioWaitTime.new('Read/Write latency / $__interval', targets=[
        signals.cluster.opLatenciesReadsLatency.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.opLatenciesWritesLatency.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The latency for read and write operations.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    //
    // Locks section panels
    //

    currentQueue:
      commonlib.panels.generic.timeSeries.base.new('Current queue', targets=[
        signals.cluster.globalLockQueueReaders.asTarget(),
        signals.cluster.globalLockQueueWriters.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of reads and writes queued because of a lock.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    activeClientOperations:
      commonlib.panels.generic.timeSeries.base.new('Active client operations', targets=[
        signals.cluster.globalLockActiveReaders.asTarget(),
        signals.cluster.globalLockActiveWriters.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of reads and writes being actively performed by connected clients.')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // only available in MongoDB 4.4+
    databaseDeadlocks:
      commonlib.panels.generic.timeSeries.base.new('Database deadlocks / $__interval', targets=[
        signals.cluster.dbDeadlockExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.dbDeadlockIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.dbDeadlockShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.dbDeadlockIntentShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of deadlocks for database level locks.')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    // only available in MongoDB 4.4+
    databaseWaitsAcquiringLock:
      commonlib.panels.generic.timeSeries.base.new('Database waits acquiring lock / $__interval', targets=[
        signals.cluster.dbWaitCountExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.dbWaitCountIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.dbWaitCountShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.cluster.dbWaitCountIntentShared.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database level locks.')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
  },
}
