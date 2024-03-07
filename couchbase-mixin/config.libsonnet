{
  _config+:: {
    enableMultiCluster: false,
    couchbaseSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    dashboardTags: ['couchbase-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsCriticalCPUUsage: 85,  // %
    alertsCriticalMemoryUsage: 85,  // %
    alertsWarningMemoryEvictionRate: 10,  // count
    alertsWarningInvalidRequestVolume: 1000,  // count

    enableLokiLogs: true,
  },
}
