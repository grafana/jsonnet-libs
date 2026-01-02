{
  local this = self,
  dashboardTags: ['pinecone'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  dashboardNamePrefix: 'Pinecone',
  uid: 'pinecone',

  // Filtering and labels
  filteringSelector: '',
  groupLabels: ['job'],
  instanceLabels: ['instance', 'index_name'],

  // Metrics source
  metricsSource: ['prometheus'],

  // Signals
  signals: {
    operations: (import './signals/operations.libsonnet')(this),
    overview: (import './signals/overview.libsonnet')(this),
  },

  // Feature flags
  enableLokiLogs: false,

  // Alert thresholds
  alertsQueryLatencySimpleWarningMs: 125,  // 100-125ms for simple queries (using 125ms)
  alertsQueryLatencySimpleCriticalMs: 300,  // 200-300ms for simple queries (using 300ms)

  alertsUpsertLatencyWarningMs: 250,  // 250ms sustained
  alertsUpsertLatencyCriticalMs: 500,  // 500ms sustained

  // Saturation alert thresholds
  alertsSaturationIndexFullnessWarning: 70,  // 70% index fullness (0-100 scale)
  alertsSaturationIndexFullnessCritical: 85,  // 85% index fullness (0-100 scale)
  alertsSaturationStorageUsageWarning: 75,  // 75% of allowed storage size
  alertsSaturationStorageGrowthCritical: 25,  // 25% storage growth over 1 hour

  // Unit burn-down alert thresholds
  // Baseline increase thresholds as integer percentages (130 = 130% of baseline = 30% increase)
  alertsUnitBurnDownBaselineIncreaseWarning: 130,  // 30% above 30-min baseline (130% of baseline)
  alertsUnitBurnDownBudgetUsageWarning: 80,  // 80% of allocated budget (set to 0 to disable budget check if no budget metric exists)
}
