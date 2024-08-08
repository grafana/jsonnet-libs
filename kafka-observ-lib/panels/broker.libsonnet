local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {

    brokerBytesBothPerSec:
      g.panel.timeSeries.new('Broker network throughput')
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.broker.brokerBytesInPerSec.asPanelMixin()
      + signals.broker.brokerBytesOutPerSec.asPanelMixin(),
    brokerMessagesPerSec:
      g.panel.timeSeries.new('Broker messages throughput')
      + commonlib.panels.network.timeSeries.packets.stylize()
      + signals.broker.brokerMessagesInPerSec.asPanelMixin(),


  },
}
