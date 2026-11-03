local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    networkIOTopk:
      signals.network.networkIOTotal.withTopK(common.fleetTopK).asTimeSeries('Network traffic')
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + common.fleetLegend
      + common.topNote
      + common.drillDown
      + common.hideZeros,
    networkErrorsAndDroppedTopk:
      common.activeInRange(signals.network.networkErrorsTotal).withTopK(common.fleetTopK).asTimeSeries('Network errors and dropped packets')
      + common.activeInRange(signals.network.networkDroppedTotal).withTopK(common.fleetTopK).asPanelMixin()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + common.fleetLegend
      + common.hideZeros
      + common.topNote
      + common.drillDown,
    networkIO:
      common.activeInRange(signals.network.networkIO).asTimeSeries()
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + common.hideZeros,
    networkPackets:
      common.activeInRange(signals.network.networkPackets).asTimeSeries()
      + commonlib.panels.network.timeSeries.packets.stylize()
      + common.hideZeros,
    networkErrors:
      common.activeInRange(signals.network.networkErrors).asTimeSeries()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + common.hideZeros,
    networkDropped:
      common.activeInRange(signals.network.networkDropped).asTimeSeries()
      + commonlib.panels.network.timeSeries.dropped.stylize()
      + common.hideZeros,
    networkConnections:
      common.activeInRange(signals.network.networkConnections).asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    conntrack:
      signals.network.conntrackCount.asTimeSeries('NF conntrack')
      + signals.network.conntrackMax.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
  },
}
