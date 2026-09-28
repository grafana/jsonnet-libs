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

  alertsWarningConnectionSpike: 100,  // OpenLDAPConnectionSpike: new connections opened in 5m.
  alertsWarningHighSearchOperationRateSpike: 200,  // OpenLDAPHighSearchOperationRateSpike: percent, 5m search rate versus the preceding 15m.
  alertsWarningDialFailureSpike: 10,  // OpenLDAPDialFailures: failed dials in 10m.
  alertsWarningBindFailureRateIncrease: 10,  // OpenLDAPBindFailureRateIncrease: failed binds in 10m.

  enableLokiLogs: true,
  customAllValue: '.*',  // Override this as desired. '.+' is a good option if you want to ensure a label is present.
  extraLogLabels: ['level', 'component'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  metricsSource: ['prometheus'],
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    connections: (import './signals/connections.libsonnet')(this),
    operations: (import './signals/operations.libsonnet')(this),
    authentication: (import './signals/authentication.libsonnet')(this),
    threads: (import './signals/threads.libsonnet')(this),
  },
}
