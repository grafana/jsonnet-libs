{
  local this = self,
  filteringSelector: '',
  groupLabels: ['job', 'cluster'],
  logLabels: ['job', 'cluster', 'instance'],
  instanceLabels: ['instance'],

  uid: 'wildfly',
  dashboardTags: [self.uid + '-mixin'],
  dashboardNamePrefix: 'Wildfly',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: ['prometheus'],  // metrics source for signals

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level', 'severity'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alerts thresholds
  alertsErrorRequestErrorRate: 30,  // % - percentage of requests resulting in 5XX error responses
  alertsErrorRejectedSessions: 20,  // sessions - number of rejected sessions over 5m period

  // Signals configuration
  signals+: {
    overviewServer: (import './signals/overview-server.libsonnet')(this),
    overviewDeployment: (import './signals/overview-deployment.libsonnet')(this),
    datasource: (import './signals/datasource.libsonnet')(this),
    datasourceTransaction: (import './signals/datasource-transaction.libsonnet')(this),
  },
}
