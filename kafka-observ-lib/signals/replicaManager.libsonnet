local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
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
            }
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
            }
        },
      },
      onlinePartitions: {
        name: 'Online partitions',
        description: |||
          Online partitions.
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
              expr: 'kafka_server_replicamanager_total_partitioncount_value{%(queriesSelector)s}'
            }
        },
      },
      offlinePartitions: {
        name: 'Offline partitions',
        description: |||
          Number of partitions that dont have an active leader and are hence not writable or readable.
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
            }
        },
      },
      underReplicatedPartitions: {
        name: 'Under replicated partitions',
        description: |||
          Number of under replicated partitions (| ISR | < | all replicas |).
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
          Under min ISR(In-Sync replicas) partitions.
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
          Unclean leader election rate.
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
      preferredReplicaInbalance: {
        name: 'Preferred replica inbalance',
        description: |||
          The count of topic partitions for which the leader is not the preferred leader.
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
            }
        },
      },


    },
  }
