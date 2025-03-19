{
  _config+:: {
    enableMultiCluster: false,
    cassandraSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    multiclusterSelector: 'job=~"$job"',

    dashboardTags: ['apache-cassandra-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    alertsCriticalReadLatency5m: 200,  //ms
    alertsCriticalWriteLatency5m: 200,  //ms
    alertsWarningPendingCompactionTasks15m: 30,
    alertsCriticalBlockedCompactionTasks5m: 1,
    alertsWarningHintsStored1m: 1,
    alertsCriticalUnavailableWriteRequests5m: 1,
    alertsCriticalHighCpuUsage5m: 80,  //percent: emitted metric has range 0-100
    alertsCriticalHighMemoryUsage5m: 80,  //percent: calculated as ratio then multiplied by query

    enableLokiLogs: true,
    enableDatacenterLabel: false,
    enableRackLabel: false,
  },
}
