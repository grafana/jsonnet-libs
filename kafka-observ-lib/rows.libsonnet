local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(panels, type):: {
    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.cluster.activeControllers { gridPos+: { w: 3, h: 4 } },
          panels.cluster.brokersCount { gridPos+: { w: 3, h: 4 } },
          panels.replicaManager.uncleanLeaderElectionStat { gridPos+: { w: 3, h: 4 } },
          panels.replicaManager.preferredReplicaInbalanceStat { gridPos+: { w: 3, h: 4 } },
          panels.cluster.clusterBytesBothPerSec { gridPos+: { w: 6, h: 8 } },
          panels.cluster.clusterMessagesPerSec { gridPos+: { w: 6, h: 8 } },
          //next row
          panels.replicaManager.onlinePartitionsStat { gridPos+: { w: 3, h: 4 } },
          panels.replicaManager.offlinePartitionsStat { gridPos+: { w: 3, h: 4 } },
          panels.replicaManager.underReplicatedPartitionsStat { gridPos+: { w: 3, h: 4 } },
          panels.replicaManager.underMinISRPartitionsStat { gridPos+: { w: 3, h: 4 } },
          // status rows
          panels.cluster.clusterRoles { gridPos+: { w: 24, h: 7 } },
        ]
      ),
    throughput:
      g.panel.row.new('Throughput')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.broker.brokerBytesBothPerSec { gridPos+: { w: 12, h: 8 } },
          panels.broker.brokerMessagesPerSec { gridPos+: { w: 12, h: 8 } },
        ]
      ),
    topic:
      g.panel.row.new('Topics')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.topic.topicTable { gridPos+: { w: 24, h: 8 } },
          panels.topic.topicMessagesPerSec { gridPos+: { w: 24, h: 8 } },
          panels.topic.topicBytesInPerSec { gridPos+: { w: 12, h: 6 } },
          panels.topic.topicBytesOutPerSec { gridPos+: { w: 12, h: 6 } },
        ]
      )
    ,
    consumerGroup:
      g.panel.row.new('Consumer groups')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.consumerGroup.consumerGroupTable { gridPos+: { w: 24, h: 8 } },
        ]


        +
        if type == 'prometheus' || type == "bitnami" then
          [
            panels.consumerGroup.consumerGroupConsumeRate { gridPos+: { w: 12, h: 8 } },
            panels.consumerGroup.consumerGroupLag { gridPos+: { w: 12, h: 8 } },
          ]
        else if type == 'grafanacloud' then
          [
            panels.consumerGroup.consumerGroupConsumeRate { gridPos+: { w: 8, h: 8 } },
            panels.consumerGroup.consumerGroupLag { gridPos+: { w: 8, h: 8 } },
            panels.consumerGroup.consumerGroupLagTime { gridPos+: { w: 8, h: 8 } },
          ]
      ),
    replication:
      g.panel.row.new('Replication')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.replicaManager.onlinePartitions { gridPos+: { w: 12, h: 6 } },
          panels.replicaManager.offlinePartitions { gridPos+: { w: 12, h: 6 } },
          panels.replicaManager.underReplicatedPartitions { gridPos+: { w: 12, h: 6 } },
          panels.replicaManager.underMinISRPartitions { gridPos+: { w: 12, h: 6 } },
          panels.replicaManager.isrShrinks { gridPos+: { w: 12, h: 6 } },
          panels.replicaManager.isrExpands { gridPos+: { w: 12, h: 6 } },
        ]
      ),
    totalTimePerformance:
      g.panel.row.new('Requests time breakdown')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels(
        [
          panels.totalTime.producerTotalTimeBreakdown { gridPos+: { w: 8, h: 6 } },
          panels.totalTime.fetchFollowerTotalTimeBreakdown { gridPos+: { w: 8, h: 6 } },
          panels.totalTime.fetchConsumerTotalTimeBreakdown { gridPos+: { w: 8, h: 6 } },

        ]
      ),
    zookeeperClient:
      g.panel.row.new('Zookeeper client')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels(
        [
          panels.zookeeperClient.zookeeperRequestLatency { gridPos+: { w: 8, h: 6 } },
          panels.zookeeperClient.zookeeperConnections { gridPos+: { w: 8, h: 6 } },
        ]
      ),
    messageConversion:
      g.panel.row.new('Message conversion')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels(
        [
          panels.conversion.producerConversion { gridPos+: { w: 12, h: 6 } },
          panels.conversion.consumerConversion { gridPos+: { w: 12, h: 6 } },
        ]
      ),
  },
}
