{
  // Enable multi-cluster mode to use cluster-based filtering
  enableMultiCluster: false,

  // Base filtering selector that's always applied
  filteringSelector: 'job="integrations/clickhouse"',

  // Labels used for grouping and filtering
  groupLabels: if self.enableMultiCluster then ['instance', 'cluster'] else ['instance'],

  // Labels that represent instances (used for single instance mode)
  instanceLabels: ['instance'],

  // Labels that should be treated as pure instance labels (no multi-select in single instance mode)
  pureInstanceLabels: ['instance'],

  // Dashboard configuration
  dashboardTags: ['clickhouse-mixin'],
  uid: 'clickhouse',
  dashboardNamePrefix: 'ClickHouse',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Legend configuration
  legendLabels: ['instance'],

  // Logging configuration
  enableLokiLogs: true,
  logLabels: if self.enableMultiCluster then ['instance', 'cluster', 'level'] else ['instance', 'level'],
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alerts configuration
  alertsReplicasMaxQueueSize: '99',
}
