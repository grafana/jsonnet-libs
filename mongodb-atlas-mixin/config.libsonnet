{
  local this = self,

  // Basic filtering - MongoDB Atlas uses job and cl_name (cluster name) as primary filters
  filteringSelector: 'job="integrations/mongodb-atlas"',
  groupLabels: ['job', 'cl_name'],
  instanceLabels: ['instance'],

  // Dashboard settings
  dashboardTags: ['mongodb-atlas-mixin'],
  uid: 'mongodb-atlas',
  dashboardNamePrefix: 'MongoDB Atlas',
  dashboardRefresh: '1m',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',

  // Sharding dashboard flag, enable this to generate the sharding overview dashboard
  enableShardingOverview: true,

  // Logs configuration (MongoDB Atlas does not have Loki logs by default)
  enableLokiLogs: false,  // note for users, this is not supported by the MongoDB Atlas mixin as there shouldn't be any logs to monitor yet
  logLabels: [],
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: false,

  // Alert thresholds with units
  alertsDeadlocks: 10,  // count
  alertsSlowNetworkRequests: 10,  // count
  alertsHighDiskUsage: 90,  // %
  alertsSlowHardwareIO: 3,  // seconds
  alertsHighTimeoutElections: 10,  // count

  // Metrics source
  metricsSource: 'prometheus',

  // Import signal definitions (organized by dashboard)
  signals+: {
    cluster: (import './signals/cluster.libsonnet')(this),
    elections: (import './signals/elections.libsonnet')(this),
    operations: (import './signals/operations.libsonnet')(this),
    performance: (import './signals/performance.libsonnet')(this),
    sharding: (import './signals/sharding.libsonnet')(this),
  },
}
