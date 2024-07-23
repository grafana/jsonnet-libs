{
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['cluster', 'kafka_cluster'],
  instanceLabels: ['instance'],
  uid: 'kafka',
  dashboardNamePrefix: 'Kafka',
  dashboardTags: ['kafka'],
  metricsSource: 'prometheus',
  //Can be regex:
  topicsIgnoreSelector: '__consumer_offsets',
  signals+:
    {
      topic: (import './signals/topic.libsonnet')(this),
      consumerGroup: (import './signals/consumerGroup.libsonnet')(this),
    },
}
