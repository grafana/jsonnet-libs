{
  _config+:: {
    enableMultiCluster: false,
    solrSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    multiclusterSelector: 'job=~"$job"',
    filterSelector: 'job=~"integrations/apache-solr"',
    logLabels: if self.enableMultiCluster then ['job', 'cluster', 'solr_cluster', 'instance', 'level', 'filename']
    else ['job', 'solr_cluster', 'instance', 'level', 'filename'],

    dashboardTags: ['apache-solr-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsCriticalCPUUsage: 85,
    alertsWarningCPUUsage: 75,
    alertsWarningMemoryUsage: 85,
    alertsCriticalMemoryUsage: 75,
    alertsWarningCacheUsage: 75,
    alertsWarningCoreErrors: 15,
    alertsWarningDocumentIndexing: 30,

    enableLokiLogs: true,
  },
}
