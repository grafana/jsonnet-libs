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
  metricsSource: ['prometheus', 'bitnami', 'grafanacloud'],  //or grafanacloud, bitnami. See README
  // 'jmx_exporter' if you use jmx_exporter in http mode or javaagent mode with the additional config snippet (see README)
  // 'prometheus_old' if you use jmx_exporter in javaagent mode and version prior to 1.0.1
  // 'prometheus' if you use jmx_exporter in javaagent mode and version 1.0.1 or newer
  jvmMetricsSource: ['prometheus_old', 'prometheus', 'jmx_exporter'],

  topicsFilteringSelector: 'topic!="__consumer_offsets"',
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
      brokerReplicaManager: (import './signals/brokerReplicaManager.libsonnet')(this),
      clusterReplicaManager: (import './signals/clusterReplicaManager.libsonnet')(this),
      conversion: (import './signals/conversion.libsonnet')(this),
    },
}
