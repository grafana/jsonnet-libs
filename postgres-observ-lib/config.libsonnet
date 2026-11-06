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
  alertHighConnectionUsageWarningThreshold: 80,  // > percent of max_connections

  alertLowCacheHitRatioWarningThreshold: 90,  // < percent

  alertReplicationLagWarningThreshold: 30,  // > seconds
  alertReplicationLagCriticalThreshold: 3600,  // > seconds

  alertDeadlocksWarningThreshold: 1,  // > deadlocks in 5 minutes

  alertLongRunningQueryWarningThreshold: 300,  // > seconds

  alertBlockedQueriesWarningThreshold: 1,  // > queries

  alertHighDeadTuplesWarningThreshold: 10,  // > percent of tuples that are dead
  alertHighDeadTuplesMinDeadTuples: 10000,  // > dead tuples

  alertVacuumNotRunningWarningThreshold: 7,  // > days
  alertVacuumNotRunningDeadTuples: 10000,  // > dead tuples

  alertTooManyRollbacksWarningThreshold: 10,  // > percent of transactions rolled back

  alertTooManyLocksAcquiredWarningThreshold: 20,  // > percent of the lock table size

  alertHighQpsWarningThreshold: 10000,  // > transactions per second
}
