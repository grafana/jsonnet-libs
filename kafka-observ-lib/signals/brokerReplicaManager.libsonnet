local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'kafka_server_replicamanager_isrshrinks_total',
      grafanacloud: 'kafka_server_replicamanager_isrshrinkspersec',
      bitnami: 'kafka_server_replicamanager_total_isrshrinkspersec_count',
    },
    signals: {
      local s = this,
      isrShrinks: {
        name: 'ISR shrinks',
        description: |||
          The number of in-sync replicas (ISRs) for a particular partition should remain fairly static,
          the only exceptions are when you are expanding your broker cluster or removing partitions.
          In order to maintain high availability, a healthy Kafka cluster requires a minimum number of ISRs for failover. 

          A replica could be removed from the ISR pool for a couple of reasons: it is too far behind the leaders offset
          (user-configurable by setting the replica.lag.max.messages configuration parameter),
          or it has not contacted the leader for some time (configurable with the replica.socket.timeout.ms parameter). No matter the reason,
          an increase in IsrShrinksPerSec without a corresponding increase in IsrExpandsPerSec shortly thereafter is cause for concern and requires user intervention.

          The Kafka documentation provides a wealth of information on the user-configurable parameters for brokers.
        |||,
        type: 'raw',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              expr: '%(aggFunction)s by (%(agg)s) (kafka_server_replicamanager_isrshrinkspersec{%(queriesSelector)s})',
            },
          prometheus:
            {
              expr: '%(aggFunction)s by (%(agg)s)  (rate(kafka_server_replicamanager_isrshrinks_total{%(queriesSelector)s}[%(interval)s]))',
            },
          bitnami:
            {
              expr: '%(aggFunction)s by (%(agg)s)  (rate(kafka_server_replicamanager_total_isrshrinkspersec_count{%(queriesSelector)s}[%(interval)s]))',
            },
        },
      },
      isrExpands: {
        name: 'ISR expands',
        description: |||
          The number of in-sync replicas (ISRs) for a particular partition should remain fairly static,
          the only exceptions are when you are expanding your broker cluster or removing partitions.
          In order to maintain high availability, a healthy Kafka cluster requires a minimum number of ISRs for failover. 

          A replica could be removed from the ISR pool for a couple of reasons: it is too far behind the leaders offset
          (user-configurable by setting the replica.lag.max.messages configuration parameter),
          or it has not contacted the leader for some time (configurable with the replica.socket.timeout.ms parameter). No matter the reason,
          an increase in IsrShrinksPerSec without a corresponding increase in IsrExpandsPerSec shortly thereafter is cause for concern and requires user intervention.

          The Kafka documentation provides a wealth of information on the user-configurable parameters for brokers.
        |||,
        type: 'raw',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              expr: '%(aggFunction)s by (%(agg)s) (kafka_server_replicamanager_isrexpandspersec{%(queriesSelector)s})',
            },
          prometheus:
            {
              expr: '%(aggFunction)s by (%(agg)s) (rate(kafka_server_replicamanager_isrexpands_total{%(queriesSelector)s}[%(interval)s]))',
            },
          bitnami: {
            expr: '%(aggFunction)s by (%(agg)s) (rate(kafka_server_replicamanager_total_isrexpandspersec_count{%(queriesSelector)s}[%(interval)s]))',
          },
        },
      },
      onlinePartitions: {
        name: 'Online partitions',
        description: |||
          Number of partitions that are currently online and available on this broker. This includes
          partitions where this broker is either the leader or a follower replica. The total count
          reflects the broker's share of the topic partitions across the cluster. A sudden drop in
          online partitions may indicate broker issues, partition reassignments, or cluster rebalancing.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              expr: 'kafka_server_replicamanager_partitioncount{%(queriesSelector)s}',
            },
          prometheus:
            {
              expr: 'kafka_server_replicamanager_partitioncount{%(queriesSelector)s}',
            },
          bitnami:
            {
              expr: 'kafka_server_replicamanager_total_partitioncount_value{%(queriesSelector)s}',
            },
        },
      },
      offlinePartitions: {
        name: 'Offline partitions',
        description: |||
          Number of partitions that don't have an active leader and are hence not writable or readable.
          Offline partitions indicate a critical availability issue as producers cannot write to these
          partitions and consumers cannot read from them. This typically occurs when all replicas for
          a partition are down or when there are not enough in-sync replicas to elect a new leader.
          Any non-zero value requires immediate investigation and remediation to restore service availability.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              expr: 'kafka_controller_kafkacontroller_offlinepartitionscount{%(queriesSelector)s}',
            },
          prometheus:
            {
              expr: 'kafka_controller_kafkacontroller_offlinepartitionscount{%(queriesSelector)s}',
            },
          bitnami: {
            expr: 'kafka_controller_kafkacontroller_offlinepartitionscount_value{%(queriesSelector)s}',
          },
        },
      },
      underReplicatedPartitions: {
        name: 'Under replicated partitions',
        description: |||
          Number of partitions that have fewer in-sync replicas (ISR) than the configured replication factor.
          Under-replicated partitions indicate potential data availability issues, as there are fewer copies
          of the data than desired. This could be caused by broker failures, network issues, or brokers
          falling behind in replication. A high number of under-replicated partitions poses a risk to
          data durability and availability, as the loss of additional brokers could result in data loss.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        optional: true,
        sources: {
          grafanacloud:
            {
              expr: 'kafka_cluster_partition_underreplicated{%(queriesSelector)s}',
            },
          prometheus:
            {
              expr: 'kafka_cluster_partition_underreplicated{%(queriesSelector)s}',
            },
        },
      },
      underMinISRPartitions: {
        name: 'Under min ISR partitions',
        description: |||
          Number of partitions that have fewer in-sync replicas (ISR) than the configured minimum ISR threshold.
          When the number of ISRs for a partition falls below the min.insync.replicas setting, the partition
          becomes unavailable for writes (if acks=all is configured), which helps prevent data loss but impacts
          availability. This metric indicates potential issues with broker availability, network connectivity,
          or replication lag that need immediate attention to restore write availability.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        optional: true,
        sources: {
          grafanacloud:
            {
              expr: 'kafka_cluster_partition_underminisr{%(queriesSelector)s}',
            },
          prometheus:
            {
              expr: 'kafka_cluster_partition_underminisr{%(queriesSelector)s}',
            },
        },
      },
      uncleanLeaderElection: {
        name: 'Unclean leader election',
        description: |||
          Rate of unclean leader elections occurring in the cluster. An unclean leader election happens
          when a partition leader fails and a replica that was not fully in-sync (not in the ISR) is
          elected as the new leader. This results in potential data loss as the new leader may be missing
          messages that were committed to the previous leader. Unclean elections occur when unclean.leader.election.enable
          is set to true and there are no in-sync replicas available. Any occurrence of unclean elections
          indicates a serious problem with cluster availability and replication health that risks data integrity.
        |||,
        type: 'raw',
        unit: 'short',
        aggFunction: 'sum',
        optional: true,
        sources: {
          grafanacloud:
            {
              expr: '%(aggFunction)s by (%(agg)s) (kafka_controller_controllerstats_uncleanleaderelectionspersec{%(queriesSelector)s})',
            },
          prometheus:
            {
              expr: '%(aggFunction)s by (%(agg)s) (rate(kafka_controller_controllerstats_uncleanleaderelections_total{%(queriesSelector)s}[%(interval)s]))',
            },
        },
      },
      preferredReplicaImbalance: {
        name: 'Preferred replica imbalance',
        description: |||
          The count of topic partitions for which the leader is not the preferred leader. In Kafka,
          each partition has a preferred leader replica (typically the first replica in the replica list).
          When leadership is not on the preferred replica, the cluster may experience uneven load distribution
          across brokers, leading to performance imbalances. This can occur after broker failures and restarts,
          or during cluster maintenance. Running the preferred replica election can help rebalance leadership
          and optimize cluster performance. A consistently high imbalance may indicate issues with automatic
          leader rebalancing or the need for manual intervention.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              expr: 'kafka_controller_kafkacontroller_preferredreplicaimbalancecount{%(queriesSelector)s}',
            },
          prometheus:
            {
              expr: 'kafka_controller_kafkacontroller_preferredreplicaimbalancecount{%(queriesSelector)s}',
            },
          bitnami: {
            expr: 'kafka_controller_kafkacontroller_preferredreplicaimbalancecount_value{%(queriesSelector)s}',
          },
        },
      },

    },
  }
