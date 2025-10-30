local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals,

    //
    // Inventory table panels (for shard, config, mongos nodes)
    //

    shardNodesTable:
      g.panel.table.new('Shard nodes')
      + g.panel.table.panelOptions.withDescription('An inventory table for shard nodes in the environment.')
      + g.panel.table.queryOptions.withTargets([
        g.query.prometheus.new(
          '${prometheus_datasource}',
          'mongodb_network_bytesIn{job=~"$job",cl_name=~"$cl_name"}'
        )
        + g.query.prometheus.withInstant(true),
      ])
      + g.panel.table.queryOptions.withTransformations([
        { id: 'reduce', options: { labelsToFields: true, reducers: ['lastNotNull'] } },
        { id: 'organize', options: {
          excludeByName: { Field: true, 'Last *': true, __name__: true, job: true, org_id: true, process_port: true },
          indexByName: { Field: 6, 'Last *': 11, __name__: 7, cl_name: 1, cl_role: 2, group_id: 0, instance: 3, job: 8, org_id: 9, process_port: 10, rs_nm: 4, rs_state: 5 },
          renameByName: { cl_name: 'Cluster', cl_role: 'Role', group_id: 'Group', instance: 'Node', rs_nm: 'Replica set', rs_state: 'State' },
        } },
        { id: 'filterByValue', options: { filters: [{ config: { id: 'equal', options: { value: 'shardsvr' } }, fieldName: 'Role' }], match: 'all', type: 'include' } },
      ])
      + g.panel.table.standardOptions.color.withMode('thresholds')
      + g.panel.table.standardOptions.withMappings([
        g.panel.table.standardOptions.mapping.ValueMap.withType()
        + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
          '1': { index: 0, text: 'Primary' },
          '2': { index: 1, text: 'Secondary' },
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        g.panel.table.fieldOverride.byName.new('cl_role')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 150),
        g.panel.table.fieldOverride.byName.new('rs_state')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 100),
        g.panel.table.fieldOverride.byName.new('rs_nm')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 250),
        g.panel.table.fieldOverride.byName.new('cl_name')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
        g.panel.table.fieldOverride.byName.new('group_id')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
        g.panel.table.fieldOverride.byName.new('State')
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' })
        + g.panel.table.fieldOverride.byName.withProperty('mappings', [
          { options: { '1': { color: 'green', index: 0, text: 'Primary' }, '2': { color: 'yellow', index: 1, text: 'Secondary' } }, type: 'value' },
        ]),
      ]),

    configNodesTable:
      g.panel.table.new('Config nodes')
      + g.panel.table.panelOptions.withDescription('An inventory table for config nodes in the environment.')
      + g.panel.table.queryOptions.withTargets([
        g.query.prometheus.new(
          '${prometheus_datasource}',
          'mongodb_network_bytesIn{job=~"$job",cl_name=~"$cl_name"}'
        )
        + g.query.prometheus.withInstant(true),
      ])
      + g.panel.table.queryOptions.withTransformations([
        { id: 'reduce', options: { labelsToFields: true, reducers: ['lastNotNull'] } },
        { id: 'organize', options: {
          excludeByName: { Field: true, 'Last *': true, __name__: true, job: true, org_id: true, process_port: true },
          indexByName: { Field: 6, 'Last *': 11, __name__: 7, cl_name: 1, cl_role: 2, group_id: 0, instance: 3, job: 8, org_id: 9, process_port: 10, rs_nm: 4, rs_state: 5 },
          renameByName: { cl_name: 'Cluster', cl_role: 'Role', group_id: 'Group', instance: 'Node', rs_nm: 'Replica set', rs_state: 'State' },
        } },
        { id: 'filterByValue', options: { filters: [{ config: { id: 'equal', options: { value: 'configsvr' } }, fieldName: 'Role' }], match: 'all', type: 'include' } },
      ])
      + g.panel.table.standardOptions.color.withMode('thresholds')
      + g.panel.table.standardOptions.withMappings([
        g.panel.table.standardOptions.mapping.ValueMap.withType()
        + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
          '1': { index: 0, text: 'Primary' },
          '2': { index: 1, text: 'Secondary' },
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        g.panel.table.fieldOverride.byName.new('cl_role')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 150),
        g.panel.table.fieldOverride.byName.new('rs_state')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 100),
        g.panel.table.fieldOverride.byName.new('rs_nm')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 250),
        g.panel.table.fieldOverride.byName.new('cl_name')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
        g.panel.table.fieldOverride.byName.new('group_id')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
        g.panel.table.fieldOverride.byName.new('State')
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' })
        + g.panel.table.fieldOverride.byName.withProperty('mappings', [
          { options: { '1': { color: 'green', index: 0, text: 'Primary' }, '2': { color: 'yellow', index: 1, text: 'Secondary' } }, type: 'value' },
        ]),
      ]),

    mongosNodesTable:
      g.panel.table.new('mongos nodes')
      + g.panel.table.panelOptions.withDescription('An inventory table for mongos nodes in the environment.')
      + g.panel.table.queryOptions.withTargets([
        g.query.prometheus.new(
          '${prometheus_datasource}',
          'mongodb_network_bytesIn{job=~"$job",cl_name=~"$cl_name"}'
        )
        + g.query.prometheus.withInstant(true),
      ])
      + g.panel.table.queryOptions.withTransformations([
        { id: 'reduce', options: { labelsToFields: true, reducers: ['lastNotNull'] } },
        { id: 'organize', options: {
          excludeByName: { Field: true, 'Last *': true, __name__: true, job: true, org_id: true, process_port: true, rs_state: true },
          indexByName: { Field: 6, 'Last *': 11, __name__: 7, cl_name: 1, cl_role: 2, group_id: 0, instance: 3, job: 8, org_id: 9, process_port: 10, rs_nm: 4, rs_state: 5 },
          renameByName: { cl_name: 'Cluster', cl_role: 'Role', group_id: 'Group', instance: 'Node', rs_nm: 'Replica set' },
        } },
        { id: 'filterByValue', options: { filters: [{ config: { id: 'equal', options: { value: 'mongos' } }, fieldName: 'Role' }], match: 'all', type: 'include' } },
      ])
      + g.panel.table.standardOptions.color.withMode('thresholds')
      + g.panel.table.standardOptions.withMappings([
        g.panel.table.standardOptions.mapping.ValueMap.withType()
        + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
          '1': { index: 0, text: 'Primary' },
          '2': { index: 1, text: 'Secondary' },
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        g.panel.table.fieldOverride.byName.new('cl_role')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 150),
        g.panel.table.fieldOverride.byName.new('rs_state')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 100),
        g.panel.table.fieldOverride.byName.new('rs_nm')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 250),
        g.panel.table.fieldOverride.byName.new('cl_name')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
        g.panel.table.fieldOverride.byName.new('group_id')
        + g.panel.table.fieldOverride.byName.withProperty('custom.width', 300),
      ]),

    //
    // Performance section panels
    //

    hardwareIO:
      g.panel.timeSeries.new('Hardware I/O')
      + g.panel.timeSeries.panelOptions.withDescription("The number of read and write I/O's processed.")
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.hardware.diskReadCount.asTarget(),
        signals.hardware.diskWriteCount.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('iops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    hardwareIOWaitTime:
      g.panel.timeSeries.new('Hardware I/O wait time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The amount of time spent waiting for I/O requests.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.hardware.diskReadTime.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.hardware.diskWriteTime.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    hardwareCPUInterruptServiceTime:
      g.panel.timeSeries.new('Hardware CPU interrupt service time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The amount of time spent servicing CPU interrupts.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.hardware.cpuIrqTime.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    memoryUsed:
      g.panel.timeSeries.new('Memory used')
      + g.panel.timeSeries.panelOptions.withDescription('The amount of RAM and virtual memory being used.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.memory.memoryResident.asTarget(),
        signals.memory.memoryVirtual.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('mbytes')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    diskSpaceUsage:
      g.panel.timeSeries.new('Disk space usage')
      + g.panel.timeSeries.panelOptions.withDescription('The percentage of hardware space used.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.hardware.diskSpaceUtilization.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    networkRequests:
      g.panel.timeSeries.new('Network requests')
      + g.panel.timeSeries.panelOptions.withDescription('The number of distinct requests that the server has received.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.network.networkRequests.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    networkThroughput:
      g.panel.timeSeries.new('Network throughput')
      + g.panel.timeSeries.panelOptions.withDescription('The number of bytes sent and received over network connections.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.network.networkBytesIn.asTarget(),
        signals.network.networkBytesOut.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('Bps')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    slowRequests:
      g.panel.timeSeries.new('Slow requests')
      + g.panel.timeSeries.panelOptions.withDescription('The rate of DNS and SSL operations that took longer than 1 second.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.network.networkSlowDNS.asTarget(),
        signals.network.networkSlowSSL.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    //
    // Operations section panels
    //

    connections:
      g.panel.timeSeries.new('Connections')
      + g.panel.timeSeries.panelOptions.withDescription('The rate of incoming connections to the cluster created.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.connections.connectionsCreated.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('conns/s')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    readwriteOperations:
      g.panel.timeSeries.new('Read/Write operations')
      + g.panel.timeSeries.panelOptions.withDescription('The number of read and write operations.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesReadsOps.asTarget(),
        signals.operations.opLatenciesWritesOps.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    operations:
      g.panel.pieChart.new('Operations')
      + g.panel.pieChart.panelOptions.withDescription('The number of insert, query, update, and delete operations.')
      + g.panel.pieChart.queryOptions.withTargets([
        signals.operations.opCountersInsert.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.operations.opCountersQuery.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.operations.opCountersUpdate.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.operations.opCountersDelete.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.pieChart.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.pieChart.options.legend.withDisplayMode('table')
      + g.panel.pieChart.options.legend.withPlacement('bottom')
      + g.panel.pieChart.options.legend.withValues(['value'])
      + g.panel.pieChart.options.tooltip.withMode('multi')
      + g.panel.pieChart.options.tooltip.withSort('desc'),

    readwriteLatency:
      g.panel.timeSeries.new('Read/Write latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The latency for read and write operations.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesReadsLatency.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.operations.opLatenciesWritesLatency.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    //
    // Locks section panels
    //

    currentQueue:
      g.panel.timeSeries.new('Current queue')
      + g.panel.timeSeries.panelOptions.withDescription('The number of reads and writes queued because of a lock.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.globalLockQueueReaders.asTarget(),
        signals.locks.globalLockQueueWriters.asTarget(),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    activeClientOperations:
      g.panel.timeSeries.new('Active client operations')
      + g.panel.timeSeries.panelOptions.withDescription('The number of reads and writes being actively performed by connected clients.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.globalLockActiveReaders.asTarget(),
        signals.locks.globalLockActiveWriters.asTarget(),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    databaseDeadlocks:
      g.panel.timeSeries.new('Database deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of deadlocks for database level locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.locks.dbDeadlockIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.locks.dbDeadlockShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.locks.dbDeadlockIntentShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    databaseWaitsAcquiringLock:
      g.panel.timeSeries.new('Database waits acquiring lock / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database level locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.locks.dbWaitCountIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.locks.dbWaitCountShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.locks.dbWaitCountIntentShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    //
    // Elections section panels
    //

    stepUpElectionsCalled:
      g.panel.timeSeries.new('Step-up elections / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when the primary stepped down.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.stepUpCmdCalled.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.elections.stepUpCmdSuccessful.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    priorityTakeoverCalled:
      g.panel.timeSeries.new('Priority elections / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when it had a higher priority than the primary node.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.priorityTakeoverCalled.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.elections.priorityTakeoverSuccessful.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    catchUpTakeoverCalled:
      g.panel.timeSeries.new('Takeover elections / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when it was more current than the primary node.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.catchUpTakeoverCalled.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.elections.catchUpTakeoverSuccessful.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    electionTimeoutCalled:
      g.panel.timeSeries.new('Timeout elections / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when the time it took to reach the primary node exceeded the election timeout limit.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.electionTimeoutCalled.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.elections.electionTimeoutSuccessful.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    catchUpsTotal:
      g.panel.timeSeries.new('Catch-ups / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node had to catch up to the highest known oplog entry.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.numCatchUps.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    catchUpsSkipped:
      g.panel.timeSeries.new('Catch-ups skipped / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node skipped the catch up process when it was the newly elected primary.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.numCatchUpsSkipped.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    catchUpsSucceeded:
      g.panel.timeSeries.new('Catch-ups succeeded / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node succeeded in catching up when it was the newly elected primary.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.numCatchUpsSucceeded.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    catchUpsFailed:
      g.panel.timeSeries.new('Catch-ups failed / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node failed in catching up when it was the newly elected primary.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.numCatchUpsFailedWithError.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    catchUpsTimedOut:
      g.panel.timeSeries.new('Catch-up timeouts / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node timed out during the catch-up process when it was the newly elected primary.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.numCatchUpsTimedOut.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    averageCatchUpOps:
      g.panel.timeSeries.new('Average catch-up operations')
      + g.panel.timeSeries.panelOptions.withDescription('The average number of operations done during the catch-up process when this node is the newly elected primary.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.elections.averageCatchUpOps.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    //
    // Operations Overview dashboard panels
    //

    // Section 1: Operation Counters (by type) - cluster-level aggregated
    insertOperations:
      g.panel.timeSeries.new('Insert operations')
      + g.panel.timeSeries.panelOptions.withDescription('The number of insert operations.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opCountersInsert.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    queryOperations:
      g.panel.timeSeries.new('Query operations')
      + g.panel.timeSeries.panelOptions.withDescription('The number of query operations.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opCountersQuery.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    updateOperations:
      g.panel.timeSeries.new('Update operations')
      + g.panel.timeSeries.panelOptions.withDescription('The number of update operations.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opCountersUpdate.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    deleteOperations:
      g.panel.timeSeries.new('Delete operations')
      + g.panel.timeSeries.panelOptions.withDescription('The number of delete operations.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opCountersDelete.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    // Section 2: Operation Counters (by instance)
    insertOperationsByInstance:
      g.panel.timeSeries.new('Insert operations')
      + g.panel.timeSeries.panelOptions.withDescription('The rate of insert operations the node has received.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opCountersInsertByInstance.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    queryOperationsByInstance:
      g.panel.timeSeries.new('Query operations')
      + g.panel.timeSeries.panelOptions.withDescription('The rate of query operations the node has received.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opCountersQueryByInstance.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    updateOperationsByInstance:
      g.panel.timeSeries.new('Update operations')
      + g.panel.timeSeries.panelOptions.withDescription('The rate of update operations this node has received.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opCountersUpdateByInstance.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    deleteOperationsByInstance:
      g.panel.timeSeries.new('Delete operations')
      + g.panel.timeSeries.panelOptions.withDescription('The rate of delete operations this node has received.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opCountersDeleteByInstance.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 3: Operation Latencies (cluster)
    readOperationCount:
      g.panel.timeSeries.new('Read operation count')
      + g.panel.timeSeries.panelOptions.withDescription('The number of read operations.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesReadsOps.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    writeOperationCount:
      g.panel.timeSeries.new('Write operation count')
      + g.panel.timeSeries.panelOptions.withDescription('The number of write operations.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesWritesOps.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    readOperationLatency:
      g.panel.timeSeries.new('Read operation latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The latency time for read operations performed by this node.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesReadsLatency.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    writeOperationLatency:
      g.panel.timeSeries.new('Write operation latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The latency time for write operations performed by this node.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesWritesLatency.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    // Section 4: Operation Latencies (by instance)
    readOperationCountByInstance:
      g.panel.timeSeries.new('Read operation count')
      + g.panel.timeSeries.panelOptions.withDescription('The number of read operations per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesReadsOpsByInstance.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    writeOperationCountByInstance:
      g.panel.timeSeries.new('Write operation count')
      + g.panel.timeSeries.panelOptions.withDescription('The number of write operations per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesWritesOpsByInstance.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    readOperationLatencyByInstance:
      g.panel.timeSeries.new('Read operation latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The latency time for read operations performed per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesReadsLatencyByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    writeOperationLatencyByInstance:
      g.panel.timeSeries.new('Write operation latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The latency time for write operations performed per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.opLatenciesWritesLatencyByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 5: Average Latencies (calculated)
    avgReadLatency:
      g.panel.timeSeries.new('Average read latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('Average latency per read operation.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.avgReadLatency.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    avgWriteLatency:
      g.panel.timeSeries.new('Average write latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('Average latency per write operation.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.avgWriteLatency.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    avgReadLatencyByInstance:
      g.panel.timeSeries.new('Average read latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('Average latency per read operation by instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.avgReadLatencyByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    avgWriteLatencyByInstance:
      g.panel.timeSeries.new('Average write latency / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('Average latency per write operation by instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.operations.avgWriteLatencyByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    //
    // Performance Overview dashboard panels
    //

    // Section 1: Connection Metrics
    currentConnections:
      g.panel.timeSeries.new('Current connections')
      + g.panel.timeSeries.panelOptions.withDescription('The current number of active connections.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.connections.connectionsCurrent.asTarget(),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    activeConnections:
      g.panel.timeSeries.new('Active connections')
      + g.panel.timeSeries.panelOptions.withDescription('The current number of connections with operations in progress.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.connections.connectionsActive.asTarget(),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    // Section 2: Database Lock Deadlocks (Cluster)
    dbLockDeadlocksExclusive:
      g.panel.timeSeries.new('Database exclusive lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of database exclusive lock deadlocks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    dbLockDeadlocksIntentExclusive:
      g.panel.timeSeries.new('Database intent-exclusive lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of database intent-exclusive lock deadlocks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    dbLockDeadlocksShared:
      g.panel.timeSeries.new('Database shared lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of database shared lock deadlocks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    dbLockDeadlocksIntentShared:
      g.panel.timeSeries.new('Database intent-shared lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of database intent-shared lock deadlocks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockIntentShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    // Section 3: Database Lock Deadlocks (By Instance)
    dbLockDeadlocksExclusiveByInstance:
      g.panel.timeSeries.new('Database exclusive lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of database exclusive lock deadlocks per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockDeadlocksIntentExclusiveByInstance:
      g.panel.timeSeries.new('Database intent-exclusive lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of database intent-exclusive lock deadlocks per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockDeadlocksSharedByInstance:
      g.panel.timeSeries.new('Database shared lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of database shared lock deadlocks per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockDeadlocksIntentSharedByInstance:
      g.panel.timeSeries.new('Database intent-shared lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of database intent-shared lock deadlocks per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbDeadlockIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 4: Database Lock Wait Counts (Cluster)
    dbLockWaitCountExclusive:
      g.panel.timeSeries.new('Database exclusive lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database exclusive locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    dbLockWaitCountIntentExclusive:
      g.panel.timeSeries.new('Database intent-exclusive lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database intent-exclusive locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    dbLockWaitCountShared:
      g.panel.timeSeries.new('Database shared lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database shared locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    dbLockWaitCountIntentShared:
      g.panel.timeSeries.new('Database intent-shared lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database intent-shared locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountIntentShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

    // Section 5: Database Lock Wait Counts (By Instance)
    dbLockWaitCountExclusiveByInstance:
      g.panel.timeSeries.new('Database exclusive lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database exclusive locks per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockWaitCountIntentExclusiveByInstance:
      g.panel.timeSeries.new('Database intent-exclusive lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database intent-exclusive locks per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountIntentExclusiveByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockWaitCountSharedByInstance:
      g.panel.timeSeries.new('Database shared lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database shared locks per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockWaitCountIntentSharedByInstance:
      g.panel.timeSeries.new('Database intent-shared lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for database intent-shared locks per instance.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbWaitCountIntentSharedByInstance.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 6: Database Lock Acquisition Time
    dbLockAcqTimeExclusive:
      g.panel.timeSeries.new('Database exclusive lock acquisition time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring database exclusive locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbAcqTimeExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockAcqTimeIntentExclusive:
      g.panel.timeSeries.new('Database intent-exclusive lock acquisition time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring database intent-exclusive locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbAcqTimeIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockAcqTimeShared:
      g.panel.timeSeries.new('Database shared lock acquisition time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring database shared locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbAcqTimeShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    dbLockAcqTimeIntentShared:
      g.panel.timeSeries.new('Database intent-shared lock acquisition time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring database intent-shared locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.dbAcqTimeIntentShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 7: Collection Lock Deadlocks
    collLockDeadlocksExclusive:
      g.panel.timeSeries.new('Collection exclusive lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection exclusive lock deadlocks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collDeadlockExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockDeadlocksIntentExclusive:
      g.panel.timeSeries.new('Collection intent-exclusive lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection intent-exclusive lock deadlocks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collDeadlockIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockDeadlocksShared:
      g.panel.timeSeries.new('Collection shared lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection shared lock deadlocks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collDeadlockShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockDeadlocksIntentShared:
      g.panel.timeSeries.new('Collection intent-shared lock deadlocks / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of collection intent-shared lock deadlocks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collDeadlockIntentShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 8: Collection Lock Wait Counts
    collLockWaitCountExclusive:
      g.panel.timeSeries.new('Collection exclusive lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for collection exclusive locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collWaitCountExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockWaitCountIntentExclusive:
      g.panel.timeSeries.new('Collection intent-exclusive lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for collection intent-exclusive locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collWaitCountIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockWaitCountShared:
      g.panel.timeSeries.new('Collection shared lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for collection shared locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collWaitCountShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockWaitCountIntentShared:
      g.panel.timeSeries.new('Collection intent-shared lock wait count / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The number of times lock acquisitions encounter waits for collection intent-shared locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collWaitCountIntentShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Section 9: Collection Lock Acquisition Time
    collLockAcqTimeExclusive:
      g.panel.timeSeries.new('Collection exclusive lock acquisition time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring collection exclusive locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collAcqTimeExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockAcqTimeIntentExclusive:
      g.panel.timeSeries.new('Collection intent-exclusive lock acquisition time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring collection intent-exclusive locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collAcqTimeIntentExclusive.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockAcqTimeShared:
      g.panel.timeSeries.new('Collection shared lock acquisition time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring collection shared locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collAcqTimeShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    collLockAcqTimeIntentShared:
      g.panel.timeSeries.new('Collection intent-shared lock acquisition time / $__interval')
      + g.panel.timeSeries.panelOptions.withDescription('The time spent acquiring collection intent-shared locks.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.locks.collAcqTimeIntentShared.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
  },
}
