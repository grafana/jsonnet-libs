{
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['kafka_cluster'],
  instanceLabels: ['instance'],
  uid: 'kafka',
  dashboardNamePrefix: '',
  dashboardTags: ['kafka'],
  alertKafkaLagTooHighThreshold: '100',
  alertKafkaLagTooHighSeverity: 'critical',
  metricsSource: 'prometheus',  //or grafanacloud
  //Can be regex:
  topicsIgnoreSelector: '__consumer_offsets',
  zookeeperEnabled: true,
  signals+:
    {
      topic: (import './signals/topic.libsonnet')(this),
      consumerGroup: (import './signals/consumerGroup.libsonnet')(this),
    },
}
