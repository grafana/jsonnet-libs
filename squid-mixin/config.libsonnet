{
  local this = self,

  // Basic filtering
  filteringSelector: '',
  groupLabels: ['job', 'cluster'],
  logLabels: ['job', 'cluster', 'instance'],
  instanceLabels: ['instance'],

  // Dashboard settings
  uid: 'squid',
  dashboardNamePrefix: 'Squid',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: ['prometheus'],

  // Logs configuration
  enableLokiLogs: true,
  customAllValue: '.*',  // Override this as desired. '.+' is a good option if you want to ensure a label is present.
  extraLogLabels: ['level', 'severity'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alert thresholds
  alertsCriticalHighPercentageRequestErrors: 5,  // %
  alertsWarningLowCacheHitRatio: 85,  // %

  // Signal definitions
  signals: {
    overview: (import './signals/overview.libsonnet')(this),
  },
}
