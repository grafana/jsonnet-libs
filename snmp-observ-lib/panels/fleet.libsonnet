local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    deviceTable:
      signals.fleetInterface.interfacesCount.asTable(name='Network devices', format='table', filterable=true)
      + g.panel.table.panelOptions.withDescription('Network devices overview.')
      + signals.system.sysName.asTableColumn(format='table')
      + signals.system.version.asTableColumn(format='table')
      + signals.system.uptime.asTableColumn(format='table')
      + commonlib.panels.system.table.uptime.stylizeByName('Uptime')
      + signals.cpu.cpuUsage.asTableColumn(format='table')
      + commonlib.panels.generic.table.percentage.stylizeByName('CPU utilization')
      + signals.memory.memoryUsage.asTableColumn(format='table')
      + commonlib.panels.generic.table.percentage.stylizeByName('Memory utilization')
      + signals.fleetInterface.networkOutBitPerSec.asTableColumn(format='table')
      + commonlib.panels.generic.table.coldHotGauge.stylizeByName('Transmitted')
      + signals.fleetInterface.networkInBitPerSec.asTableColumn(format='table')
      + commonlib.panels.generic.table.coldHotGauge.stylizeByName('Received')
      + signals.fleetInterface.networkInErrorsPerSec.asTableColumn(format='table')
      + signals.fleetInterface.networkOutErrorsPerSec.asTableColumn(format='table')
      + signals.fleetInterface.networkInDroppedPerSec.asTableColumn(format='table')
      + signals.fleetInterface.networkOutDroppedPerSec.asTableColumn(format='table')
      + signals.fleetInterface.ifInUnknownProtos.asTableColumn(format='table')
      + {
        options+: {
          sortBy: [
            {
              displayName: 'Transmitted',
              desc: true,
            },
          ],
        },
      },


    traffic:
      signals.fleetInterface.networkOutBitPerSec.withTopK().asTimeSeries('Traffic')
      + signals.fleetInterface.networkInBitPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      //set legend table
      + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max', 'lastNotNull'])
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withSortBy('Mean')
      + g.panel.timeSeries.options.legend.withSortDesc(true),

    errors:
      signals.fleetInterface.networkInErrorsPerSec.withTopK().asTimeSeries('Network errors')
      + signals.fleetInterface.networkOutErrorsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),

    dropped:
      signals.fleetInterface.networkInDroppedPerSec.withTopK().asTimeSeries('Packets dropped')
      + signals.fleetInterface.networkOutDroppedPerSec.withTopK().asPanelMixin()
      + signals.fleetInterface.ifInUnknownProtos.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.dropped.stylize()
      + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),

    packetsUnicast:
      signals.fleetInterface.networkInUnicastPacketsPerSec.withTopK().asTimeSeries('Unicast')
      + signals.fleetInterface.networkOutUnicastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.unicast.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),

    packetsBroadcast:
      signals.fleetInterface.networkInBroadcastPacketsPerSec.withTopK().asTimeSeries('Broadcast')
      + signals.fleetInterface.networkOutBroadcastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.broadcast.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),

    packetsMulticast:
      signals.fleetInterface.networkInMulticastPacketsPerSec.withTopK().asTimeSeries('Multicast')
      + signals.fleetInterface.networkOutMulticastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.multicast.stylize()
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),

  },
}
