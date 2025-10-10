{
  local this = self,
  filteringSelector: 'job=~"integrations/presto"',
  groupLabels: ['job', 'cluster', 'presto_cluster'],
  instanceLabels: ['instance'],
  uid: 'presto',

  dashboardNamePrefix: 'Presto',
  dashboardTags: ['presto-mixin'],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Data source configuration
  metricsSource: 'prometheus',
  enableLokiLogs: true,
  logLabels: this.groupLabels + this.instanceLabels,
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alerts configuration
  alertsHighInsufficientResourceErrors: 0,  // count
  alertsHighTaskFailuresWarning: 0,  // count
  alertsHighTaskFailuresCritical: 30,  // percent
  alertsHighQueuedTaskCount: 5,  // count
  alertsHighBlockedNodesCount: 0,  // count
  alertsHighFailedQueryCountWarning: 0,  // count
  alertsHighFailedQueryCountCritical: 30,  // percent

  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    coordinator: (import './signals/coordinator.libsonnet')(this),
    worker: (import './signals/worker.libsonnet')(this),

  },
}
