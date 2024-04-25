{
  _config+:: {
    enableMultiCluster: true,
    clickhouseSelector: if self.enableMultiCluster then 'job=~"$job", instance=~"$instance", cluster=~"$cluster"' else 'job=~"$job", instance=~"$instance"',

    dashboardTags: ['clickhouse-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    logLabels: if self.enableMultiCluster then ['job', 'instance', 'cluster','level']
    else ['job', 'instance', 'level'],

    // for alerts
    alertsReplicasMaxQueueSize: '99',

    filterSelector: 'job=~".*/clickhouse.*"',

    enableLokiLogs: true,
  },
}
