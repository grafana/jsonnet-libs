{
  local this = self,
  filteringSelector: 'job=~"integrations/apache-activemq"',
  groupLabels: ['job', 'cluster', 'activemq_cluster'],
  instanceLabels: ['instance'],

  dashboardTags: [self.uid],
  legendLabels: ['instance', 'activemq_cluster'],
  uid: 'apache-activemq',
  dashboardNamePrefix: 'Apache ActiveMQ',

  // additional params
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: 'prometheus',

  // logs lib related
  enableLokiLogs: true,
  logLabels: self.groupLabels + self.instanceLabels,
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alert thresholds
  alertsHighTopicMemoryUsage: 70,  // %
  alertsHighQueueMemoryUsage: 70,  // %
  alertsHighStoreMemoryUsage: 70,  // %
  alertsHighTemporaryMemoryUsage: 70,  // %

  signals+: {
    clusters: (import './signals/clusters.libsonnet')(this),
    instance: (import './signals/instance.libsonnet')(this),
    queues: (import './signals/queues.libsonnet')(this),
    topics: (import './signals/topics.libsonnet')(this),
  },
}
