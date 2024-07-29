local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    aliveConnections:
      signals.zookeeper.aliveConnections.asStat()
      + commonlib.panels.generic.stat.info.stylize(),
    znodes:
      signals.zookeeper.znodes.asStat()
      + commonlib.panels.generic.stat.info.stylize(),
    watchers:
      signals.zookeeper.watchers.asStat()
      + commonlib.panels.generic.stat.info.stylize(),
    quorumSize:
      signals.zookeeper.quorumSize.asStat()
      + commonlib.panels.generic.stat.info.stylize(),
    outstandingRequests:
      signals.zookeeper.outstandingRequests.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
