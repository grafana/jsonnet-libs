{
  filteringSelector: 'job=~".*openldap.*"',
  uid: 'openldap',

  enableMultiCluster: false,
  groupLabels: if self.enableMultiCluster then ['job', 'cluster'] else ['job'],
  logLabels: if self.enableMultiCluster then ['job', 'cluster', 'instance'] else ['job', 'instance'],
  clusterLegendLabel: ['cluster', 'instance'],
  instanceLabels: ['instance'],

  // prefix dashboards titles
  dashboardNamePrefix: '',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  alertsWarningConnectionSpike: 100,
  alertsWarningHighSearchOperationRateSpike: 200,
  alertsWarningDialFailureSpike: 10,
  alertsWarningBindFailureRateIncrease: 10,

  enableLokiLogs: true,
  customAllValue: '.*',  // Override this as desired. '.+' is a good option if you want to ensure a label is present.
  extraLogLabels: ['level', 'component'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
}
