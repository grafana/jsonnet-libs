{
  local this = self,
  filteringSelector: 'job="integrations/aerospike"',
  groupLabels: ['job', 'aerospike_cluster', 'cluster'],
  logLabels: ['job', 'cluster', 'instance'],
  instanceLabels: ['instance', 'ns'],  // ns == namespace

  dashboardTags: [self.uid],
  uid: 'aerospike',
  dashboardNamePrefix: 'Aerospike',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: [
    'prometheusAerospike7',  // For queries that are required for Aerospike 7.0+ with metric changes
    'prometheus',  // For Aerospike < 7.0
  ],

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alerts thresholds
  alertsCriticalNodeHighMemoryUsage: 80,  // %
  alertsCriticalNamespaceHighDiskUsage: 80,  // %
  alertsCriticalUnavailablePartitions: 0,  // count
  alertsCriticalDeadPartitions: 0,  // count
  alertsCriticalSystemRejectingWrites: 0,  // count
  alertsWarningHighClientReadErrorRate: 25,  // %
  alertsWarningHighClientWriteErrorRate: 25,  // %
  alertsWarningHighClientUDFErrorRate: 25,  // %

  // Signals configuration
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    namespace: (import './signals/namespace.libsonnet')(this),
    instance: (import './signals/instance.libsonnet')(this),
  },
}
