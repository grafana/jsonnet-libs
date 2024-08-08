{
  local this = self,
  filteringSelector: 'job!=""',
  zookeeperfilteringSelector: this.filteringSelector,
  groupLabels: ['kafka_cluster'],  // label(s) that defines kafka cluster
  instanceLabels: ['instance'],  // label(s) that defines single broker
  uid: 'kafka',
  dashboardNamePrefix: '',
  dashboardTags: ['kafka'],
  alertKafkaLagTooHighThreshold: '100',
  alertKafkaLagTooHighSeverity: 'critical',
  metricsSource: 'prometheus',  //or grafanacloud
  //Can be regex:
  topicsIgnoreSelector: '__consumer_offsets',
  zookeeperEnabled: true,
  totalTimeMsQuantile: '0.95',  // quantile to use for totalTimeMs metrics: 0.50, 0.75, 0.95, 0.98, 0.99, 0.999...
  zookeeperClientQuantile: '0.95',  // quantile to use for zookeeperClient metrics: 0.50, 0.75, 0.95, 0.98, 0.99, 0.999...
  signals+:
    {
      cluster: (import './signals/cluster.libsonnet')(this),
      broker: (import './signals/broker.libsonnet')(this),
      topic: (import './signals/topic.libsonnet')(this),
      consumerGroup: (import './signals/consumerGroup.libsonnet')(this),
      zookeeperClient: (import './signals/zookeeperClient.libsonnet')(this),
      totalTime: (import './signals/totalTime.libsonnet')(this),
      replicaManager: (import './signals/replicaManager.libsonnet')(this),
      conversion: (import './signals/conversion.libsonnet')(this),
    },
}
