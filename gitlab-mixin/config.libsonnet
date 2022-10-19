{
  _config+:: {
    dashboardTags: ['gitlab-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // for alerts
    alertsWarningRegistrationFailures: '10',  // %
    alertsWarningRunnerAuthFailures: '10',  // %
    alertsCritical5xxResponses: '0.1',  // req/s
    alertsWarning4xxResponses: '0.1',  // req/s

    // enable Loki logs
    enableLokiLogs: true,
  },
}
