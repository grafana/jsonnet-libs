{
  local this = self,
  filteringSelector: '',
  groupLabels: ['job', 'mongodb_cluster'],
  instanceLabels: ['service_name'],
  uid: 'mongodb',
  dashboardTags: [self.uid + '-mixin'],
  dashboardNamePrefix: 'MongoDB',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: ['percona_mongodb'],

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
  customAllValue: '.*',

  // Alerts configuration
  alertsCriticalReplicationLag: 60,  // seconds
  alertsWarningCursorsOpen: 10000,  // count
  alertsWarningCursorsTimeouts: 100,  // count per 1m
  alertsWarningConnectionUtilization: 80,  // percent
  alertsWarningVirtualMemoryRatio: 3,  // ratio

  // Signals configuration
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    instance: (import './signals/instance.libsonnet')(this),
    replicaset: (import './signals/replicaset.libsonnet')(this),
    cluster: (import './signals/cluster.libsonnet')(this),
    alerts: (import './signals/alerts.libsonnet')(this),
  },
}
