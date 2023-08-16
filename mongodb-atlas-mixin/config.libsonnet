{
  _config+:: {
    // sharding dashboard flag
    enableShardingOverview: true,

    dashboardTags: ['mongodb-atlas-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsDeadlocks: 10,  // count
    alertsSlowNetworkRequests: 10,  // count
    alertsHighDiskUsage: 90,  // percentage: 0-100
    alertsSlowHardwareIO: 3,  // seconds
    alertsHighTimeoutElections: 10,  // count

    enableLokiLogs: false,
  },
}
