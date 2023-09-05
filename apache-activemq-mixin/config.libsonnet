{
  _config+:: {
    dashboardTags: ['apache-activemq-mixin'],
    dashboardPeriod: 'now-1h',
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

    enableLokiLogs: false,
    filterSelector: 'job=~"integrations/activemq"',
  },
}
