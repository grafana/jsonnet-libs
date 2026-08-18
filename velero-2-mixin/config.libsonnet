{
  local this = self,
  filteringSelector: '',
  groupLabels: ['job', 'cluster'],
  logLabels: ['job', 'instance'],
  instanceLabels: ['instance'],
  dashboardTags: [self.uid],
  uid: 'velero',
  dashboardNamePrefix: 'Velero',

  // additional params can be added if needed
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // alert thresholds
  alertsHighBackupFailure: 0,  // backups
  alertsHighBackupDuration: 1.2,  // ratio vs the 1h average
  alertsHighRestoreFailureRate: 0,  // restores
  alertsVeleroUpStatus: 0,  // up == 0 means down

  // logs lib related
  enableLokiLogs: true,
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // signals
  metricsSource: ['prometheus'],
  signals+: {
    clusterOverview: (import './signals/clusteroverview.libsonnet')(this),
    overview: (import './signals/overview.libsonnet')(this),
  },
}
