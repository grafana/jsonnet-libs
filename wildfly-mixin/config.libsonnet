{
  _config+:: {
    local c = self,
    dashboardTags: ['wildfly'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsErrorRequestErrorRate: '.3',
    alertsErrorRejectedSessions: '20',
  },
}