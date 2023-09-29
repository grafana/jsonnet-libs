{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'Kafka_Alerts',
        rules: [
          {
            alert: 'KafkaOfflinePartitonCount',
            expr: |||
              sum without (kafka_cluster) (kafka_controller_KafkaController_OfflinePartitionsCount{%(kafkaFilteringSelector)s}) > 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Kafka has offline partitons.',
              description: 'Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} offline partitions. After successful leader election, if the leader for partition dies, then the partition moves to the OfflinePartition state. Offline partitions are not available for reading and writing. Restart the brokers, if needed, and check the logs for errors.',
            },
          },
          {
            alert: 'KafkaUnderReplicatedPartitionCount',
            expr: |||
              sum without (kafka_cluster) (kafka_server_ReplicaManager_UnderReplicatedPartitions{%(kafkaFilteringSelector)s}) > 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Kafka has under replicated partitons.',
              description: 'Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} under replicated partitons',
            },
          },
          {
            alert: 'KafkaActiveController',
            expr: |||
              sum without(kafka_cluster) (kafka_controller_KafkaController_ActiveControllerCount{%(kafkaFilteringSelector)s}) != 1
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Kafka has no active controller.',
              description: 'Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} broker(s) reporting as the active controller in the last 5 minute interval. During steady state there should be only one active controller per cluster.',
            },
          },
          {
            alert: 'KafkaUncleanLeaderElection',
            expr: |||
              max without(kafka_cluster) (rate(kafka_controller_ControllerStats_UncleanLeaderElectionsPerSec{%(kafkaFilteringSelector)s}[5m])) != 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Kafka has unclean leader elections.',
              description: 'Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} unclean partition leader elections reported in the last 5 minute interval. When unclean leader election is held among out-of-sync replicas, there is a possibility of data loss if any messages were not synced prior to the loss of the former leader. So if the number of unclean elections is greater than 0, investigate broker logs to determine why leaders were re-elected, and look for WARN or ERROR messages. Consider setting the broker configuration parameter unclean.leader.election.enable to false so that a replica outside of the set of in-sync replicas is never elected leader.',
            },
          },
          {
            alert: 'KafkaISRExpandRate',
            expr: |||
              sum without(instance, kafka_cluster) (rate(kafka_server_ReplicaManager_IsrExpandsPerSec{%(kafkaFilteringSelector)s}[5m])) != 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Kafka ISR Expansion Rate is expanding.',
              description: 'Kafka instance {{ $labels.instance }} cluster {{ $labels.kafka_cluster }} ISR is expanding by {{ $value }} per second. If a broker goes down, ISR for some of the partitions shrink. When that broker is up again, ISRs are expanded once the replicas are fully caught up. Other than that, the expected value for ISR expansion rate is 0. If ISR is expanding and shrinking frequently, adjust Allowed replica lag.',
            },
          },
          {
            alert: 'KafkaISRShrinkRate',
            expr: |||
              sum without(instance, kafka_cluster) (rate(kafka_server_ReplicaManager_IsrShrinksPerSec{%(kafkaFilteringSelector)s}[5m])) != 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Kafka ISR Expansion Rate is shrinking.',
              description: 'Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster }} ISR is shrinking by {{ $value }} per second. If a broker goes down, ISR for some of the partitions shrink. When that broker is up again, ISRs are expanded once the replicas are fully caught up. Other than that, the expected value for ISR shrink rate is 0. If ISR is expanding and shrinking frequently, adjust Allowed replica lag.',
            },
          },
          {
            alert: 'KafkaBrokerCount',
            expr: |||
              count without(kafka_cluster) (kafka_server_KafkaServer_BrokerState{%(kafkaFilteringSelector)s}) == 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Kafka has no Brokers online.',
              description: 'Kafka cluster {{ $labels.kafka_cluster }} broker count is 0.',
            },
          },
          {
            alert: 'KafkaZookeeperSyncConnect',
            expr: |||
              avg without(kafka_cluster) (kafka_server_SessionExpireListener_ZooKeeperSyncConnectsPerSec{%(kafkaFilteringSelector)s}) < 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Kafka Zookeeper Sync Disconected.',
              description: 'Kafka cluster {{ $labels.kafka_cluster }} Zookeeper Sync Disconected.',
            },
          },
        ],
      },
    ],
  },
}
