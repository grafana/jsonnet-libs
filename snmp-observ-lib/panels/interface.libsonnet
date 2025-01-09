local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    interfacesTable:
      signals.interface.ifOperStatus.asTable(name='Interfaces', format='table', filterable=true)
      + g.panel.table.panelOptions.withDescription('Network interfaces overview.')
      + signals.interface.ifAdminStatus.asTableColumn(format='table')
      + signals.interface.networkOutBitPerSec.asTableColumn(format='table')
      + signals.interface.networkInBitPerSec.asTableColumn(format='table')
      + signals.interface.networkInErrorsPerSec.asTableColumn(format='table')
      + signals.interface.networkOutErrorsPerSec.asTableColumn(format='table'),

    traffic:
      commonlib.panels.network.timeSeries.traffic.new(targets=[])
      + signals.interface.networkOutBitPerSec.asPanelMixin()
      + signals.interface.networkInBitPerSec.asPanelMixin()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      //set legend table
      + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max', 'lastNotNull'])
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withSortBy('Mean')
      + g.panel.timeSeries.options.legend.withSortDesc(true),
      
      

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
