local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(panels, type):: {
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
        panels.problems.longRunningQueries { gridPos+: { w: 8, h: 4 } },
        panels.problems.blockedQueries { gridPos+: { w: 8, h: 4 } },
        panels.problems.idleInTransaction { gridPos+: { w: 8, h: 4 } },
        // Line 2: Problem indicators (3 panels x 8 = 24)
        panels.problems.walArchiveFailures { gridPos+: { w: 8, h: 4 } },
        panels.problems.checkpointWarnings { gridPos+: { w: 8, h: 4 } },
        panels.problems.lockUtilization { gridPos+: { w: 8, h: 4 } },
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
        panels.maintenance.tablesNeedingVacuum { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.oldestVacuum { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.sequentialScanRatio { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.unusedIndexes { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.databaseSize { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.walSize { gridPos+: { w: 4, h: 4 } },
        panels.maintenance.deadTupleRatio { gridPos+: { w: 12, h: 8 } },
        panels.maintenance.tableVacuumStatus { gridPos+: { w: 12, h: 8 } },
        panels.maintenance.databaseSizeTimeSeries { gridPos+: { w: 24, h: 6 } },
      ]),

    // Tier 5: Query Analysis - Root cause (separate dashboard)
    queries:
      g.panel.row.new('Query Analysis')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.queries.topQueriesByTotalTime { gridPos+: { w: 12, h: 8 } },
        panels.queries.slowestQueriesByMeanTime { gridPos+: { w: 12, h: 8 } },
        panels.queries.mostFrequentQueries { gridPos+: { w: 12, h: 8 } },
        panels.queries.queriesUsingTempFiles { gridPos+: { w: 12, h: 8 } },
        panels.queries.queryStatsTable { gridPos+: { w: 24, h: 10 } },
      ]),
  },
}
