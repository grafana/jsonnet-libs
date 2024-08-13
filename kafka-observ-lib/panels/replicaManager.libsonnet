local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    isrShrinks:
      signals.replicaManager.isrShrinks.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    isrExpands:
      signals.replicaManager.isrExpands.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    onlinePartitions:
      signals.replicaManager.onlinePartitions.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    offlinePartitions:
      signals.replicaManager.offlinePartitions.asTimeSeries()
      + commonlib.panels.requests.timeSeries.errors.stylize(),
    underReplicatedPartitions:
      signals.replicaManager.underReplicatedPartitions.asTimeSeries()
      + commonlib.panels.requests.timeSeries.errors.stylize(),
    underMinISRPartitions:
      signals.replicaManager.underMinISRPartitions.asTimeSeries()
      + commonlib.panels.requests.timeSeries.errors.stylize(),

    //for overview:
    uncleanLeaderElectionStat:
      signals.replicaManager.uncleanLeaderElection.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    preferredReplicaInbalanceStat:
      signals.replicaManager.preferredReplicaInbalance.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

    onlinePartitionsStat:
      signals.replicaManager.onlinePartitions.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    offlinePartitionsStat:
      signals.replicaManager.offlinePartitions.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    underReplicatedPartitionsStat:
      signals.replicaManager.underReplicatedPartitions.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    underMinISRPartitionsStat:
      signals.replicaManager.underMinISRPartitions.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

  },
}
