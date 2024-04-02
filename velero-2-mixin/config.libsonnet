{
  filteringSelector: 'job="integrations/velero"',
  groupLabels: ['job', 'cluster'],
  logLabels: ['job', 'instance'],
  legendLabels: ['cluster', 'instance'],
  instanceLabels: ['instance'],
  dashboardTags: [self.uid],
  uid: 'velero',
  dashboardNamePrefix: 'Velero',

  // additional params can be added if needed
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // alert thresholds
  alertsHighBackupFailure: 0,
  alertsHighBackupDuration: 20,
  alertsHighRestoreFailureRate: 0,
  alertsVeleroUpStatus: 0,

  // logs lib related
  enableLokiLogs: true,
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
}
