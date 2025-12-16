{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="bar"
  groupLabels: ['job', 'hbase_cluster'],
  instanceLabels: ['instance'],
  logLabels: ['job', 'hbase_cluster', 'instance'],

  dashboardTags: [self.uid + '-mixin'],
  uid: 'apache-hbase',
  dashboardNamePrefix: 'Apache HBase',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: ['prometheus'],

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alerts thresholds
  alertsHighHeapMemUsage: 80,  // percentage
  alertsHighNonHeapMemUsage: 80,  // percentage
  alertsDeadRegionServer: 0,  // count
  alertsOldRegionsInTransition: 50,  // percentage
  alertsHighMasterAuthFailRate: 35,  // percentage
  alertsHighRSAuthFailRate: 35,  // percentage

  // Signals configuration
  signals+: {
    cluster: (import './signals/cluster.libsonnet')(this),
    regionserver: (import './signals/regionserver.libsonnet')(this),
  },
}
