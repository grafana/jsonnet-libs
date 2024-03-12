{
  _config+:: {
    enableMultiCluster: false,
    couchDBSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    multiclusterSelector: 'job=~"$job"',

    dashboardTags: ['apache-couchdb-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    alertsCriticalClusterIsUnstable5m: 1,  //1 is stable
    alertsWarning4xxResponseCodes5m: 5,
    alertsCritical5xxResponseCodes5m: 0,
    alertsWarningRequestLatency5m: 500,  //ms
    alertsCriticalRequestLatency5m: 1000,  //ms
    alertsWarningPendingReplicatorJobs5m: 10,
    alertsCriticalCrashingReplicatorJobs5m: 0,
    alertsWarningDyingReplicatorChangesQueues5m: 0,
    alertsWarningCrashingReplicatorConnectionOwners5m: 0,
    alertsWarningCrashingReplicatorConnectionWorkers5m: 0,

    enableLokiLogs: true,
  },
}
