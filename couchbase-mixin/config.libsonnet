{
  // any modular library should include as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids

  enableMultiCluster: false,
  filteringSelector: '',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster', 'couchbase_cluster'] else ['job', 'couchbase_cluster'],
  instanceLabels: ['instance'],
  dashboardTags: ['couchbase-mixin'],
  uid: 'couchbase',
  dashboardNamePrefix: 'Couchbase',

  local config = self,
  // Dashboard-specific label configurations
  dashboardVariables: {
    cluster: if config.enableMultiCluster then ['job', 'couchbase_cluster', 'cluster'] else ['job', 'couchbase_cluster'],
    node: if config.enableMultiCluster then ['job', 'instance', 'couchbase_cluster', 'cluster'] else ['job', 'instance', 'couchbase_cluster'],
    bucket: if config.enableMultiCluster then ['job', 'instance', 'couchbase_cluster', 'cluster', 'bucket'] else ['job', 'instance', 'couchbase_cluster', 'bucket'],
  },

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
}
