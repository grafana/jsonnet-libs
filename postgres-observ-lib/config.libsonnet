local commonlib = import 'common-lib/common/main.libsonnet';

{
  // Filtering and labels
  filteringSelector: '',
  // Deprecated, use filteringSelector instead.
  alertsFilteringSelector: self.filteringSelector,
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],

  // Dashboard settings
  uid: 'postgres',
  dashboardNamePrefix: '',
  dashboardTags: ['postgres', 'database'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: commonlib.dashboards.defaultTimezone,
  dashboardRefresh: '1m',

  // Metrics source - extensible pattern for future sources
  // Currently only 'postgres_exporter' (prometheus community exporter) is implemented
  metricsSource: ['postgres_exporter'],

  // Feature flags
  enableQueryAnalysis: true,  // Requires pg_stat_statements extension

  // Alerts
  alertDownSeverity: 'critical',
  alertHighConnectionUsageThreshold: 80,  // percent of max_connections
  alertHighConnectionUsageSeverity: 'warning',
  alertLowCacheHitRatioThreshold: 90,  // percent
  alertLowCacheHitRatioSeverity: 'warning',
  alertReplicationLagThreshold: 30,  // seconds
  alertReplicationLagSeverity: 'warning',
  alertReplicationLagCriticalThreshold: 3600,  // seconds
  alertReplicationLagCriticalSeverity: 'critical',
  alertDeadlocksThreshold: 1,  // deadlocks in 5 minutes
  alertDeadlocksSeverity: 'warning',
  alertLongRunningQueryThreshold: 300,  // seconds
  alertLongRunningQuerySeverity: 'warning',
  alertBlockedQueriesThreshold: 1,  // queries
  alertBlockedQueriesSeverity: 'warning',
  alertWALArchiveFailureSeverity: 'critical',
  alertHighDeadTuplesThreshold: 10,  // percent of tuples that are dead
  alertHighDeadTuplesMinDeadTuples: 10000,  // dead tuples
  alertHighDeadTuplesSeverity: 'warning',
  alertVacuumNotRunningThreshold: 7,  // days
  alertVacuumNotRunningDeadTuples: 10000,  // dead tuples
  alertVacuumNotRunningSeverity: 'warning',
  alertTooManyRollbacksThreshold: 10,  // percent of transactions rolled back
  alertTooManyRollbacksSeverity: 'warning',
  alertTooManyLocksAcquiredThreshold: 20,  // percent of the lock table size
  alertTooManyLocksAcquiredSeverity: 'warning',
  alertInactiveReplicationSlotSeverity: 'critical',
  alertReplicationRoleChangedSeverity: 'warning',
  alertExporterErrorsSeverity: 'critical',
  alertHighQpsThreshold: 10000,  // transactions per second
  alertHighQpsSeverity: 'warning',
}
