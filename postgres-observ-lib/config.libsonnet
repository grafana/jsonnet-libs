{
  // Filtering and labels
  // filteringSelector: used in dashboard queries (empty = uses only $job/$instance from groupLabels/instanceLabels)
  // alertsFilteringSelector: used in alert rules (no Grafana variables available)
  filteringSelector: '',
  alertsFilteringSelector: 'job=~".+", instance=~".+"',
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

  // Alert thresholds
  alerts: {
    connectionUtilization: {
      warn: 80,  // percentage
      critical: 95,
    },
    cacheHitRatio: {
      warn: 90,  // percentage, below this triggers warning
    },
    replicationLag: {
      warn: 30,  // seconds
      critical: 3600,  // 1 hour (from upstream)
    },
    deadlocks: {
      warn: 1,  // per 5m window
    },
    longRunningQuery: {
      warn: 300,  // seconds (5 minutes)
    },
    blockedQueries: {
      warn: 1,  // count
    },
    deadTupleRatio: {
      warn: 10,  // percentage
      critical: 20,
    },
    vacuumAge: {
      warn: 7,  // days since last vacuum
    },
    // From upstream postgres_mixin
    rollbackRatio: {
      warn: 10,  // percentage, above this triggers warning
    },
    lockUtilization: {
      warn: 20,  // percentage of max locks
    },
    qps: {
      warn: 10000,  // queries per second
    },
  },
}
