local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals,

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
      + g.panel.timeSeries.options.legend.withAsTable(true),

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
      + g.panel.timeSeries.options.legend.withAsTable(true),

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
      + g.panel.timeSeries.options.legend.withAsTable(true),

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

    //
    // Elections panels
    //

    stepUpElectionsCalled:
      commonlib.panels.generic.timeSeries.base.new('Step-up elections / $__interval', targets=[
        signals.elections.stepUpCmdCalled.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.elections.stepUpCmdSuccessful.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when the primary stepped down.')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    priorityElections:
      commonlib.panels.generic.timeSeries.base.new('Priority elections / $__interval', targets=[
        signals.elections.priorityTakeoverCalled.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.elections.priorityTakeoverSuccessful.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when it had a higher priority than the primary node.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    takeoverElections:
      commonlib.panels.generic.timeSeries.base.new('Takeover elections / $__interval', targets=[
        signals.elections.catchUpTakeoverCalled.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.elections.catchUpTakeoverSuccessful.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when it was more current than the primary node.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    timeoutElections:
      commonlib.panels.generic.timeSeries.base.new('Timeout elections / $__interval', targets=[
        signals.elections.electionTimeoutCalled.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.elections.electionTimeoutSuccessful.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when the time it took to reach the primary node exceeded the election timeout limit.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsTotal:
      commonlib.panels.generic.timeSeries.base.new('Catch-ups / $__interval', targets=[
        signals.elections.numCatchUps.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node had to catch up to the highest known oplog entry.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsSkipped:
      commonlib.panels.generic.timeSeries.base.new('Catch-ups skipped / $__interval', targets=[
        signals.elections.numCatchUpsSkipped.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node skipped the catch up process when it was the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsSucceeded:
      commonlib.panels.generic.timeSeries.base.new('Catch-ups succeeded / $__interval', targets=[
        signals.elections.numCatchUpsSucceeded.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node succeeded in catching up when it was the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsFailed:
      commonlib.panels.generic.timeSeries.base.new('Catch-ups failed / $__interval', targets=[
        signals.elections.numCatchUpsFailedWithError.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node failed in catching up when it was the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsTimedOut:
      commonlib.panels.generic.timeSeries.base.new('Catch-up timeouts / $__interval', targets=[
        signals.elections.numCatchUpsTimedOut.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node timed out during the catch-up process when it was the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none'),

    averageCatchUpOps:
      commonlib.panels.generic.timeSeries.base.new('Average catch-up operations', targets=[
        signals.elections.averageCatchUpOps.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The average number of operations done during the catch-up process when this node is the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

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
      + g.panel.timeSeries.options.legend.withAsTable(true),

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

    //
    // Sharding Overview dashboard panels
    //

    staleConfigErrors:
      commonlib.panels.generic.timeSeries.base.new('Stale configs / $__interval', targets=[
        signals.sharding.staleConfigErrors.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('Number of times that a thread hit a stale config exception and triggered a metadata refresh.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    chunkMigrations:
      commonlib.panels.generic.timeSeries.base.new('Chunk migrations / $__interval', targets=[
        signals.sharding.moveChunksStarted.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('Chunk migration frequency for this node.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    docsCloned:
      commonlib.panels.generic.timeSeries.base.new('Docs cloned / $__interval', targets=[
        signals.sharding.docsClonedDonor.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.sharding.docsClonedRecipient.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of documents cloned on this node when it acted as primary for the donor and acted as primary for the recipient.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    criticalSectionTime:
      commonlib.panels.generic.timeSeries.base.new('Critical section time / $__interval', targets=[
        signals.sharding.criticalSectionTime.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time taken by the catch-up and update metadata phases of a range migration, by this node.')
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    // Catalog cache panels
    catalogCacheRefreshesStarted:
      commonlib.panels.generic.timeSeries.base.new('Refreshes started / $__interval', targets=[
        signals.sharding.catalogCacheIncrementalRefreshes.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.sharding.catalogCacheFullRefreshes.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of incremental and full refreshes that have started.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    catalogCacheRefreshesFailed:
      commonlib.panels.generic.timeSeries.base.new('Refreshes failed / $__interval', targets=[
        signals.sharding.catalogCacheFailedRefreshes.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of full and incremental refreshes that have failed.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catalogCacheStaleConfigs:
      commonlib.panels.generic.timeSeries.base.new('Cache stale configs / $__interval', targets=[
        signals.sharding.catalogCacheStaleConfigErrors.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times that a thread hit a stale config exception for the catalog cache and triggered a metadata refresh.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catalogCacheEntries:
      commonlib.panels.generic.timeSeries.base.new('Cache entries / $__interval', targets=[
        signals.sharding.catalogCacheDatabaseEntries.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.sharding.catalogCacheCollectionEntries.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database and collection entries that are currently in the catalog cache.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catalogCacheRefreshTime:
      commonlib.panels.generic.timeSeries.base.new('Cache refresh time / $__interval', targets=[
        signals.sharding.catalogCacheRefreshWaitTime.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The amount of time that threads had to wait for a refresh of the metadata.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catalogCacheOperationsBlocked:
      commonlib.panels.generic.timeSeries.base.new('Cache operations blocked', targets=[
        signals.sharding.catalogCacheOpsBlocked.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of operations that are blocked by a refresh of the catalog cache. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    // Shard targeting operations panels
    shardTargetingAllShards:
      commonlib.panels.generic.timeSeries.base.new('All shards', targets=[
        signals.sharding.targetingFindAllShards.asTarget(),
        signals.sharding.targetingInsertAllShards.asTarget(),
        signals.sharding.targetingUpdateAllShards.asTarget(),
        signals.sharding.targetingDeleteAllShards.asTarget(),
        signals.sharding.targetingAggregateAllShards.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of CRUD operations and aggregation commands run that targeted all shards. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    shardTargetingManyShards:
      commonlib.panels.generic.timeSeries.base.new('Many shards', targets=[
        signals.sharding.targetingFindManyShards.asTarget(),
        signals.sharding.targetingInsertManyShards.asTarget(),
        signals.sharding.targetingUpdateManyShards.asTarget(),
        signals.sharding.targetingDeleteManyShards.asTarget(),
        signals.sharding.targetingAggregateManyShards.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of CRUD operations and aggregation commands run that targeted more than 1 shard. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    shardTargetingOneShard:
      commonlib.panels.generic.timeSeries.base.new('One shard', targets=[
        signals.sharding.targetingFindOneShard.asTarget(),
        signals.sharding.targetingInsertOneShard.asTarget(),
        signals.sharding.targetingUpdateOneShard.asTarget(),
        signals.sharding.targetingDeleteOneShard.asTarget(),
        signals.sharding.targetingAggregateOneShard.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of CRUD operations and aggregation commands run that targeted 1 shard. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    shardTargetingUnsharded:
      commonlib.panels.generic.timeSeries.base.new('Unsharded', targets=[
        signals.sharding.targetingFindUnsharded.asTarget(),
        signals.sharding.targetingInsertUnsharded.asTarget(),
        signals.sharding.targetingUpdateUnsharded.asTarget(),
        signals.sharding.targetingDeleteUnsharded.asTarget(),
        signals.sharding.targetingAggregateUnsharded.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of CRUD operations and aggregation commands run on an unsharded collection. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),
  },
}
