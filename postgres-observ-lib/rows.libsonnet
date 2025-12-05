local g = import './g.libsonnet';

{
  new(panels, type):: {
    // ============================================
    // CLUSTER DASHBOARD ROWS
    // ============================================

    // Cluster Health At-a-Glance
    clusterHealth:
      g.panel.row.new('Cluster Health')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        // Line 1: Status indicators (6 panels x 4 = 24)
        panels.cluster.clusterStatus { gridPos+: { w: 4, h: 4 } },
        panels.cluster.totalInstances { gridPos+: { w: 4, h: 4 } },
        panels.cluster.upInstances { gridPos+: { w: 4, h: 4 } },
        panels.cluster.primaryCount { gridPos+: { w: 4, h: 4 } },
        panels.cluster.replicaCount { gridPos+: { w: 4, h: 4 } },
        panels.cluster.maxReplicationLag { gridPos+: { w: 4, h: 4 } },
        // Line 2: Gauges and deadlocks (3 panels)
        panels.cluster.worstCacheHitRatio { gridPos+: { w: 8, h: 6 } },
        panels.cluster.worstConnectionUtilization { gridPos+: { w: 8, h: 6 } },
        panels.cluster.totalDeadlocks { gridPos+: { w: 8, h: 6 } },
      ]),

    // Cluster Instances Table with Role History
    clusterInstances:
      g.panel.row.new('Cluster Instances')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        // Line 1: Instance table + Role history (split 50/50)
        panels.cluster.instanceTable { gridPos+: { w: 12, h: 8 } },
        panels.cluster.primaryRoleHistory { gridPos+: { w: 12, h: 8 } },
        // Line 2: Failover events (full width)
        panels.cluster.failoverEvents { gridPos+: { w: 24, h: 6 } },
      ]),

    // Replication Topology
    clusterReplication:
      g.panel.row.new('Replication')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.cluster.replicationLagTimeSeries { gridPos+: { w: 8, h: 8 } },
        panels.cluster.replicationSlotLagTimeSeries { gridPos+: { w: 8, h: 8 } },
        panels.cluster.walPositionTimeSeries { gridPos+: { w: 8, h: 8 } },
      ]),

    // Cluster Problems - High visibility row for active issues
    clusterProblems:
      g.panel.row.new('Cluster Problems')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        // Problem stats (6 panels x 4 = 24, taller for visibility)
        panels.cluster.totalLongRunningQueries { gridPos+: { w: 4, h: 6 } },
        panels.cluster.totalBlockedQueries { gridPos+: { w: 4, h: 6 } },
        panels.cluster.totalIdleInTransaction { gridPos+: { w: 4, h: 6 } },
        panels.cluster.totalWalArchiveFailures { gridPos+: { w: 4, h: 6 } },
        panels.cluster.worstLockUtilization { gridPos+: { w: 4, h: 6 } },
        panels.cluster.totalExporterErrors { gridPos+: { w: 4, h: 6 } },
      ]),

    // Read/Write Split
    clusterReadWrite:
      g.panel.row.new('Throughput & Read/Write Split')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        // First row: TPS and QPS
        panels.cluster.tpsByInstance { gridPos+: { w: 12, h: 8 } },
        panels.cluster.qpsByInstance { gridPos+: { w: 12, h: 8 } },
        // Second row: Read/Write split
        panels.cluster.writeOperations { gridPos+: { w: 8, h: 8 } },
        panels.cluster.readOperations { gridPos+: { w: 8, h: 8 } },
        panels.cluster.readWriteRatio { gridPos+: { w: 8, h: 8 } },
      ]),

    // Cluster Resources
    clusterResources:
      g.panel.row.new('Cluster Resources')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.cluster.totalConnectionsTimeSeries { gridPos+: { w: 12, h: 8 } },
        panels.cluster.cacheHitRatioByInstanceTimeSeries { gridPos+: { w: 12, h: 8 } },
        panels.cluster.totalDatabaseSize { gridPos+: { w: 12, h: 8 } },
        panels.cluster.walPositionTimeSeries { gridPos+: { w: 12, h: 8 } },
      ]),

    // ============================================
    // INSTANCE DASHBOARD ROWS (existing)
    // ============================================

    // Tier 1: Critical Health - Always visible at top
    health:
      g.panel.row.new('Health')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        // Line 1: Core status (6 panels x 4 = 24)
        panels.health.up { gridPos+: { w: 4, h: 4 } },
        panels.health.uptime { gridPos+: { w: 4, h: 4 } },
        panels.health.nodeRole { gridPos+: { w: 4, h: 4 } },
        panels.health.connectionUtilizationStat { gridPos+: { w: 4, h: 4 } },
        panels.health.cacheHitRatioStat { gridPos+: { w: 4, h: 4 } },
        panels.health.deadlocks { gridPos+: { w: 4, h: 4 } },
        // Line 2: Replication (3 panels x 8 = 24)
        panels.health.replicationLag { gridPos+: { w: 8, h: 4 } },
        panels.health.connectedReplicas { gridPos+: { w: 8, h: 4 } },
        panels.health.replicationSlotLag { gridPos+: { w: 8, h: 4 } },
        // Line 3: Gauges (2 panels x 12 = 24)
        panels.health.connectionUtilization { gridPos+: { w: 12, h: 6 } },
        panels.health.cacheHitRatio { gridPos+: { w: 12, h: 6 } },
      ]),

    // Tier 2: Active Problems - Expands when issues exist
    problems:
      g.panel.row.new('Active Problems')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        // Line 1: Problem indicators (3 panels x 8 = 24)
        panels.problems.longRunningQueries { gridPos+: { w: 8, h: 6 } },
        panels.problems.blockedQueries { gridPos+: { w: 8, h: 6 } },
        panels.problems.idleInTransaction { gridPos+: { w: 8, h: 6 } },
        // Line 2: Problem indicators (3 panels x 8 = 24)
        panels.problems.walArchiveFailures { gridPos+: { w: 8, h: 6 } },
        panels.problems.checkpointWarnings { gridPos+: { w: 8, h: 6 } },
        panels.problems.lockUtilization { gridPos+: { w: 8, h: 6 } },
        // Line 3: Problem indicators (3 panels x 8 = 24)
        panels.problems.inactiveReplicationSlots { gridPos+: { w: 8, h: 6 } },
        panels.problems.exporterErrors { gridPos+: { w: 8, h: 6 } },
        panels.problems.conflictsDeadlocks { gridPos+: { w: 8, h: 6 } },
      ]),

    // Tier 3: Performance Trends - Time series
    performance:
      g.panel.row.new('Performance Trends')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.performance.transactionsPerSecond { gridPos+: { w: 12, h: 8 } },
        panels.performance.queriesPerSecond { gridPos+: { w: 12, h: 8 } },
        panels.performance.rowsActivity { gridPos+: { w: 12, h: 8 } },
        panels.performance.connectionUtilizationTimeSeries { gridPos+: { w: 12, h: 8 } },
        panels.performance.cacheHitRatioTimeSeries { gridPos+: { w: 12, h: 8 } },
        panels.performance.buffersActivity { gridPos+: { w: 12, h: 8 } },
        panels.performance.diskReads { gridPos+: { w: 12, h: 8 } },
        panels.performance.tempBytesWritten { gridPos+: { w: 12, h: 8 } },
        panels.performance.checkpointDuration { gridPos+: { w: 12, h: 8 } },
      ]),

    // Tier 4: Maintenance - Actionable tasks
    maintenance:
      g.panel.row.new('Maintenance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        // Row 1: Stat cards - Vacuum | Index | Storage
        panels.maintenance.tablesNeedingVacuum { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.oldestVacuum { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.sequentialScanRatio { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.unusedIndexes { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.databaseSize { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.walSize { gridPos+: { w: 4, h: 4 } },
        // Row 2: Time series - Vacuum | Storage
        panels.maintenance.deadTupleRatio { gridPos+: { w: 12, h: 8 } },
        panels.maintenance.databaseSizeTimeSeries { gridPos+: { w: 12, h: 8 } },
        // Row 3: Tables - Vacuum | Index
        panels.maintenance.tableVacuumStatus { gridPos+: { w: 12, h: 8 } },
        panels.maintenance.unusedIndexesTable { gridPos+: { w: 12, h: 8 } },
        // Row 4: Analyze - Stat | Table
        panels.maintenance.oldestAnalyze { gridPos+: { w: 4, h: 8 } },
        panels.maintenance.tableAnalyzeStatus { gridPos+: { w: 20, h: 8 } },
      ]),

    // Tier 5: Query Analysis - Root cause (separate dashboard)
    queries:
      g.panel.row.new('Query Analysis')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.queries.topQueriesByTotalTime { gridPos+: { w: 12, h: 8 } },
        panels.queries.slowestQueriesByMeanTime { gridPos+: { w: 12, h: 8 } },
        panels.queries.mostFrequentQueries { gridPos+: { w: 12, h: 8 } },
        panels.queries.topQueriesByRows { gridPos+: { w: 12, h: 8 } },
        panels.queries.queryStatsTable { gridPos+: { w: 24, h: 10 } },
      ]),

    // Tier 6: Settings - PostgreSQL configuration parameters
    settings:
      g.panel.row.new('PostgreSQL Settings')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.settings.settingsTable { gridPos+: { w: 24, h: 16 } },
      ]),
  },
}
