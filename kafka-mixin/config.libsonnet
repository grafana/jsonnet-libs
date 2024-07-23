{
  _config+:: {
    kafkaFilteringSelector: 'job="integrations/kafka"',
    kafkaConnectSelector: 'job=~"integrations/kafka-connect|integrations/kafka"',
    zookeeperFilteringSelector: 'job=~"integrations/kafka-zookeeper|integrations/kafka"',
    schemaRegistryFilteringSelector: 'job=~"integrations/kafka-schemaregistry|integrations/kafka"',
    ksqldbFilteringSelector: 'job=~"integrations/kafka-ksqldb|integrations/kafka"',
    groupLabels: ['job', 'kafka_cluster'],
    instanceLabels: ['instance'],
    dashboardTags: ['kafka-integration'],
  },
}
