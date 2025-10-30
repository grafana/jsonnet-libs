{
  local this = self,
  filteringSelector: if self.enableMultiCluster then 'cluster!="",opensearch_cluster!=""' else 'opensearch_cluster!=""',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster', 'opensearch_cluster'] else ['job', 'opensearch_cluster'],
  logLabels: ['job', 'cluster', 'node'],
  instanceLabels: ['node'],

  dashboardTags: [self.uid],
  uid: 'opensearch',
  dashboardNamePrefix: 'OpenSearch',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: 'prometheus',  // metrics source for signals

  // Agg Lists
  groupAggList: std.join(',', this.groupLabels),
  groupAggListWithInstance: std.join(',', this.groupLabels + this.instanceLabels),
  
  // Multi-cluster support
  enableMultiCluster: false,
  opensearchSelector: if self.enableMultiCluster then 'job=~"$job", instance=~"$instance", cluster=~"$cluster"' else 'job=~"$job", instance=~"$instance"',

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level', 'severity'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
  logExpression: '{job=~"$job", cluster=~"$cluster", instance=~"$instance", exception_class=~".+"} | json | line_format "{{.severity}} {{.exception_class}} - {{.exception_message}}" | drop time_extracted, severity_extracted, exception_class_extracted, correlation_id_extracted',

  // Alerts configuration
  alertsWarningShardReallocations: 0,  // count
  alertsWarningShardUnassigned: 0,  // count
  alertsWarningDiskUsage: 60,  // %
  alertsCriticalDiskUsage: 80,  // %
  alertsWarningCPUUsage: 70,  // %
  alertsCriticalCPUUsage: 85,  // %
  alertsWarningMemoryUsage: 70,  // %
  alertsCriticalMemoryUsage: 85,  // %
  alertsWarningRequestLatency: 0.5,  // seconds
  alertsWarningIndexLatency: 0.5,  // seconds
  
  // Signals configuration
  signals+: {
    cluster: (import './signals/cluster.libsonnet')(this),
    node: (import './signals/node.libsonnet')(this),
    topk: (import './signals/topk.libsonnet')(this),
    roles: (import './signals/roles.libsonnet')(this),
    search: (import './signals/search.libsonnet')(this),
    indexing: (import './signals/indexing.libsonnet')(this),
  },
}
