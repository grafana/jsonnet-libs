{
  local this = self,
  filteringSelector: 'job="integrations/f5-bigip"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'f5-bigip',
  dashboardNamePrefix: 'F5 BIG-IP',
  dashboardTags: [self.uid + '-mixin'],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // alerts thresholds
  alertsCriticalNodeAvailability: 95,  // %
  alertsWarningServerSideConnectionLimit: 80,  // %
  alertsCriticalHighRequestRate: 150,  // %
  alertsCriticalHighConnectionQueueDepth: 75,  // %

  enableLokiLogs: true,
  extraLogLabels: [],
  showLogsVolume: true,

  // metrics source for signals
  metricsSource: ['prometheus'],
  signals: {
    cluster: (import './signals/cluster.libsonnet')(this),
    node: (import './signals/node.libsonnet')(this),
    pool: (import './signals/pool.libsonnet')(this),
    virtualServer: (import './signals/virtualserver.libsonnet')(this),
  },
}
