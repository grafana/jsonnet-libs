{

  local this = self,
  filteringSelector: '',
  groupLabels: ['job', 'mesos_cluster', 'cluster'],
  instanceLabels: ['instance'],

  dashboardTags: [self.uid + '-mixin'],
  uid: 'apache-mesos',
  dashboardNamePrefix: 'Apache Mesos',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Logging configuration
  enableLokiLogs: true,
  logLabels: ['job', 'cluster', 'instance'],
  extraLogLabels: ['level'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alerts thresholds
  alertsWarningMemoryUsage: 90,
  alertsCriticalDiskUsage: 90,
  alertsWarningUnreachableTask: 3,

  // metrics source for signals library
  metricsSource: 'prometheus',

  // signals configuration
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    master: (import './signals/master.libsonnet')(this),
    agent: (import './signals/agent.libsonnet')(this),
  },
}
