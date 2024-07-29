{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'Kafka_Alerts',
        rules: [
          {
            alert: 'KafkaOfflinePartitonCount',
            expr:
              'sum without(' + std.join(',', $._config.instanceLabels) + ') (kafka_controller_kafkacontroller_offlinepartitionscount{%(kafkaFilteringSelector)s}) > 0' % $._config,

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
              sum without() (kafka_server_replicamanager_underreplicatedpartitions{%(kafkaFilteringSelector)s}) > 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Kafka has under replicated partitons.',
              description: 'Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster }} has {{ $value }} under replicated partitons',
            },
          },
          {
            alert: 'KafkaNoActiveController',
            expr: 'sum without(' + std.join(',', $._config.instanceLabels) + ') (kafka_controller_kafkacontroller_activecontrollercount{%(kafkaFilteringSelector)s}) != 1' % $._config,
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
            expr: 'max without(' + std.join(',', $._config.instanceLabels) + ') (rate(kafka_controller_controllerstats_uncleanleaderelectionspersec{%(kafkaFilteringSelector)s}[5m])) != 0' % $._config,
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
              sum without() (rate(kafka_server_replicamanager_isrexpandspersec{%(kafkaFilteringSelector)s}[5m])) != 0
            ||| % $._config,
            'for': '5m',
            keep_firing_for: '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Kafka ISR expansion rate is expanding.',
              description: 'Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster }} In-Sync Replica (ISR) is expanding by {{ $value }} per second. If a broker goes down, ISR for some of the partitions shrink. When that broker is up again, ISRs are expanded once the replicas are fully caught up. Other than that, the expected value for ISR expansion rate is 0. If ISR is expanding and shrinking frequently, adjust Allowed replica lag.',
            },
          },
          {
            alert: 'KafkaISRShrinkRate',
            expr: |||
              sum without() (rate(kafka_server_replicamanager_isrshrinkspersec{%(kafkaFilteringSelector)s}[5m])) != 0
            ||| % $._config,
            'for': '5m',
            keep_firing_for: '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Kafka ISR expansion rate is shrinking.',
              description: 'Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster }} In-Sync Replica (ISR) is shrinking by {{ $value }} per second. If a broker goes down, ISR for some of the partitions shrink. When that broker is up again, ISRs are expanded once the replicas are fully caught up. Other than that, the expected value for ISR shrink rate is 0. If ISR is expanding and shrinking frequently, adjust Allowed replica lag.',
            },
          },
          {
            alert: 'KafkaBrokerCount',
            expr: 'count without(' + std.join(',', $._config.instanceLabels) + ') (kafka_server_kafkaserver_brokerstate{%(kafkaFilteringSelector)s}) == 0' % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Kafka has no brokers online.',
              description: 'Kafka cluster {{ $labels.kafka_cluster }} broker count is 0.',
            },
          },
          {
            alert: 'KafkaZookeeperSyncConnect',
            expr: |||
              avg without() (kafka_server_sessionexpirelistener_zookeepersyncconnectspersec{%(kafkaFilteringSelector)s}) < 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Kafka Zookeeper sync disconected.',
              description: 'Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster }} Zookeeper sync disconected.',
            },
          },
        ],
      },
    ],
  },
}
