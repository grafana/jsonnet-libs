{
  enableMultiCluster: false,
  filteringSelector: 'job=~"integrations/mssql"',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster'] else ['job'],
  instanceLabels: ['instance'],
  dashboardTags: ['mssql-mixin'],
  legendLabels: ['instance'],
  uid: 'mssql',
  dashboardNamePrefix: 'MSSQL',

  // additional params
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // logs lib related
  enableLokiLogs: true,
  logLabels: if self.enableMultiCluster then ['job', 'instance', 'cluster', 'level'] else ['job', 'instance', 'level'],
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alert thresholds
  alertsWarningDeadlocks5m: 10,
  alertsWarningModerateReadStallTimeMS: 200,
  alertsCriticalHighReadStallTimeMS: 400,
  alertsWarningModerateWriteStallTimeMS: 200,
  alertsCriticalHighWriteStallTimeMS: 400,
}
