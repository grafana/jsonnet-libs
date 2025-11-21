{
  local this = self,

  // Enable multi-cluster support
  enableMultiCluster: false,

  // Basic filtering and labeling
  filteringSelector: '',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster'] else ['job'],
  instanceLabels: ['qmgr'],

  // Dashboard settings
  dashboardTags: ['ibm-mq-mixin'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  dashboardNamePrefix: 'IBM MQ',
  uid: 'ibm-mq',

  // Log settings
  enableLokiLogs: true,
  logLabels: ['job', 'qmgr', 'filename'],
  extraLogLabels: if self.enableMultiCluster then ['cluster'] else [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
  logExpression: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster", qmgr=~"$qmgr"' else 'job=~"$job", qmgr=~"$qmgr"',

  // Alert thresholds
  alertsExpiredMessages: 2,  // count
  alertsStaleMessagesSeconds: 300,  // seconds
  alertsLowDiskSpace: 5,  // %
  alertsHighQueueManagerCpuUsage: 85,  // %

  // Metrics source
  metricsSource: 'prometheus',

  // Signal definitions
  signals: {
    cluster: (import './signals/cluster.libsonnet')(this),
    qmgr: (import './signals/qmgr.libsonnet')(this),
    queue: (import './signals/queue.libsonnet')(this),
    topic: (import './signals/topic.libsonnet')(this),
    subscription: (import './signals/subscription.libsonnet')(this),
    channel: (import './signals/channel.libsonnet')(this),
  },
}
