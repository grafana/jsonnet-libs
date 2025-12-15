{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="bar"
  groupLabels: ['job', 'couchdb_cluster', 'cluster'],
  logLabels: ['job', 'cluster', 'instance'],
  instanceLabels: ['instance'],

  dashboardTags: ['apache-couchdb-mixin'],
  uid: 'couchdb',
  dashboardNamePrefix: 'Apache CouchDB',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: [
    'prometheus',
    /*
    * the prometheusWithTotal is used for backwards compatibility as some metrics are suffixed with _total but in later versions of the couchdb-mixin.
    * i.e. couchdb_open_os_files_total => couchdb_open_os_files
    * This is to ensure that the signals for the metrics that are suffixed with _total continue to work as expected.
    * This was an identified as a noticeable change from 3.3.0 to 3.5.0
    */
    'prometheusWithTotal',
  ],

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

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

  // Signals configuration
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    nodes: (import './signals/nodes.libsonnet')(this),
    replicator: (import './signals/replicator.libsonnet')(this),
  },
}
