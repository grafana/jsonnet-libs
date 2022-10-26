{
  _config+:: {
    dashboardTags: ['discourse-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // for alerts
    alertsCritical5xxResponses: '10',  // %
    alertsError4xxResponses: '30',  // %
  },
}
