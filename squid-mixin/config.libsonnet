{
  local this = self,

  // Basic filtering
  filteringSelector: 'job=~"$job", instance=~"$instance"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],

  // Dashboard settings
  dashboardTags: ['squid'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  uid: 'squid',
  dashboardNamePrefix: 'Squid',

  // Logs configuration
  enableLokiLogs: true,
  logLabels: ['job', 'instance', 'filename'],
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Multi-cluster support
  enableMultiCluster: false,
  multiclusterSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',

  // Alert thresholds
  alertsCriticalHighPercentageRequestErrors: 5,  // %
  alertsWarningLowCacheHitRatio: 85,  // %

  // Metrics source
  metricsSource: 'prometheus',

  // Signal definitions
  signals: {
    client: (import './signals/client.libsonnet')(this),
    server: (import './signals/server.libsonnet')(this),
    serviceTime: (import './signals/service_time.libsonnet')(this),
  },
}
