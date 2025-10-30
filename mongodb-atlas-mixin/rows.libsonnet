local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    //
    // Cluster Overview dashboard rows
    //

    clusterOverviewHardwareRow:
      g.panel.row.new('Hardware')
      + g.panel.row.withPanels([
        panels.hardwareIO { gridPos: { h: 12, w: 12, x: 0, y: 0 } },
        panels.hardwareIOWaitTime { gridPos: { h: 12, w: 12, x: 12, y: 0 } },
        panels.hardwareCPUInterruptServiceTime { gridPos: { h: 8, w: 12, x: 0, y: 12 } },
        panels.memoryUsed { gridPos: { h: 8, w: 12, x: 12, y: 12 } },
      ]),

    clusterOverviewDiskRow:
      g.panel.row.new('Disk')
      + g.panel.row.withPanels([
        panels.diskSpaceUsage { gridPos: { h: 8, w: 24, x: 0, y: 0 } },
      ]),

    clusterOverviewNetworkRow:
      g.panel.row.new('Network')
      + g.panel.row.withPanels([
        panels.networkRequests { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.networkThroughput { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.slowRequests { gridPos: { h: 8, w: 24, x: 0, y: 8 } },
      ]),

    clusterOverviewConnectionsRow:
      g.panel.row.new('Connections')
      + g.panel.row.withPanels([
        panels.connections { gridPos: { h: 8, w: 24, x: 0, y: 0 } },
      ]),

    clusterOverviewOperationsRow:
      g.panel.row.new('Operations')
      + g.panel.row.withPanels([
        panels.readwriteOperations { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.operations { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.readwriteLatency { gridPos: { h: 8, w: 24, x: 0, y: 8 } },
      ]),

    clusterOverviewLocksRow:
      g.panel.row.new('Locks')
      + g.panel.row.withPanels([
        panels.currentQueue { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.activeClientOperations { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.databaseDeadlocks { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.databaseWaitsAcquiringLock { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    //
    // Elections Overview dashboard rows
    //

    electionsStepUpRow:
      g.panel.row.new('Step-up elections')
      + g.panel.row.withPanels([
        panels.stepUpElectionsCalled { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
      ]),

    electionsPriorityTakeoverRow:
      g.panel.row.new('Priority takeover elections')
      + g.panel.row.withPanels([
        panels.priorityTakeoverCalled { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
      ]),

    electionsCatchUpTakeoverRow:
      g.panel.row.new('Catch-up takeover elections')
      + g.panel.row.withPanels([
        panels.catchUpTakeoverCalled { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
      ]),

    electionsTimeoutRow:
      g.panel.row.new('Election timeout')
      + g.panel.row.withPanels([
        panels.electionTimeoutCalled { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
      ]),

    electionsCatchUpsRow:
      g.panel.row.new('Catch-ups')
      + g.panel.row.withPanels([
        panels.catchUpsTotal { gridPos: { h: 8, w: 8, x: 0, y: 0 } },
        panels.catchUpsSkipped { gridPos: { h: 8, w: 8, x: 8, y: 0 } },
        panels.catchUpsSucceeded { gridPos: { h: 8, w: 8, x: 16, y: 0 } },
        panels.catchUpsFailed { gridPos: { h: 8, w: 8, x: 0, y: 8 } },
        panels.catchUpsTimedOut { gridPos: { h: 8, w: 8, x: 8, y: 8 } },
        panels.averageCatchUpOps { gridPos: { h: 8, w: 8, x: 16, y: 8 } },
      ]),

    //
    // Operations Overview dashboard rows
    //

    operationsCountersClusterRow:
      g.panel.row.new('Operation counters - cluster')
      + g.panel.row.withPanels([
        panels.insertOperations { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.queryOperations { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.updateOperations { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.deleteOperations { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    operationsCountersInstanceRow:
      g.panel.row.new('Operation counters - instance')
      + g.panel.row.withPanels([
        panels.insertOperationsByInstance { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.queryOperationsByInstance { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.updateOperationsByInstance { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.deleteOperationsByInstance { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    operationsLatenciesClusterRow:
      g.panel.row.new('Operation latencies - cluster')
      + g.panel.row.withPanels([
        panels.readOperationCount { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.writeOperationCount { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.readOperationLatency { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.writeOperationLatency { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    operationsLatenciesInstanceRow:
      g.panel.row.new('Operation latencies - instance')
      + g.panel.row.withPanels([
        panels.readOperationCountByInstance { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.writeOperationCountByInstance { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.readOperationLatencyByInstance { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.writeOperationLatencyByInstance { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    operationsAvgLatenciesRow:
      g.panel.row.new('Average latencies')
      + g.panel.row.withPanels([
        panels.avgReadLatency { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.avgWriteLatency { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.avgReadLatencyByInstance { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.avgWriteLatencyByInstance { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    //
    // Performance Overview dashboard rows
    //

    performanceConnectionsRow:
      g.panel.row.new('Connections')
      + g.panel.row.withPanels([
        panels.currentConnections { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.activeConnections { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
      ]),

    performanceDbLocksClusterRow:
      g.panel.row.new('Database lock deadlocks - cluster')
      + g.panel.row.withPanels([
        panels.dbLockDeadlocksExclusive { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.dbLockDeadlocksIntentExclusive { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.dbLockDeadlocksShared { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.dbLockDeadlocksIntentShared { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    performanceDbLocksInstanceRow:
      g.panel.row.new('Database lock deadlocks - instance')
      + g.panel.row.withPanels([
        panels.dbLockDeadlocksExclusiveByInstance { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.dbLockDeadlocksIntentExclusiveByInstance { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.dbLockDeadlocksSharedByInstance { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.dbLockDeadlocksIntentSharedByInstance { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    performanceDbWaitCountsClusterRow:
      g.panel.row.new('Database lock wait counts - cluster')
      + g.panel.row.withPanels([
        panels.dbLockWaitCountExclusive { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.dbLockWaitCountIntentExclusive { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.dbLockWaitCountShared { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.dbLockWaitCountIntentShared { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    performanceDbWaitCountsInstanceRow:
      g.panel.row.new('Database lock wait counts - instance')
      + g.panel.row.withPanels([
        panels.dbLockWaitCountExclusiveByInstance { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.dbLockWaitCountIntentExclusiveByInstance { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.dbLockWaitCountSharedByInstance { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.dbLockWaitCountIntentSharedByInstance { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    performanceDbAcqTimeRow:
      g.panel.row.new('Database lock acquisition time')
      + g.panel.row.withPanels([
        panels.dbLockAcqTimeExclusive { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.dbLockAcqTimeIntentExclusive { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.dbLockAcqTimeShared { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.dbLockAcqTimeIntentShared { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    performanceCollLocksRow:
      g.panel.row.new('Collection lock deadlocks')
      + g.panel.row.withPanels([
        panels.collLockDeadlocksExclusive { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.collLockDeadlocksIntentExclusive { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.collLockDeadlocksShared { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.collLockDeadlocksIntentShared { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    performanceCollWaitCountsRow:
      g.panel.row.new('Collection lock wait counts')
      + g.panel.row.withPanels([
        panels.collLockWaitCountExclusive { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.collLockWaitCountIntentExclusive { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.collLockWaitCountShared { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.collLockWaitCountIntentShared { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    performanceCollAcqTimeRow:
      g.panel.row.new('Collection lock acquisition time')
      + g.panel.row.withPanels([
        panels.collLockAcqTimeExclusive { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.collLockAcqTimeIntentExclusive { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.collLockAcqTimeShared { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.collLockAcqTimeIntentShared { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),
  },
}
