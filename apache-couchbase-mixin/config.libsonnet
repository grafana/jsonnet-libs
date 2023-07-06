{
  _config+:: {
    dashboardTags: ['couchbase-mixin'],
    dashboardPeriod: 'now-3h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsCriticalCPUUsage: 85, // %
    alertsCriticalMemoryUsage: 85,  // %
    alertsWarningMemoryEvictionRate: 10,  // count
    alertsWarningInvalidRequestVolume: 1000,  // count

    enableLokiLogs: true,
  },
}
