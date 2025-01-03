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
             + signals.interface.networkOutDroppedPerSec.asPanelMixin(),
    packets:
      commonlib.panels.network.timeSeries.packets.new(targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.interface.networkInUnicastPacketsPerSec.asPanelMixin()
      + signals.interface.networkOutUnicastPacketsPerSec.asPanelMixin(),
  },
}
