local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, config):: {
    zookeeperRequestLatency:
      signals.zookeeperClient.zookeeperRequestLatency.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    zookeeperConnections:

      signals.zookeeperClient.zookeeperConnections.asTimeSeries()
      + signals.zookeeperClient.zookeeperExpiredConnections.asPanelMixin()
      + signals.zookeeperClient.zookeeperDisconnects.asPanelMixin()
      + signals.zookeeperClient.zookeeperAuthFailures.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
