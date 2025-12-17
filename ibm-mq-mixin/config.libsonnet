{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="bar"
  groupLabels: ['cluster', 'job', 'mq_cluster'],
  instanceLabels: ['instance', 'qmgr'],
  uid: 'ibm-mq',

  dashboardNamePrefix: 'IBM MQ',
  dashboardTags: ['ibm-mq-mixin'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Data source configuration
  metricsSource: 'prometheus',
  enableLokiLogs: true,
  logLabels: this.groupLabels,
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alerts configuration
  alertsExpiredMessages: 2,  //count
  alertsStaleMessagesSeconds: 300,  //seconds
  alertsLowDiskSpace: 5,  //percentage: 0-100
  alertsHighQueueManagerCpuUsage: 85,  //percentage: 0-100

  // Multi-cluster support (for backward compatibility)
  enableMultiCluster: false,

  signals+: {
    cluster: (import './signals/cluster.libsonnet')(this),
    queueManager: (import './signals/queue-manager.libsonnet')(this),
    queue: (import './signals/queue.libsonnet')(this),
    topic: (import './signals/topics.libsonnet')(this),
  },
}
