{
  _config+:: {
    local this = self,
    dashboardTags: ['pinecone'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    dashboardNamePrefix: 'Pinecone',
    uid: 'pinecone',
    
    // Filtering and labels
    filteringSelector: 'job=~"prometheus.scrape.pinecone_metrics"', 
    groupLabels: [],  // Options: ['cloud'], ['region'], ['cloud', 'region'], or [] for single cloud/region
    instanceLabels: ['index_name'],  // Each index is an instance
    
    // Metrics source
    metricsSource: ['prometheus'],
    
    // Signals
    signals: {
      operations: (import './signals/operations.libsonnet')(this),
      overview: (import './signals/overview.libsonnet')(this),
    },
    
    // Feature flags
    enableLokiLogs: false,

  },
}


