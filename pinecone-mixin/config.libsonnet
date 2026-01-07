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
  groupLabels: ['cloud', 'region', 'job'],
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
  alertsQueryLatencySimpleWarningMs: 125,  // Suggested range: 100-125ms for simple queries
  alertsQueryLatencySimpleCriticalMs: 300,  // Suggested range: 200-300ms for simple queries

  alertsUpsertLatencyWarningMs: 250,  // Sustained latency threshold
  alertsUpsertLatencyCriticalMs: 500,  // Sustained latency threshold

  // Saturation alert thresholds
  alertsSaturationIndexFullnessWarning: 70,  // Index fullness percentage (0-100 scale)
  alertsSaturationIndexFullnessCritical: 85,  // Index fullness percentage (0-100 scale)
  alertsSaturationStorageUsageWarning: 75,  // Percentage of allowed storage size
  alertsSaturationStorageGrowthCritical: 25,  // Storage growth percentage over 1 hour

  // Unit burn-down alert thresholds
  // Baseline increase thresholds as integer percentages (130 = 130% of baseline = 30% increase)
  alertsUnitBurnDownBaselineIncreaseWarning: 130,  // Percentage above 30-min baseline
  alertsUnitBurnDownBudgetUsageWarning: 80,  // Percentage of allocated budget
}
