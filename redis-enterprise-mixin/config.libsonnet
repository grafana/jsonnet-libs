{
  local this = self,
  filteringSelector: 'job="integrations/redis-enterprise"',
  groupLabels: ['job', 'redis_cluster'],
  instanceLabels: ['instance'],
  nodeLabels: ['node'],
  databaseLabels: ['bdb'],
  uid: 'redis-enterprise',
  dashboardNamePrefix: 'Redis Enterprise',
  dashboardTags: [self.uid + '-mixin'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Alert thresholds
  alertsClusterOutOfMemoryThreshold: 80,  // %
  alertsNodeCPUHighUtilizationThreshold: 80,  // %
  alertsDatabaseHighMemoryUtilization: 80,  // %
  alertsDatabaseHighLatencyMs: 1000,  // ms
  alertsEvictedObjectsThreshold: 1,

  enableLokiLogs: true,
  extraLogLabels: [],
  showLogsVolume: true,

  // Metrics source for signals
  metricsSource: 'prometheus',
  signals: {
    overview: (import './signals/overview.libsonnet')(this),
    nodes: (import './signals/nodes.libsonnet')(this),
    databases: (import './signals/databases.libsonnet')(this),
  },
}
