{
  _config+:: {
    dashboardTags: ['squid'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsCriticalHighPercentageRequestErrors: 5,
    alertsWarningLowCacheHitRatio: 85,
    enableLokiLogs: true,
  },
}
