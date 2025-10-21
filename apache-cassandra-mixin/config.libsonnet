{
  local this = self,
  enableDatacenterLabel: false,
  enableRackLabel: false,
  filteringSelector: 'job="integrations/apache-cassandra"',

  groupLabels: ['job', 'cassandra_cluster'] + (if this.enableDatacenterLabel then ['datacenter'] else []) + (if this.enableRackLabel then ['rack'] else []),
  instanceLabels: ['instance'],
  uid: 'apache-cassandra',
  dashboardNamePrefix: 'Apache Cassandra',
  dashboardTags: [self.uid + '-mixin'],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  //alert thresholds
  alertsCriticalReadLatency5m: 200,  //ms
  alertsCriticalWriteLatency5m: 200,  //ms
  alertsWarningPendingCompactionTasks15m: 30,
  alertsCriticalBlockedCompactionTasks5m: 1,
  alertsWarningHintsStored1m: 1,
  alertsCriticalUnavailableWriteRequests5m: 1,
  alertsCriticalHighCpuUsage5m: 80,  //percent: emitted metric has range 0-100
  alertsCriticalHighMemoryUsage5m: 80,  //percent: calculated as ratio then multiplied by query

  enableLokiLogs: true,
  extraLogLabels: [],
  showLogsVolume: true,

  // metrics source for signals
  metricsSource: 'prometheus',
  signals: {
    overview: (import './signals/overview.libsonnet')(this),
    nodes: (import './signals/nodes.libsonnet')(this),
    keyspaces: (import './signals/keyspaces.libsonnet')(this),
  },
}
