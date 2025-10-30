{
  local this = self,

  // Basic filtering
  filteringSelector: 'job=~"$job", instance=~"$instance"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],

  // Dashboard settings
  dashboardTags: ['f5-bigip-mixin'],
  uid: 'f5-bigip',
  dashboardNamePrefix: 'F5 BIG-IP',
  dashboardRefresh: '1m',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',

  // Logs configuration
  enableLokiLogs: true,
  filterSelector: 'job=~"syslog"',
  logLabels: ['job', 'host', 'syslog_facility', 'level'],
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alert thresholds
  alertsCriticalNodeAvailability: 95,  // %
  alertsWarningServerSideConnectionLimit: 80,  // %
  alertsCriticalHighRequestRate: 150,  // %
  alertsCriticalHighConnectionQueueDepth: 75,  // %

  // Metrics source
  metricsSource: 'prometheus',

  signals+: {
    system: (import './signals/system.libsonnet')(this),
    virtualServers: (import './signals/virtual-servers.libsonnet')(this),
    pools: (import './signals/pools.libsonnet')(this),
    nodes: (import './signals/nodes.libsonnet')(this),
  },
}
