{
  local this = self,
  enableMultiCluster: false,
  // selector used by the alertlist panel's instance-label filter
  solrSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
  logLabels: if self.enableMultiCluster then ['job', 'cluster', 'solr_cluster', 'instance', 'level', 'filename']
  else ['job', 'solr_cluster', 'instance', 'level', 'filename'],

  dashboardTags: ['apache-solr-mixin'],
  dashboardNamePrefix: 'Apache Solr',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // alerts thresholds
  alertsCriticalCPUUsage: 85,  // %, ApacheSolrHighCPUUsageCritical fires when the 5m average system CPU load across the cluster's nodes stays above this for 5m.
  alertsWarningCPUUsage: 75,  // %, ApacheSolrHighCPUUsageWarning fires when the 5m average system CPU load across the cluster's nodes stays above this for 5m.
  alertsWarningMemoryUsage: 85,  // %, ApacheSolrHighHeapMemoryUsageWarning fires when JVM heap used over heap max stays above this for 5m.
  alertsCriticalMemoryUsage: 75,  // %, ApacheSolrHighHeapMemoryUsageCritical fires when JVM heap used over heap max stays above this for 5m. NOTE: inherited from the legacy mixin, this sits below the warning threshold, so critical fires before warning.
  alertsWarningCacheUsage: 75,  // %, ApacheSolrLowCacheHitRatio fires when the document/filter/queryResult cache hit ratio stays *below* this for 10m.
  alertsWarningCoreErrors: 15,  // %, ApacheSolrHighCoreErrors fires when the 10m increase in core errors, relative to the 10m average, stays above this for 10m.
  alertsWarningDocumentIndexing: 30,  // %, ApacheSolrHighDocumentIndexing fires when the 15m increase in document adds, relative to the 15m average, stays above this for 15m.

  // logs
  enableLokiLogs: true,
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // signals framework
  filteringSelector: '',  // set to apply static filters to all queries, i.e. job="bar"
  customAllValue: '.+',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster'] else ['job'],
  instanceLabels: ['solr_cluster', 'base_url'],
  uid: 'apache-solr',
  metricsSource: ['prometheus'],
  signals+: {
    cluster: (import './signals/cluster.libsonnet')(this),
    query: (import './signals/query.libsonnet')(this),
    node: (import './signals/node.libsonnet')(this),
    jvm: (import './signals/jvm.libsonnet')(this),
    jetty: (import './signals/jetty.libsonnet')(this),
  },
}
