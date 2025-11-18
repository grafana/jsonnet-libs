local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    //
    // Cluster Overview dashboard rows
    //

    clusterOverviewShardRow:
      g.panel.row.new('Shard')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.shardNodesTable { gridPos+: { w: 24 } },
      ]),

    clusterOverviewConfigRow:
      g.panel.row.new('Config')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.configNodesTable { gridPos+: { w: 24 } },
      ]),

    clusterOverviewMongosRow:
      g.panel.row.new('mongos')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.mongosNodesTable { gridPos+: { w: 24 } },
      ]),

    clusterOverviewPerformanceRow:
      g.panel.row.new('Performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.hardwareIO { gridPos+: { w: 12 } },
        panels.hardwareIOWaitTime { gridPos+: { w: 12 } },
        panels.hardwareCPUInterruptServiceTime { gridPos+: { w: 12 } },
        panels.memoryUsed { gridPos+: { w: 12 } },
        panels.diskSpaceUsage { gridPos+: { w: 24 } },
        panels.networkRequests { gridPos+: { w: 12 } },
        panels.networkThroughput { gridPos+: { w: 12 } },
        panels.slowRequests { gridPos+: { w: 24 } },
      ]),

    clusterOverviewOperationsRow:
      g.panel.row.new('Operations')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.connections { gridPos+: { w: 24 } },  // TODO position this in the correct place
        panels.readwriteOperations { gridPos+: { w: 12 } },
        panels.operations { gridPos+: { w: 12 } },
        panels.readwriteLatency { gridPos+: { w: 24 } },
      ]),

    clusterOverviewLocksRow:
      g.panel.row.new('Locks')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.currentQueue { gridPos+: { w: 12 } },
        panels.activeClientOperations { gridPos+: { w: 12 } },
        panels.databaseDeadlocks { gridPos+: { w: 12 } },
        panels.databaseWaitsAcquiringLock { gridPos+: { w: 12 } },
      ]),

    //
    // Elections Overview dashboard rows
    //

    electionsRow:
      g.panel.row.new('Elections')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.stepUpElectionsCalled { gridPos+: { w: 12 } },
        panels.priorityElections { gridPos+: { w: 12 } },
        panels.takeoverElections { gridPos+: { w: 12 } },
        panels.timeoutElections { gridPos+: { w: 12 } },
      ]),


    electionsCatchUpsRow:
      g.panel.row.new('Catch-ups')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.catchUpsTotal { gridPos+: { w: 12 } },
        panels.catchUpsSkipped { gridPos+: { w: 12 } },
        panels.catchUpsSucceeded { gridPos+: { w: 12 } },
        panels.catchUpsFailed { gridPos+: { w: 12 } },
        panels.catchUpsTimedOut { gridPos+: { w: 12 } },
        panels.averageCatchUpOps { gridPos+: { w: 12 } },
      ]),

    //
    // Operations overview dashboard rows
    //

    operationsRow:
      g.panel.row.new('Operations')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.queryOperations { gridPos+: { w: 12 } },
        panels.insertOperations { gridPos+: { w: 12 } },
        panels.updateOperations { gridPos+: { w: 12 } },
        panels.deleteOperations { gridPos+: { w: 12 } },
      ]),

    operationsConnectionsRow:
      g.panel.row.new('Connections')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.currentConnectionsOperations { gridPos+: { w: 12 } },
        panels.activeConnectionsOperations { gridPos+: { w: 12 } },
      ]),

    operationsReadWriteRow:
      g.panel.row.new('Read/Write operations')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.readwriteOperationsOperations { gridPos+: { w: 12 } },
        panels.readwriteLatencyOperations { gridPos+: { w: 12 } },
      ]),

    operationsLocksRow:
      g.panel.row.new('Locks')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.databaseDeadlocksOperations { gridPos+: { w: 8 } },
        panels.databaseWaitCountOperations { gridPos+: { w: 8 } },
        panels.databaseWaitTimeOperations { gridPos+: { w: 8 } },
        panels.collectionDeadlocksOperations { gridPos+: { w: 8 } },
        panels.collectionWaitCountOperations { gridPos+: { w: 8 } },
        panels.collectionWaitTimeOperations { gridPos+: { w: 8 } },
      ]),

    //
    // Performance overview dashboard rows
    //

    performanceMemoryHardwareRow:
      g.panel.row.new('Memory and hardware')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.memoryPerformance { gridPos+: { w: 12 } },
        panels.hardwareCPUInterruptServiceTimePerformance { gridPos+: { w: 12 } },
      ]),

    performanceDiskRow:
      g.panel.row.new('Disk')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.diskSpacePerformance { gridPos+: { w: 12 } },
        panels.diskSpaceUtilizationPerformance { gridPos+: { w: 12 } },
      ]),

    performanceNetworkRow:
      g.panel.row.new('Network')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.networkRequestsPerformance { gridPos+: { w: 12 } },
        panels.slowNetworkRequestsPerformance { gridPos+: { w: 12 } },
        panels.networkThroughputPerformance { gridPos+: { w: 24 } },
      ]),

    performanceHardwareIORow:
      g.panel.row.new('Hardware I/O')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.hardwareIOPerformance { gridPos+: { w: 24 } },
        panels.hardwareIOWaitTimePerformance { gridPos+: { w: 24 } },
      ]),

    performanceConnectionsRow:
      g.panel.row.new('Connections')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.currentConnections { gridPos+: { w: 12 } },
        panels.activeConnections { gridPos+: { w: 12 } },
      ]),

    performanceDbLocksClusterRow:
      g.panel.row.new('Database lock deadlocks - cluster')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.dbLockDeadlocksExclusive { gridPos+: { w: 12 } },
        panels.dbLockDeadlocksIntentExclusive { gridPos+: { w: 12 } },
        panels.dbLockDeadlocksShared { gridPos+: { w: 12 } },
        panels.dbLockDeadlocksIntentShared { gridPos+: { w: 12 } },
      ]),

    performanceDbLocksInstanceRow:
      g.panel.row.new('Database lock deadlocks - instance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.dbLockDeadlocksExclusiveByInstance { gridPos+: { w: 12 } },
        panels.dbLockDeadlocksIntentExclusiveByInstance { gridPos+: { w: 12 } },
        panels.dbLockDeadlocksSharedByInstance { gridPos+: { w: 12 } },
        panels.dbLockDeadlocksIntentSharedByInstance { gridPos+: { w: 12 } },
      ]),

    performanceDbWaitCountsClusterRow:
      g.panel.row.new('Database lock wait counts - cluster')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.dbLockWaitCountExclusive { gridPos+: { w: 12 } },
        panels.dbLockWaitCountIntentExclusive { gridPos+: { w: 12 } },
        panels.dbLockWaitCountShared { gridPos+: { w: 12 } },
        panels.dbLockWaitCountIntentShared { gridPos+: { w: 12 } },
      ]),

    performanceDbWaitCountsInstanceRow:
      g.panel.row.new('Database lock wait counts - instance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.dbLockWaitCountExclusiveByInstance { gridPos+: { w: 12 } },
        panels.dbLockWaitCountIntentExclusiveByInstance { gridPos+: { w: 12 } },
        panels.dbLockWaitCountSharedByInstance { gridPos+: { w: 12 } },
        panels.dbLockWaitCountIntentSharedByInstance { gridPos+: { w: 12 } },
      ]),

    performanceDbAcqTimeRow:
      g.panel.row.new('Database lock acquisition time')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.dbLockAcqTimeExclusive { gridPos+: { w: 12 } },
        panels.dbLockAcqTimeIntentExclusive { gridPos+: { w: 12 } },
        panels.dbLockAcqTimeShared { gridPos+: { w: 12 } },
        panels.dbLockAcqTimeIntentShared { gridPos+: { w: 12 } },
      ]),

    performanceCollLocksRow:
      g.panel.row.new('Collection lock deadlocks')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.collLockDeadlocksExclusive { gridPos+: { w: 12 } },
        panels.collLockDeadlocksIntentExclusive { gridPos+: { w: 12 } },
        panels.collLockDeadlocksShared { gridPos+: { w: 12 } },
        panels.collLockDeadlocksIntentShared { gridPos+: { w: 12 } },
      ]),

    performanceCollWaitCountsRow:
      g.panel.row.new('Collection lock wait counts')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.collLockWaitCountExclusive { gridPos+: { w: 12 } },
        panels.collLockWaitCountIntentExclusive { gridPos+: { w: 12 } },
        panels.collLockWaitCountShared { gridPos+: { w: 12 } },
        panels.collLockWaitCountIntentShared { gridPos+: { w: 12 } },
      ]),

    performanceCollAcqTimeRow:
      g.panel.row.new('Collection lock acquisition time')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.collLockAcqTimeExclusive { gridPos+: { w: 12 } },
        panels.collLockAcqTimeIntentExclusive { gridPos+: { w: 12 } },
        panels.collLockAcqTimeShared { gridPos+: { w: 12 } },
        panels.collLockAcqTimeIntentShared { gridPos+: { w: 12 } },
      ]),

    //
    // Sharding overview dashboard rows
    //

    shardingGeneralStatsRow:
      g.panel.row.new('General sharding statistics')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.staleConfigErrors { gridPos+: { w: 12 } },
        panels.chunkMigrations { gridPos+: { w: 12 } },
        panels.docsCloned { gridPos+: { w: 12 } },
        panels.criticalSectionTime { gridPos+: { w: 12 } },
      ]),

    shardingCatalogCacheRow:
      g.panel.row.new('Catalog cache')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.catalogCacheRefreshesStarted { gridPos+: { w: 12 } },
        panels.catalogCacheRefreshesFailed { gridPos+: { w: 12 } },
        panels.catalogCacheStaleConfigs { gridPos+: { w: 6 } },
        panels.catalogCacheEntries { gridPos+: { w: 6 } },
        panels.catalogCacheRefreshTime { gridPos+: { w: 6 } },
        panels.catalogCacheOperationsBlocked { gridPos+: { w: 6 } },
      ]),

    shardingOperationsRow:
      g.panel.row.new('Shard operations')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.shardTargetingAllShards { gridPos+: { w: 12 } },
        panels.shardTargetingManyShards { gridPos+: { w: 12 } },
        panels.shardTargetingOneShard { gridPos+: { w: 12 } },
        panels.shardTargetingUnsharded { gridPos+: { w: 12 } },
      ]),
  },
}
