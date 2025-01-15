local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    interfacesTable:
      signals.interface.ifOperStatus.asTable(name='Interfaces', format='table', filterable=true)
      + g.panel.table.panelOptions.withDescription('Network interfaces overview.')
      + signals.interface.ifAdminStatus.asTableColumn(format='table')
      + signals.interface.ifHighSpeed.asTableColumn(format='table')
      // + signals.interface.ifType.asTableColumn(format='table')
      + signals.interface.ifType_info.asTableColumn(format='table')
      + signals.interface.ifPromiscuousMode.asTableColumn(format='table')
      + signals.interface.ifConnectorPresent.asTableColumn(format='table')
      + signals.interface.ifMtu.asTableColumn(format='table')
      + signals.interface.ifLastChange.asTableColumn(format='table')
      + signals.interface.ifPhysAddress.asTableColumn(format='table')
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
      signals.interface.networkOutBitPerSec.withTopK().asTimeSeries('Network traffic')
      + signals.interface.networkInBitPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      //set legend table
      + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max', 'lastNotNull'])
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withSortBy('Mean')
      + g.panel.timeSeries.options.legend.withSortDesc(true),

    errors:
      signals.interface.networkInErrorsPerSec.withTopK().asTimeSeries('Network errors')
      + signals.interface.networkOutErrorsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),

    dropped:
      signals.interface.networkInDroppedPerSec.withTopK().asTimeSeries('Dropped packets')
      + signals.interface.networkOutDroppedPerSec.withTopK().asPanelMixin()
      + signals.interface.ifInUnknownProtos.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.dropped.stylize()
      + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),

    packetsUnicast:
      signals.interface.networkInUnicastPacketsPerSec.withTopK().asTimeSeries('Unicast')
      + signals.interface.networkOutUnicastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.unicast.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),

    packetsBroadcast:
      signals.interface.networkInBroadcastPacketsPerSec.withTopK().asTimeSeries('Broadcast')
      + signals.interface.networkOutBroadcastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.broadcast.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),

    packetsMulticast:
      signals.interface.networkInMulticastPacketsPerSec.withTopK().asTimeSeries('Multicast')
      + signals.interface.networkOutMulticastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.multicast.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),

  },
}
