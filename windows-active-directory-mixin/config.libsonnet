{
  _config+:: {
    dashboardTags: ['windows-active-directory-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    filterSelector: 'job=~"integrations/windows"',
    // alerts thresholds
    alertsHighPendingReplicationOperations: 50,  // count
    alertsHighReplicationSyncRequestFailures: 0,
    alertsHighPasswordChanges: 25,
    alertsMetricsDownJobName: 'integrations/windows',
    enableLokiLogs: true,
  },
}
