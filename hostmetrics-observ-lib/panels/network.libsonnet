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
      signals.network.networkErrorsTotal.withTopK(common.fleetTopK).withExprWrappersMixin(common.nonZero).asTimeSeries('Network errors and dropped packets')
      + signals.network.networkDroppedTotal.withTopK(common.fleetTopK).withExprWrappersMixin(common.nonZero).asPanelMixin()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + common.fleetLegend
      + common.hideZeros
      + common.topNote
      + common.drillDown,
    networkIO:
      signals.network.networkIO.asTimeSeries()
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + common.activeInRange(signals.network.networkIO)
      + common.hideZeros,
    networkPackets:
      signals.network.networkPackets.asTimeSeries()
      + commonlib.panels.network.timeSeries.packets.stylize()
      + common.activeInRange(signals.network.networkPackets)
      + common.hideZeros,
    networkErrors:
      signals.network.networkErrors.withExprWrappersMixin(common.nonZero).asTimeSeries()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + common.hideZeros,
    networkDropped:
      signals.network.networkDropped.withExprWrappersMixin(common.nonZero).asTimeSeries()
      + commonlib.panels.network.timeSeries.dropped.stylize()
      + common.hideZeros,
    networkConnections:
      signals.network.networkConnections.withExprWrappersMixin(common.nonZero).asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    conntrack:
      signals.network.conntrackCount.asTimeSeries('NF conntrack')
      + signals.network.conntrackMax.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
  },
}
