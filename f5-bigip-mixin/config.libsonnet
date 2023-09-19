{
  _config+:: {
    dashboardTags: ['f5-bigip-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    grafanaLogDashboardIDs: {
      'bigip-logs-overview.json': 'bigip-logs-overview',
    },

    // alerts thresholds
    alertsCriticalNodeAvailability: 95,  // %
    alertsWarningServerSideConnectionLimit: 80,  // %
    alertsCriticalHighRequestRate: 150,  // %
    alertsCriticalHighConnectionQueueDepth: 75,  // %

    enableLokiLogs: true,
    filterSelector: 'job=~"syslog"',
  },
}
