{
  local this = self,

  // Basic filtering
  filteringSelector: 'job="integrations/squid"',
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
  metricsSource: 'prometheus',
  
  // Logs configuration
  enableLokiLogs: true,
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
