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
    enableMultiCluster: false,
    multiclusterSelector: 'job=~"$job"',
    squidSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
  },
}
