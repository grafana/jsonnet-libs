{
  _config+:: {
    enableMultiCluster: false,
    activemqSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    activemqAlertsSelector: if self.enableMultiCluster then 'job=~"${job:regex}", cluster=~"${cluster:regex}"' else 'job=~"${job:regex}"',
    dashboardTags: ['apache-activemq-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    grafanaDashboardIDs: {
      'apache-activemq-logs-overview.json': 'apache-activemq-logs',
    },

    // alerts thresholds
    alertsHighTopicMemoryUsage: 70,  // %
    alertsHighQueueMemoryUsage: 70,  // %
    alertsHighStoreMemoryUsage: 70,  // %
    alertsHighTemporaryMemoryUsage: 70,  // %

    enableLokiLogs: true,
    filterSelector: 'job=~"integrations/apache-activemq"',
  },
}
