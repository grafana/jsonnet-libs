{
  enableMultiCluster: false,
  filteringSelector: 'job=~"integrations/couchbase"',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster', 'couchbase_cluster'] else ['job', 'couchbase_cluster'],
  instanceLabels: ['instance'],
  dashboardTags: ['couchbase-mixin'],
  uid: 'couchbase',
  dashboardNamePrefix: 'Couchbase',


  // additional params
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // logs lib related
  enableLokiLogs: true,
  logLabels: if self.enableMultiCluster then ['job', 'instance', 'cluster', 'level'] else ['job', 'instance', 'level'],
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alerts thresholds
  alertsCriticalCPUUsage: 85,  // %
  alertsCriticalMemoryUsage: 85,  // %
  alertsWarningMemoryEvictionRate: 10,  // count
  alertsWarningInvalidRequestVolume: 1000,  // count

  // metrics source for signals library
  metricsSource: 'prometheus',

  // expose signals library
  local config = self,
  signals+: {
    cluster: (import './signals/cluster.libsonnet')(config),
    node: (import './signals/node.libsonnet')(config),
    query: (import './signals/query.libsonnet')(config),
    bucket: (import './signals/bucket.libsonnet')(config),
    index: (import './signals/index.libsonnet')(config),
  },
}
