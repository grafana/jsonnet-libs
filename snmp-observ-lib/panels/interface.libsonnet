local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {

    traffic:
      commonlib.panels.network.timeSeries.traffic.new(targets=[])
      + signals.interface.networkOutBitPerSec.asPanelMixin()
      + signals.interface.networkInBitPerSec.asPanelMixin()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),

    errors:
      commonlib.panels.network.timeSeries.errors.new('Network errors', targets=[])
      + commonlib.panels.network.timeSeries.errors.withNegateOutPackets()
      + signals.interface.networkInErrorsPerSec.asPanelMixin()
      + signals.interface.networkOutErrorsPerSec.asPanelMixin(),

    dropped: commonlib.panels.network.timeSeries.dropped.new(targets=[])
             + commonlib.panels.network.timeSeries.errors.withNegateOutPackets()
             + signals.interface.networkInDroppedPerSec.asPanelMixin()
             + signals.interface.networkOutDroppedPerSec.asPanelMixin()
             + signals.interface.ifInUnknownProtos.asPanelMixin(),
    packetsUnicast:
      commonlib.panels.network.timeSeries.packets.new('Unicast', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.interface.networkInUnicastPacketsPerSec.asPanelMixin()
      + signals.interface.networkOutUnicastPacketsPerSec.asPanelMixin(),
    packetsBroadcast:
      commonlib.panels.network.timeSeries.packets.new('Broadcast', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.interface.networkInBroadcastPacketsPerSec.asPanelMixin()
      + signals.interface.networkOutBroadcastPacketsPerSec.asPanelMixin(),
    packetsMulticast:
      commonlib.panels.network.timeSeries.packets.new('Multicast', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.interface.networkInMulticastPacketsPerSec.asPanelMixin()
      + signals.interface.networkOutMulticastPacketsPerSec.asPanelMixin(),
  },
}