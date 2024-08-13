local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    activeControllers:
      signals.cluster.activeControllers.asStat()
      + commonlib.panels.generic.stat.info.stylize(),
    brokersCount:
      signals.cluster.brokersCount.asStat()
      + commonlib.panels.generic.stat.info.stylize(),
    clusterRoles:
      signals.cluster.role.asStatusHistory()
      + signals.zookeeper.cluster.role.asPanelMixin()
      + commonlib.panels.generic.statusHistory.base.stylize(),

    clusterBytesBothPerSec:
      g.panel.timeSeries.new('Cluster network throughput')
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.cluster.clusterBytesInPerSec.asPanelMixin()
      + signals.cluster.clusterBytesOutPerSec.asPanelMixin(),
    clusterMessagesPerSec:
      g.panel.timeSeries.new('Cluster messages throughput')
      + commonlib.panels.network.timeSeries.packets.stylize()
      + signals.cluster.clusterMessagesInPerSec.asPanelMixin(),
  },
}
