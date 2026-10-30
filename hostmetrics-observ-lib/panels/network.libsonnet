local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    networkIOTopk:
      signals.network.networkIOTotal.withTopK(common.fleetTopK).asTimeSeries('Network traffic')
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + common.fleetLegend
      + common.topNote
      + common.drillDown,
    networkErrorsAndDroppedTopk:
      signals.network.networkErrorsTotal.withTopK(common.fleetTopK).asTimeSeries('Network errors and dropped packets')
      + signals.network.networkDroppedTotal.withTopK(common.fleetTopK).asPanelMixin()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + common.fleetLegend
      + common.topNote
      + common.drillDown,
    networkIO:
      signals.network.networkIO.asTimeSeries()
      + commonlib.panels.network.timeSeries.traffic.stylize(),
    networkPackets:
      signals.network.networkPackets.asTimeSeries()
      + commonlib.panels.network.timeSeries.packets.stylize(),
    networkErrors:
      signals.network.networkErrors.asTimeSeries()
      + commonlib.panels.network.timeSeries.errors.stylize(),
    networkDropped:
      signals.network.networkDropped.asTimeSeries()
      + commonlib.panels.network.timeSeries.dropped.stylize(),
    networkConnections:
      signals.network.networkConnections.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    conntrack:
      signals.network.conntrackCount.asTimeSeries('NF conntrack')
      + signals.network.conntrackMax.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
