{
  local this = self,
  filteringSelector: '',
  enableMultiCluster: false,
  groupLabels: if self.enableMultiCluster then ['cluster', 'job'] else ['job'],
  instanceLabels: ['instance'],
  tablespaceLabels: ['tablespace'],
  uid: 'oracledb',

  dashboardNamePrefix: 'Oracle Database',
  dashboardTags: ['oracledb-mixin'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Data source configuration
  metricsSource: 'prometheus',
  enableLokiLogs: true,
  logLabels: this.groupLabels + this.instanceLabels,
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alerting thresholds
  alertsFileDescriptorThreshold: 85,  // %
  alertsProcessThreshold: 85,  // %
  alertsSessionThreshold: 85,  // %
  alertsTablespaceThreshold: 85,  // %

  // Signals configuration
  signals+: {
    sessions: (import './signals/sessions.libsonnet')(this),
    waittimes: (import './signals/waittimes.libsonnet')(this),
    tablespace: (import './signals/tablespace.libsonnet')(this),
  },
}
