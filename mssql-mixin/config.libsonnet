{
  local this = self,
  enableMultiCluster: false,
  filteringSelector: '',
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],
  databaseLabels: ['db'],


  dashboardTags: [self.uid],
  legendLabels: ['instance'],
  uid: 'mssql',
  dashboardNamePrefix: 'MSSQL',

  // additional params
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: 'prometheus',

  // logs lib related
  enableLokiLogs: true,
  logLabels: self.groupLabels + self.instanceLabels,
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alert thresholds
  alertsWarningDeadlocks5m: 10,
  alertsWarningModerateReadStallTimeMS: 200,
  alertsCriticalHighReadStallTimeMS: 400,
  alertsWarningModerateWriteStallTimeMS: 200,
  alertsCriticalHighWriteStallTimeMS: 400,

  signals+: {
    memory: (import './signals/memory.libsonnet')(this),
    connections: (import './signals/connections.libsonnet')(this),
    database: (import './signals/database.libsonnet')(this),
  },
}
