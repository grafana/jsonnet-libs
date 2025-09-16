{
  local this = self,
  filteringSelector: 'job="integrations/apache-hadoop"',
  groupLabels: ['job', 'hadoop_cluster', 'cluster'],
  instanceLabels: ['instance'],


  dashboardTags: [self.uid + '-mixin'],
  uid: 'apache-hadoop',
  dashboardNamePrefix: 'Apache Hadoop',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Logging configuration
  enableLokiLogs: true,
  logLabels: ['job', 'cluster', 'instance'],
  extraLogLabels: ['level'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alerts thresholds
  alertsWarningHDFSCapacity: 20,  // %
  alertsCriticalHDFSMissingBlocks: 0,  // count
  alertsCriticalHDFSVolumeFailures: 0,  // count
  alertsCriticalDeadDataNodes: 0,  // count
  alertsCriticalNodeManagerCPUUsage: 80,  // %
  alertsCriticalNodeManagerMemoryUsage: 80,  // %
  alertsCriticalResourceManagerVCoreCPUUsage: 80,  // %
  alertsCriticalResourceManagerMemoryUsage: 80,  // %

  // Signals configuration
  signals+: {
    namenode: (import './signals/namenode.libsonnet')(this),
    datanode: (import './signals/datanode.libsonnet')(this),
    nodemanager: (import './signals/nodemanager.libsonnet')(this),
    resourcemanager: (import './signals/resourcemanager.libsonnet')(this),
  },
}
