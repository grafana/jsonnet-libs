{
  local this = self,
  enableMultiCluster: false,
  filteringSelector: 'job="integrations/wildfly"',  // set to apply static filters to all queries and alerts, i.e. job="integrations/wildfly"
  groupLabels: ['job', 'cluster'],
  logLabels: ['job', 'cluster', 'instance'],
  instanceLabels: ['instance'],

  uid: 'wildfly',
  dashboardTags: [self.uid],
  dashboardNamePrefix: 'Wildfly',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: 'prometheus',  // metrics source for signals

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level', 'severity'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alerts thresholds
  alertsErrorRequestErrorRate: '30',
  alertsErrorRejectedSessions: '20',

  // Signals configuration
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    datasource: (import './signals/datasource.libsonnet')(this),
  },
}
