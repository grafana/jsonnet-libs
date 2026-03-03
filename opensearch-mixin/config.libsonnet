{
  local this = self,
  filteringSelector: '',
  groupLabels: ['job', 'cluster', 'opensearch_cluster'],
  logLabels: ['job', 'cluster', 'opensearch_cluster'],
  instanceLabels: ['instance'],

  uid: 'opensearch',
  dashboardTags: [self.uid + '-mixin'],
  dashboardNamePrefix: 'OpenSearch',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: ['prometheus'],  // metrics source for signals

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level', 'severity'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Agg Lists
  groupAggList: std.join(',', this.groupLabels),
  groupAggListWithInstance: std.join(',', this.groupLabels + this.instanceLabels),

  // Alerts configuration
  alertsWarningShardReallocations: 0,  // count
  alertsWarningShardUnassigned: 0,  // count
  alertsWarningDiskUsage: 60,  // %
  alertsCriticalDiskUsage: 80,  // %
  alertsWarningCPUUsage: 70,  // %
  alertsCriticalCPUUsage: 85,  // %
  alertsWarningMemoryUsage: 70,  // %
  alertsCriticalMemoryUsage: 85,  // %
  alertsWarningRequestLatency: 500,  // milliseconds
  alertsWarningIndexLatency: 500,  // milliseconds

  // Signals configuration
  signals+: {
    clusterOverview: (import './signals/cluster-overview.libsonnet')(this),
    nodeOverview: (import './signals/node-overview.libsonnet')(this),
    searchAndIndexOverview: (import './signals/search-and-index-overview.libsonnet')(this),
  },
}
