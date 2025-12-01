{
  local this = self,
  filteringSelector: 'job="integrations/wildfly"',
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
    overviewServer: (import './signals/overview-server.libsonnet')(this),
    overviewDeployment: (import './signals/overview-deployment.libsonnet')(this),
    datasource: (import './signals/datasource.libsonnet')(this),
    datasourceTransaction: (import './signals/datasource-transaction.libsonnet')(this),
  },
}
