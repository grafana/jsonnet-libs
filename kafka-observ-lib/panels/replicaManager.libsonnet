local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    isrShrinks:
      signals.brokerReplicaManager.isrShrinks.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    isrExpands:
      signals.brokerReplicaManager.isrExpands.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    onlinePartitions:
      signals.brokerReplicaManager.onlinePartitions.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    offlinePartitions:
      signals.brokerReplicaManager.offlinePartitions.asTimeSeries()
      + commonlib.panels.requests.timeSeries.errors.stylize(),
    underReplicatedPartitions:
      signals.brokerReplicaManager.underReplicatedPartitions.asTimeSeries()
      + commonlib.panels.requests.timeSeries.errors.stylize(),
    underMinISRPartitions:
      signals.brokerReplicaManager.underMinISRPartitions.asTimeSeries()
      + commonlib.panels.requests.timeSeries.errors.stylize(),

    //for overview (use cluster wide signals):
    uncleanLeaderElectionStat:
      signals.clusterReplicaManager.uncleanLeaderElection.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    preferredReplicaInbalanceStat:
      signals.clusterReplicaManager.preferredReplicaInbalance.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

    onlinePartitionsStat:
      signals.clusterReplicaManager.onlinePartitions.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    offlinePartitionsStat:
      signals.clusterReplicaManager.offlinePartitions.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    underReplicatedPartitionsStat:
      signals.clusterReplicaManager.underReplicatedPartitions.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    underMinISRPartitionsStat:
      signals.clusterReplicaManager.underMinISRPartitions.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

  },
}
