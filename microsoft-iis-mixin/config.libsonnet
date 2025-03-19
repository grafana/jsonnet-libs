{
  _config+:: {
    dashboardTags: ['microsoft-iis-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsWarningHighRejectedAsyncIORequests: 20,
    alertsCriticalHigh5xxRequests: 5,
    alertsCriticalLowWebsocketConnectionSuccessRate: 80,
    alertsCriticalHighThreadPoolUtilization: 90,
    alertsWarningHighWorkerProcessFailures: 10,

    enableLokiLogs: true,
  },
}
