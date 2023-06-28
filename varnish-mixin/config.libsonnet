{
  _config+:: {
    dashboardTags: ['varnish-cache-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    VarnishCacheAlertsWarningCacheHitRate: 80,  //%
    VarnishCacheAlertsCriticalCacheEviction: 0,
    VarnishCacheAlertsCriticalSaturation: 0,
    VarnishCacheAlertsCriticalSessionsDropped: 0,
    VarnishCacheAlertsCriticalBackendFailure: 0,
    VarnishCacheAlertsCriticalBackendUnhealthy: 0,
    enableLokiLogs: true,
  },
}
