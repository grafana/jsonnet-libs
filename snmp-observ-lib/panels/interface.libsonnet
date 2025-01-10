local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    interfacesTable:
      signals.interface.ifOperStatus.asTable(name='Interfaces', format='table', filterable=true)
      + g.panel.table.panelOptions.withDescription('Network interfaces overview.')
      + signals.interface.ifAdminStatus.asTableColumn(format='table')
      + signals.interface.ifHighSpeed.asTableColumn(format='table')
      + signals.interface.ifType.asTableColumn(format='table')
      + signals.interface.ifPromiscuousMode.asTableColumn(format='table')
      + signals.interface.ifConnectorPresent.asTableColumn(format='table')
      + signals.interface.ifMtu.asTableColumn(format='table')
      + signals.interface.ifLastChange.asTableColumn(format='table')
      + {
        options+: {
          sortBy: [
            {
              displayName: 'IfName',
              desc: false,
            },
          ],
        },
      },

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
      commonlib.panels.network.timeSeries.unicast.new('Unicast', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.interface.networkInUnicastPacketsPerSec.asPanelMixin()
      + signals.interface.networkOutUnicastPacketsPerSec.asPanelMixin(),
    packetsBroadcast:
      commonlib.panels.network.timeSeries.broadcast.new('Broadcast', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.interface.networkInBroadcastPacketsPerSec.asPanelMixin()
      + signals.interface.networkOutBroadcastPacketsPerSec.asPanelMixin(),
    packetsMulticast:
      commonlib.panels.network.timeSeries.multicast.new('Multicast', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + signals.interface.networkInMulticastPacketsPerSec.asPanelMixin()
      + signals.interface.networkOutMulticastPacketsPerSec.asPanelMixin(),
  },
}
