{
  local this = self,
  enableMultiCluster: false,
  filteringSelector: 'job=~"integrations/apache-activemq"',
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],
  activemqLabels: ['activemq_cluster'],

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
  logLabels: self.groupLabels + self.instanceLabels + self.activemqLabels,
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alert thresholds
  alertsHighTopicMemoryUsage: 70,  // %
  alertsHighQueueMemoryUsage: 70,  // %
  alertsHighStoreMemoryUsage: 70,  // %
  alertsHighTemporaryMemoryUsage: 70,  // %

  signals+: {
    broker: (import './signals/broker.libsonnet')(this),
    queues: (import './signals/queues.libsonnet')(this),
    topics: (import './signals/topics.libsonnet')(this),
  },
}
