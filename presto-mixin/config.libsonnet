{
  _config+:: {
    filterSelector: 'job=~"integrations/presto"',

    dashboardTags: ['presto-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsHighInsufficientResourceErrors: 0,  // count
    alertsHighTaskFailuresWarning: 0,  // count
    alertsHighTaskFailuresCritical: 30,  // percent
    alertsHighQueuedTaskCount: 5,  // count
    alertsHighBlockedNodesCount: 0,  // count
    alertsHighFailedQueryCountWarning: 0,  // count
    alertsHighFailedQueryCountCritical: 30,  // percent
    enableLokiLogs: true,
  },
}
