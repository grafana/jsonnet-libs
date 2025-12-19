{
  local this = self,
  dashboardTags: ['pinecone'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  dashboardNamePrefix: 'Pinecone',
  uid: 'pinecone',

  // Filtering and labels
  filteringSelector: 'job=~"$job"',
  groupLabels: ['job'],  // Job label for filtering
  instanceLabels: ['instance', 'index_name'],  // Instance and index_name labels

  // Metrics source
  metricsSource: ['prometheus'],

  // Signals
  signals: {
    operations: (import './signals/operations.libsonnet')(this),
    overview: (import './signals/overview.libsonnet')(this),
  },

  // Feature flags
  enableLokiLogs: false,
}
