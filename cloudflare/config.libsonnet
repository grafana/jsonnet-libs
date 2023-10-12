{
  _config+:: {
    dashboardTags: ['cloudflare-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsHighThreatCount: 3,  // count
    alertsHighRequestRate: 150,  // percentage
    alertsHighHTTPErrorCodeCount: 100,  // count
  },
}
