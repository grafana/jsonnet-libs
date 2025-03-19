{
  _config+:: {
    enableMultiCluster: false,
    prestoOverviewSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    prestoSelector: if self.enableMultiCluster then 'job=~"$job", instance=~"$instance", cluster=~"$cluster"' else 'job=~"$job", instance=~"$instance"',
    prestoAlertSelector: if self.enableMultiCluster then 'job=~"${job:regex}", cluster=~"${cluster:regex}"' else 'job=~"${job:regex}"',
    prestoOverviewLegendSelector: if self.enableMultiCluster then '{{cluster}} - {{presto_cluster}}' else '{{presto_cluster}}',
    prestoLegendSelector: if self.enableMultiCluster then '{{cluster}} - {{instance}}' else '{{instance}}',
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
