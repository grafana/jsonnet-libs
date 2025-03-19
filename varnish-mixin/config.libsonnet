{
  _config+:: {
    dashboardTags: ['varnish-cache-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    alertsWarningCacheHitRate: 80,  //%
    alertsWarningHighMemoryUsage: 90,  //%
    alertsCriticalCacheEviction: 0,
    alertsWarningHighSaturation: 0,
    alertsCriticalSessionsDropped: 0,
    alertsCriticalBackendUnhealthy: 0,
    enableLokiLogs: true,
    enableMultiCluster: false,
    multiclusterSelector: 'job=~"$job"',
    varnishSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
  },
}
