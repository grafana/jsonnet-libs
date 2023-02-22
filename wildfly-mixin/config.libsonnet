{
  _config+:: {
    dashboardTags: ['wildfly-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsErrorRequestErrorRate: '30',
    alertsErrorRejectedSessions: '20',

    enableLokiLogs: true,
  },
}