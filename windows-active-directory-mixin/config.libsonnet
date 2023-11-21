{
  _config+:: {
    dashboardTags: ['windows-active-directory-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    filterSelector: 'job=~"integrations/windows"',
    // alerts thresholds
    alertsWarningHighReplicationIssues: 0,  // count
    alertsWarningHighBindOperations: 20,  // %
    alertsWarningHighPasswordChanges: 25,  // count
    alertsCriticalMetricsDownJobName: 'integrations/windows',

    enableLokiLogs: true,
  },
}
