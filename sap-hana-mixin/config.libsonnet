{
  local this = self,

  // Basic filtering
  filteringSelector: 'job=~"$job", sid=~"$sid"',
  groupLabels: ['job', 'sid'],
  instanceLabels: ['host'],

  // Dashboard settings
  dashboardTags: ['sap-hana-mixin'],
  uid: 'sap-hana',
  dashboardNamePrefix: 'SAP HANA',
  dashboardRefresh: '1m',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',

  // Logs configuration
  enableLokiLogs: true,
  logLabels: ['job', 'sid', 'host', 'filename'],
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alert thresholds
  alertsCriticalHighCpuUsage: 80,  // %
  alertsCriticalHighPhysicalMemoryUsage: 80,  // %
  alertsWarningLowMemAllocLimit: 90,  // %
  alertsCriticalHighMemoryUsage: 80,  // %
  alertsCriticalHighDiskUtilization: 80,  // %
  alertsCriticalHighSqlExecutionTime: 1,  // s
  alertsCriticalHighReplicationShippingTime: 1,  // s

  // Metrics source
  metricsSource: 'prometheus',

  // Signals
  signals+: {
    cpu: (import './signals/cpu.libsonnet')(this),
    memory: (import './signals/memory.libsonnet')(this),
    disk: (import './signals/disk.libsonnet')(this),
    network: (import './signals/network.libsonnet')(this),
    replication: (import './signals/replication.libsonnet')(this),
    sql: (import './signals/sql.libsonnet')(this),
    connections: (import './signals/connections.libsonnet')(this),
    storage: (import './signals/storage.libsonnet')(this),
    alerts: (import './signals/alerts.libsonnet')(this),
  },
}
