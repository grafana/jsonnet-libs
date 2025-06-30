{
  local this = self,
  enableMultiCluster: false,
  filteringSelector: 'job="integrations/clickhouse"',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster'] else ['job'],
  logLabels: if self.enableMultiCluster then ['job', 'cluster', 'instance'] else ['job', 'instance'],
  instanceLabels: ['instance'],

  dashboardTags: [self.uid],
  uid: 'clickhouse',
  dashboardNamePrefix: 'ClickHouse',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: 'prometheus',  // metrics source for signals

  // Legend panel configuration
  legendLabels: ['instance'],

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alerts configuration
  alertsReplicasMaxQueueSize: '99',

  // Signals configuration
  signals+: {
    replica: (import './signals/replica.libsonnet')(this),
    zookeeper: (import './signals/zookeeper.libsonnet')(this),
    queries: (import './signals/queries.libsonnet')(this),
    memory: (import './signals/memory.libsonnet')(this),
    connections: (import './signals/connections.libsonnet')(this),
    network: (import './signals/network.libsonnet')(this),
    disk: (import './signals/disk.libsonnet')(this),
  },
}
