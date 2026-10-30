{
  // Filtering and labels
  filteringSelector: '',
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],

  // Dashboard settings
  uid: 'postgres',
  dashboardNamePrefix: '',
  dashboardTags: ['postgres', 'database'],

  // Metrics source - extensible pattern for future sources
  // Currently only 'postgres_exporter' (prometheus community exporter) is implemented
  metricsSource: ['postgres_exporter'],

  // Feature flags
  enableQueryAnalysis: true,  // Requires pg_stat_statements extension

  // Alerts
  alertDownSeverity: 'critical',
  alertHighConnectionUsageThreshold: 0.8,
  alertHighConnectionUsageSeverity: 'warning',
  alertLowCacheHitRatioThreshold: 0.9,
  alertLowCacheHitRatioSeverity: 'warning',
  alertReplicationLagThreshold: 30,
  alertReplicationLagSeverity: 'warning',
  alertReplicationLagCriticalThreshold: 3600,
  alertReplicationLagCriticalSeverity: 'critical',
  alertDeadlocksThreshold: 1,
  alertDeadlocksSeverity: 'warning',
  alertLongRunningQueryThreshold: 300,
  alertLongRunningQuerySeverity: 'warning',
  alertBlockedQueriesThreshold: 1,
  alertBlockedQueriesSeverity: 'warning',
  alertWALArchiveFailureSeverity: 'critical',
  alertHighDeadTuplesThreshold: 0.1,
  alertHighDeadTuplesSeverity: 'warning',
  alertVacuumNotRunningThreshold: 7 * 86400,
  alertVacuumNotRunningDeadTuples: 10000,
  alertVacuumNotRunningSeverity: 'warning',
  alertTooManyRollbacksThreshold: 0.1,
  alertTooManyRollbacksSeverity: 'warning',
  alertTooManyLocksAcquiredThreshold: 0.2,
  alertTooManyLocksAcquiredSeverity: 'warning',
  alertInactiveReplicationSlotSeverity: 'critical',
  alertReplicationRoleChangedSeverity: 'warning',
  alertExporterErrorsSeverity: 'critical',
  alertHighQpsThreshold: 10000,
  alertHighQpsSeverity: 'warning',
}
