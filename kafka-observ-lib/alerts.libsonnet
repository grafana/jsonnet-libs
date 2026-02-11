local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

{
  new(this): {
    local instanceLabel = xtd.array.slice(this.config.instanceLabels, -1)[0],
    local groupLabel = xtd.array.slice(this.config.groupLabels, -1)[0],
    groups+: [
      {
        name: this.config.uid + '-kafka-alerts',
        rules:
          [
            {
              alert: 'KafkaLagKeepsIncreasing',
              expr: 'sum by (%s, topic, consumergroup) (%s) > 0' %
                    [
                      std.join(',', this.config.groupLabels),
                      // split back combined string to wrap in delta, then join back:
                      std.join(
                        '\nor\n',
                        std.map(
                          function(x) 'delta(%s[5m])' % x,
                          std.split(this.signals.consumerGroup.consumerGroupLag.asRuleExpression(), '\nor\n')
                        )
                      ),
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
              expr: 'sum by (%s, topic, consumergroup) (%s) > %s' %
                    [
                      std.join(',', this.config.groupLabels),
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
                sum by (%s) (%s) != 0
              ||| % [
                std.join(',', this.config.groupLabels + this.config.instanceLabels),
                this.signals.brokerReplicaManager.isrExpands.asRuleExpression(),
              ],
              'for': '5m',
              keep_firing_for: '15m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Kafka ISR expansion detected.',
                description: |||
                  Kafka broker {{ $labels.%s }} in cluster {{ $labels.%s }} has In-Sync Replica (ISR) expanding at {{ printf "%%.2f" $value }} per second.

                  ISR expansion typically occurs when a broker recovers and its replicas catch up to the leader. The expected steady-state value for ISR expansion rate is 0.

                  Frequent ISR expansion and shrinkage indicates instability and may suggest:
                  - Brokers frequently going offline/online
                  - Network connectivity issues
                  - Replica lag configuration too tight (adjust replica.lag.max.messages or replica.socket.timeout.ms)
                  - Insufficient broker resources causing replicas to fall behind

                  If this alert fires frequently without corresponding broker outages, investigate broker health and adjust replica lag settings.
                ||| % [
                  instanceLabel,
                  groupLabel,
                ],
              },
            },
            {
              alert: 'KafkaISRShrinkRate',
              expr: |||
                sum by (%s) (%s) != 0
              ||| % [
                std.join(',', this.config.groupLabels + this.config.instanceLabels),
                this.signals.brokerReplicaManager.isrShrinks.asRuleExpression(),
              ],
              'for': '5m',
              keep_firing_for: '15m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Kafka ISR shrinkage detected.',
                description: |||
                  Kafka broker {{ $labels.%s }} in cluster {{ $labels.%s }} has In-Sync Replica (ISR) shrinking at {{ printf "%%.2f" $value }} per second.

                  ISR shrinkage occurs when a replica falls too far behind the leader and is removed from the ISR set. This reduces fault tolerance as fewer replicas are in-sync.
                  The expected steady-state value for ISR shrink rate is 0.

                  Common causes include:
                  - Broker failures or restarts
                  - Network latency or connectivity issues
                  - Replica lag exceeding replica.lag.max.messages threshold
                  - Replica not contacting leader within replica.socket.timeout.ms
                  - Insufficient broker resources (CPU, disk I/O, memory)
                  - High producer throughput overwhelming broker capacity

                  If ISR is shrinking without corresponding expansion shortly after, investigate broker health, network connectivity, and resource utilization.
                  Consider adjusting replica.lag.max.messages or replica.socket.timeout.ms if shrinkage is frequent but brokers are healthy.
                ||| % [
                  instanceLabel,
                  groupLabel,
                ],
              },
            },
            {
              alert: 'KafkaOfflinePartitionCount',
              expr: |||
                sum by (%s) (%s) > 0
              ||| % [
                std.join(',', this.config.groupLabels),
                this.signals.brokerReplicaManager.offlinePartitions.asRuleExpression(),
              ],
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka has offline partitions.',
                description: |||
                  Kafka cluster {{ $labels.%s }} has {{ printf "%%.0f" $value }} offline partitions.

                  Offline partitions have no active leader, making them completely unavailable for both reads and writes. This directly impacts application functionality.

                  Common causes include:
                  - All replicas for the partition are down
                  - No in-sync replicas available for leader election
                  - Cluster controller issues preventing leader election
                  - Insufficient replica count for the replication factor

                  Immediate actions:
                  1. Check broker status - identify which brokers are down
                  2. Review broker logs for errors and exceptions
                  3. Restart failed brokers if needed
                  4. Verify ZooKeeper connectivity
                  5. Check for disk space or I/O issues on broker hosts
                  6. Monitor ISR status to ensure replicas are catching up

                  Until resolved, affected topics cannot serve traffic for these partitions.
                ||| % groupLabel,
              },
            },
            {
              alert: 'KafkaUnderReplicatedPartitionCount',
              expr: |||
                sum by (%s) (%s) > 0
              ||| % [
                std.join(',', this.config.groupLabels + this.config.instanceLabels),
                this.signals.brokerReplicaManager.underReplicatedPartitions.asRuleExpression(),
              ],
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka has under-replicated partitions.',
                description: |||
                  Kafka broker {{ $labels.%s }} in cluster {{ $labels.%s }} has {{ printf "%%.0f" $value }} under-replicated partitions.

                  Under-replicated partitions have fewer in-sync replicas (ISR) than the configured replication factor, reducing fault tolerance and risking data loss.

                  Impact:
                  - Reduced data durability (fewer backup copies)
                  - Increased risk of data loss if additional brokers fail
                  - Lower fault tolerance for partition availability

                  Common causes:
                  - Broker failures or network connectivity issues
                  - Brokers unable to keep up with replication (resource constraints)
                  - High producer throughput overwhelming replica capacity
                  - Disk I/O saturation on replica brokers
                  - Network partition between brokers

                  Actions:
                  1. Identify which brokers are lagging (check ISR for affected partitions)
                  2. Review broker resource utilization (CPU, memory, disk I/O)
                  3. Check network connectivity between brokers
                  4. Verify broker logs for replication errors
                  5. Consider adding broker capacity if consistently under-replicated
                  6. Reassign partitions if specific brokers are problematic
                ||| % [
                  instanceLabel,
                  groupLabel,
                ],
              },
            },
            {
              alert: 'KafkaUnderMinISRPartitionCount',
              expr: |||
                sum by (%s) (%s) > 0
              ||| % [
                std.join(',', this.config.groupLabels),
                this.signals.brokerReplicaManager.underMinISRPartitions.asRuleExpression(),
              ],
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka partitions below minimum ISR - writes unavailable.',
                description: |||
                  Kafka cluster {{ $labels.%s }} has {{ printf "%%.0f" $value }} partitions with fewer in-sync replicas than min.insync.replicas configuration.

                  CRITICAL IMPACT: These partitions are UNAVAILABLE FOR WRITES when producers use acks=all, directly impacting application availability.

                  This configuration prevents data loss by refusing writes when not enough replicas are in-sync, but at the cost of availability.

                  Common causes:
                  - Broker failures reducing available replicas below threshold
                  - Network issues preventing replicas from staying in-sync
                  - Brokers overwhelmed and unable to keep up with replication
                  - Recent partition reassignment or broker maintenance

                  Immediate actions:
                  1. Identify affected partitions and their current ISR status
                  2. Check broker health and availability
                  3. Review network connectivity between brokers
                  4. Investigate broker resource utilization (CPU, disk I/O, memory)
                  5. Restart failed brokers or resolve broker issues
                  6. Monitor ISR recovery as brokers catch up

                  Producers will receive NOT_ENOUGH_REPLICAS errors until ISR count recovers above min.insync.replicas threshold.
                ||| % groupLabel,
              },
            },
            {
              alert: 'KafkaPreferredReplicaImbalance',
              expr: |||
                sum by (%s) (%s) > 0
              ||| % [
                std.join(',', this.config.groupLabels),
                this.signals.brokerReplicaManager.preferredReplicaImbalance.asRuleExpression(),
              ],
              'for': '30m',
              keep_firing_for: '5m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Kafka has preferred replica imbalance.',
                description: |||
                  Kafka cluster {{ $labels.%s }} has {{ $value }} partitions where the leader is not the preferred replica.

                  Impact:
                  Uneven load distribution across brokers can result in some brokers handling significantly more client requests (produce/consume) than others, leading to hotspots, degraded performance, and potential resource exhaustion on overloaded brokers. This prevents optimal cluster utilization and can impact latency and throughput.

                  Common causes:
                  - Broker restarts or failures causing leadership to shift to non-preferred replicas
                  - Manual partition reassignments or replica movements
                  - Recent broker additions to the cluster
                  - Failed automatic preferred replica election
                  - Auto leader rebalancing disabled (auto.leader.rebalance.enable=false)

                  Actions:
                  1. Verify auto.leader.rebalance.enable is set to true in broker configuration
                  2. Check leader.imbalance.check.interval.seconds (default 300s) configuration
                  3. Manually trigger preferred replica election using kafka-preferred-replica-election tool
                  4. Monitor broker resource utilization (CPU, network) for imbalance
                  5. Review broker logs for leadership election errors
                  6. Verify all brokers are healthy and reachable

                  If the imbalance persists for extended periods, consider running manual preferred replica election to redistribute leadership and restore balanced load across the cluster.
                ||| % groupLabel,
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
                description: |||
                  Kafka cluster {{ $labels.%s }} has {{ $value }} broker(s) reporting as the active controller. Expected exactly 1 active controller.

                  CRITICAL impact:
                  The Kafka controller is responsible for cluster-wide administrative operations including partition leader election, broker failure detection, topic creation/deletion, and partition reassignment. Without an active controller (value=0) or with multiple controllers (value>1), the cluster cannot perform these critical operations, potentially causing:
                  - Inability to elect new partition leaders when brokers fail
                  - Topic creation/deletion operations hang indefinitely
                  - Partition reassignments cannot be executed
                  - Cluster metadata inconsistencies
                  - Split-brain scenarios if multiple controllers exist

                  Common causes:
                  - Zookeeper connectivity issues or Zookeeper cluster instability
                  - Network partitions between brokers and Zookeeper
                  - Controller broker crash or unclean shutdown
                  - Long garbage collection pauses on controller broker
                  - Zookeeper session timeout (zookeeper.session.timeout.ms exceeded)
                  - Controller election conflicts during network splits

                  This is a critical cluster-wide issue requiring immediate attention to restore normal operations.
                ||| % groupLabel,
              },
            },
            {
              alert: 'KafkaUncleanLeaderElection',
              expr: '(%s) != 0' % this.signals.brokerReplicaManager.uncleanLeaderElection.asRuleExpression(),
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Kafka has unclean leader elections.',
                description: |||
                  Kafka cluster {{ $labels.%s }} has {{ $value }} unclean partition leader elections reported in the last 5 minutes.

                  CRITICAL Impact - DATA LOSS RISK:
                  Unclean leader election occurs when no in-sync replica (ISR) is available to become the leader, forcing Kafka to elect an out-of-sync replica. This WILL result in data loss for any messages that were committed to the previous leader but not replicated to the new leader. This compromises data durability guarantees and can cause:
                  - Permanent loss of committed messages
                  - Consumer offset inconsistencies
                  - Duplicate message processing
                  - Data inconsistencies between producers and consumers
                  - Violation of at-least-once or exactly-once semantics

                  Common causes:
                  - All ISR replicas failed simultaneously (broker crashes, hardware failures)
                  - Network partitions isolating all ISR members
                  - Extended broker downtime exceeding replica lag tolerance
                  - Insufficient replication factor (RF < 3) combined with broker failures
                  - min.insync.replicas set too low relative to replication factor
                  - Disk failures on multiple replicas simultaneously
                  - Aggressive unclean.leader.election.enable=true configuration

                  Immediate actions:
                  1. Review broker logs to identify which partitions had unclean elections
                  2. Investigate root cause of ISR replica failures (check broker health, hardware, network)
                  3. Assess data loss impact by comparing producer and consumer offsets for affected partitions
                  4. Alert application teams to potential data loss in affected partitions
                  5. Bring failed ISR replicas back online as quickly as possible
                  6. Consider resetting consumer offsets if data loss is unacceptable
                  7. Review and increase replication factor for critical topics (minimum RF=3)
                  8. Set unclean.leader.election.enable=false to prevent future unclean elections (availability vs. durability trade-off)
                  9. Increase min.insync.replicas to strengthen durability guarantees
                  10. Implement better monitoring for ISR shrinkage to detect issues before unclean elections occur

                  This indicates a serious reliability event that requires immediate investigation and remediation to prevent future data loss.
                ||| % groupLabel,
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
                description: |||
                  Kafka cluster {{ $labels.%s }} has zero brokers reporting metrics.

                  No brokers are online or reporting metrics, indicating complete cluster failure. This results in:
                  - Total unavailability of all topics and partitions
                  - All produce and consume operations failing
                  - Complete loss of cluster functionality
                  - Potential data loss if unclean shutdown occurred
                  - Application downtime for all services depending on Kafka

                ||| % groupLabel,
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
                summary: 'Kafka Zookeeper sync disconnected.',
                description: |||
                  Kafka broker {{ $labels.%s }} in cluster {{ $labels.%s }} has lost connection to Zookeeper.

                  Zookeeper connectivity is essential for Kafka broker operation. A disconnected broker cannot:
                  - Participate in controller elections
                  - Register or maintain its broker metadata
                  - Receive cluster state updates
                  - Serve as partition leader (will be removed from ISR)
                  - Handle leadership changes or partition reassignments

                  This will cause the broker to become isolated from the cluster, leading to under-replicated partitions and potential service degradation for any topics hosted on this broker.

                  Prolonged Zookeeper disconnection will result in the broker being ejected from the cluster and leadership reassignments.
                ||| % [
                  instanceLabel,
                  groupLabel,
                ],
              },
            },

          ],
      },
    ],
  },
}
