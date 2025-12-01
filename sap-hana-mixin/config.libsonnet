{
  local this = self,

  // Filtering and label configuration
  filteringSelector: 'job="integrations/sap-hana"',

  groupLabels: ['job', 'sid'],
  instanceLabels: ['host'],

  // Dashboard configuration
  uid: 'sap-hana',
  dashboardNamePrefix: 'SAP HANA',
  dashboardTags: ['sap-hana-mixin'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Alert thresholds
  alertsCriticalHighCpuUsage: 80,  // percent 0-100
  alertsCriticalHighPhysicalMemoryUsage: 80,  // percent 0-100
  alertsWarningLowMemAllocLimit: 90,  // percent 0-100
  alertsCriticalHighMemoryUsage: 80,  // percent 0-100
  alertsCriticalHighDiskUtilization: 80,  // percent 0-100
  alertsCriticalHighSqlExecutionTime: 1,  // second
  alertsCriticalHighReplicationShippingTime: 1,  // second

  // Loki logs configuration
  enableLokiLogs: true,
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,


  // Metrics source for signals
  metricsSource: 'prometheus',

  // Signal definitions
  signals: {
    system: (import './signals/system.libsonnet')(this),
    instance: (import './signals/instance.libsonnet')(this),
    performance: (import './signals/performance.libsonnet')(this),
  },
}
