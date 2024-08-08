{
  new(this): {
    groups+: [
      {
        name: this.config.uid + '-kafka-alerts',
        rules:
          [
            {
              alert: 'KafkaLagKeepsIncreasing',
              expr: 'sum without (partition) (delta(%s[5m]) > 0)' %
                    [
                      this.signals.consumerGroup.consumerGroupLag.asRuleExpression(),
                    ],
              'for': '15m',
              keep_firing_for: '10m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Kafka lag keeps increasing.',
                description: 'Kafka lag keeps increasing over the last 15 minutes for consumer group: {{$labels.consumergroup}}, topic: {{$labels.topic}}.',
              },
            },
            {
              alert: 'KafkaLagIsTooHigh',
              expr: 'sum without (partition) (%s) > %s' %
                    [
                      this.signals.consumerGroup.consumerGroupLag.asRuleExpression(),
                      this.config.alertKafkaLagTooHighThreshold,
                    ],
              'for': '15m',
              keep_firing_for: '5m',
              labels: {
                severity: this.config.alertKafkaLagTooHighSeverity,
              },
              annotations: {
                summary: 'Kafka lag is too high.',
                description: 'Total kafka lag across all partitions is too high ({{ printf "%.0f" $value }}) for consumer group: {{$labels.consumergroup}}, topic: {{$labels.topic}}.',
              },
            },
            {
              alert: 'KafkaISRExpandRate',
              expr: |||
                sum without() (%s) != 0
              ||| % this.signals.replicaManager.isrExpands.asRuleExpression(),
              'for': '5m',
              keep_firing_for: '15m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Kafka ISR expansion rate is expanding.',
                description: 'Kafka broker {{ $labels.%s }} in cluster {{ $labels.%s }} In-Sync Replica (ISR) is expanding by {{ $value }} per second. If a broker goes down, ISR for some of the partitions shrink. When that broker is up again, ISRs are expanded once the replicas are fully caught up. Other than that, the expected value for ISR expansion rate is 0. If ISR is expanding and shrinking frequently, adjust Allowed replica lag.'
                             % [
                               this.config.instanceLabels[0],
                               this.config.groupLabels[0],
                             ],
              },
            },
            {
              alert: 'KafkaISRShrinkRate',
              expr: |||
                sum without() (%s) != 0
              ||| % this.signals.replicaManager.isrShrinks.asRuleExpression(),
              'for': '5m',
              keep_firing_for: '15m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Kafka ISR expansion rate is shrinking.',
                description: 'Kafka broker {{ $labels.%s }} in cluster {{ $labels.%s }} In-Sync Replica (ISR) is shrinking by {{ $value }} per second. If a broker goes down, ISR for some of the partitions shrink. When that broker is up again, ISRs are expanded once the replicas are fully caught up. Other than that, the expected value for ISR shrink rate is 0. If ISR is expanding and shrinking frequently, adjust Allowed replica lag.'
                             % [
                               this.config.instanceLabels[0],
                               this.config.groupLabels[0],
                             ],

              },
            },
            {
              alert: 'KafkaOfflinePartitonCount',
              expr: |||
                sum by (%s) (%s) > 0
              ||| % [
                std.join(',', this.config.groupLabels),
                this.signals.replicaManager.offlinePartitions.asRuleExpression(),
              ],
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka has offline partitons.',
                description: 'Kafka cluster {{ $labels.%s }} has {{ $value }} offline partitions. After successful leader election, if the leader for partition dies, then the partition moves to the OfflinePartition state. Offline partitions are not available for reading and writing. Restart the brokers, if needed, and check the logs for errors.'
                             % this.config.groupLabels[0],
              },
            },
            {
              alert: 'KafkaUnderReplicatedPartitionCount',
              expr: |||
                %s > 0
              ||| % [
                this.signals.replicaManager.underReplicatedPartitions.asRuleExpression(),
              ],
              'for': '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka has under replicated partitons.',
                description: 'Kafka broker {{ $labels.%s }} in cluster {{ $labels.%s }} has {{ $value }} under replicated partitons'
                             % [
                               this.config.instanceLabels[0],
                               this.config.groupLabels[0],
                             ],
              },
            },
            {
              alert: 'KafkaNoActiveController',
              expr: 'sum by(' + std.join(',', this.config.groupLabels) + ') (' + this.signals.cluster.activeControllers.asRuleExpression() + ') != 1',
              'for': '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka has no active controller.',
                description: 'Kafka cluster {{ $labels.%s }} has {{ $value }} broker(s) reporting as the active controller in the last 5 minute interval. During steady state there should be only one active controller per cluster.'
                             % this.config.groupLabels[0],
              },
            },
            {
              alert: 'KafkaUncleanLeaderElection',
              expr: this.signals.replicaManager.uncleanLeaderElection.asRuleExpression() + ' != 0',
              'for': '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka has unclean leader elections.',
                description: 'Kafka cluster {{ $labels.%s }} has {{ $value }} unclean partition leader elections reported in the last 5 minute interval. When unclean leader election is held among out-of-sync replicas, there is a possibility of data loss if any messages were not synced prior to the loss of the former leader. So if the number of unclean elections is greater than 0, investigate broker logs to determine why leaders were re-elected, and look for WARN or ERROR messages. Consider setting the broker configuration parameter unclean.leader.election.enable to false so that a replica outside of the set of in-sync replicas is never elected leader.'
                             % this.config.groupLabels[0],
              },
            },
            {
              alert: 'KafkaBrokerCount',
              expr: 'count by(' + std.join(',', this.config.groupLabels) + ') (' + this.signals.cluster.brokersCount.asRuleExpression() + ') == 0',
              'for': '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka has no brokers online.',
                description: 'Kafka cluster {{ $labels.%s }} broker count is 0.' % this.config.groupLabels[0],
              },
            },
            {
              alert: 'KafkaZookeeperSyncConnect',
              expr: 'avg by(' + std.join(',', this.config.groupLabels + this.config.instanceLabels) + ') (' + this.signals.zookeeperClient.zookeeperConnections.asRuleExpression() + ') < 0',
              'for': '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka Zookeeper sync disconected.',
                description: 'Kafka broker {{ $labels.%s }} in cluster {{ $labels.%s }} has disconected from Zookeeper.'
                             % [
                               this.config.instanceLabels[0],
                               this.config.groupLabels[0],
                             ],
              },
            },

          ],
      },
    ],
  },
}
