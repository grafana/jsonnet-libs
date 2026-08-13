{
  local this = self,
  filteringSelector: '',
  uid: 'openldap',

  enableMultiCluster: false,
  groupLabels: if self.enableMultiCluster then ['job', 'cluster'] else ['job'],
  logLabels: if self.enableMultiCluster then ['job', 'cluster', 'instance'] else ['job', 'instance'],
  instanceLabels: ['instance'],

  // prefix dashboards titles
  dashboardNamePrefix: '',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // new connections opened in 5m
  alertsWarningConnectionSpike: 100,
  // percent, 5m search rate versus the preceding 15m
  alertsWarningHighSearchOperationRateSpike: 200,
  // failed dials in 10m
  alertsWarningDialFailureSpike: 10,
  // failed binds in 10m
  alertsWarningBindFailureRateIncrease: 10,

  enableLokiLogs: true,
  customAllValue: '.*',  // Override this as desired. '.+' is a good option if you want to ensure a label is present.
  extraLogLabels: ['level', 'component'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  metricsSource: 'prometheus',
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    connections: (import './signals/connections.libsonnet')(this),
    operations: (import './signals/operations.libsonnet')(this),
    authentication: (import './signals/authentication.libsonnet')(this),
    threads: (import './signals/threads.libsonnet')(this),
  },
}
