{
  enableMultiCluster: false,
  filteringSelector: 'job="integrations/clickhouse"',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster'] else ['job'],
  logLabels: if self.enableMultiCluster then ['job', 'cluster', 'instance'] else ['job', 'instance'],
  pureInstanceLabels: ['instance'],

  dashboardTags: [self.uid],
  uid: 'clickhouse',
  dashboardNamePrefix: 'ClickHouse',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Legend panel configuration
  legendLabels: ['instance'],

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alerts configuration
  alertsReplicasMaxQueueSize: '99',
}
