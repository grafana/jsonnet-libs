{
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],
  filteringSelector: 'job=~".*openldap.*"',
  uid: 'openldap',
  clusterLegendLabel: ['openldap_cluster', 'instance'],
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
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
}
