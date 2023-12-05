{
  _config+:: {
    enableMultiCluster: false,
    influxdbSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    multiclusterSelector: 'job=~"$job"',
    filterSelector: 'job=~"integrations/influxdb"',

    dashboardTags: ['influxdb-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsWarningTaskSchedulerHighFailureRate: 25,  // %
    alertsCriticalTaskSchedulerHighFailureRate: 50,  // %
    alertsWarningHighBusyWorkerPercentage: 80,  // %
    alertsWarningHighHeapMemoryUsage: 80,  // %
    alertsWarningHighAverageAPIRequestLatency: 0.3,  // count
    alertsWarningSlowAverageIQLExecutionTime: 0.1,  // count

    enableLokiLogs: true,
  },
}
