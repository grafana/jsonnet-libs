{
  local this = self,
  enableMultiCluster: false,
  filteringSelector: 'job=~"$job", cluster=~"$cluster"',
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],
  dashboardTags: ['tensorflow-mixin'],
  uid: 'tensorflow',
  dashboardNamePrefix: 'TensorFlow',

  // additional params
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // logs lib related
  enableLokiLogs: true,
  logLabels: if self.enableMultiCluster then ['job', 'instance', 'cluster', 'level'] else ['job', 'instance', 'level'],
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alerts thresholds
  alertsModelRequestErrorRate: 30,  // %
  alertsBatchQueuingLatency: 5000000,  // µs

  // metrics source for signals library
  metricsSource: 'prometheus',

  signals: {
    serving: (import './signals/serving.libsonnet')(this),
    core: (import './signals/core.libsonnet')(this),
  },
}
