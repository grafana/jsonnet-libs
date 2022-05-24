{
  _config+:: {
    dashboardTags: ['apache-http-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // for alerts
    alertsWarningWorkersBusy: '80',  // %
    alertsWarningResponseTimeMs: '5000',  // ms

    // enable Loki logs
    enableLokiLogs: false,
  },
}
