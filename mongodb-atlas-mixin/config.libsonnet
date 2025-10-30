{
  local this = self,

  // Basic filtering - MongoDB Atlas uses job and cl_name (cluster name) as primary filters
  filteringSelector: 'job=~"$job", cl_name=~"$cl_name"',
  groupLabels: ['job', 'cl_name'],
  instanceLabels: ['instance'],

  // Dashboard settings
  dashboardTags: ['mongodb-atlas-mixin'],
  uid: 'mongodb-atlas',
  dashboardNamePrefix: 'MongoDB Atlas',
  dashboardRefresh: '1m',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',

  // Sharding dashboard flag
  enableShardingOverview: false,

  // Logs configuration (MongoDB Atlas does not have Loki logs by default)
  enableLokiLogs: false,
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

  // Legend template for instance labels
  legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),

  // Import signal definitions
  signals+: {
    hardware: (import './signals/hardware.libsonnet')(this),
    memory: (import './signals/memory.libsonnet')(this),
    network: (import './signals/network.libsonnet')(this),
    connections: (import './signals/connections.libsonnet')(this),
    operations: (import './signals/operations.libsonnet')(this),
    locks: (import './signals/locks.libsonnet')(this),
    elections: (import './signals/elections.libsonnet')(this),
    sharding: (import './signals/sharding.libsonnet')(this),
  },
}
