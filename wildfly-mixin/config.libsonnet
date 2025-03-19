{
  _config+:: {
    enableMultiCluster: false,
    multiclusterSelector: 'job=~"$job"',
    wildflySelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    dashboardTags: ['wildfly-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsErrorRequestErrorRate: '30',
    alertsErrorRejectedSessions: '20',

    enableLokiLogs: true,
  },
}
