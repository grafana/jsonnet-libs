{
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['kafka_cluster'],
  instanceLabels: ['instance'],
  uid: 'kafka',
  dashboardNamePrefix: 'Kafka',
  dashboardTags: ['kafka'],
  kafkaLagThreshold: '100',
  metricsSource: 'prometheus',  //or grafanacloud
  //Can be regex:
  topicsIgnoreSelector: '__consumer_offsets',
  signals+:
    {
      topic: (import './signals/topic.libsonnet')(this),
      consumerGroup: (import './signals/consumerGroup.libsonnet')(this),
    },
}
