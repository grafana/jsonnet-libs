{
  _config+:: {
    dashboardTags: ['f5-bigip-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    defaultRateInterval: '1m',

    // alerts thresholds
    alertsCriticalNodeAvailability: 95,  // %
    alertsWarningServerSideConnectionLimit: 80,  // %
    alertsCriticalHighRequestRate: 150,  // %
    alertsCriticalHighConnectionQueueDepth: 75,  // %

    enableLokiLogs: false,
    filterSelector: 'job=~"syslog"',
  },
}
