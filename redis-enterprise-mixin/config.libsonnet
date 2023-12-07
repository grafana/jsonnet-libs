{
  _config+:: {
    dashboardTags: ['redis-enterprise-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    alertsClusterOutOfMemoryThreshold: 80,  // %
    alertsNodeCPUHighUtilizationThreshold: 80,  // %
    alertsDatabaseHighMemoryUtiliation: 80,  // %
    alertsDatabaseHighLatencyMs: 1000,  // ms
    alertsEvictedObjectsThreshold: 1,

    enableLokiLogs: true,
  },
}
