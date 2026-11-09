local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    networkIOTopk:
      signals.network.networkIOTotal.withTopK(common.fleetTopK).asTimeSeries('Network traffic')
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + common.tableLegend
      + common.topNote
      + common.drillDown
      + common.hideZeros,
    networkErrorsAndDroppedTopk:
      common.activeInRange('network', 'networkErrorsTotal').withTopK(common.fleetTopK).asTimeSeries('Network errors and dropped packets')
      + common.activeInRange('network', 'networkDroppedTotal').withTopK(common.fleetTopK).asPanelMixin()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + common.tableLegend
      + common.hideZeros
      + common.topNote
      + common.drillDown,
    networkIO:
      common.activeInRange('network', 'networkIO').asTimeSeries()
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + common.hideZeros
      + common.tableLegend,
    networkPackets:
      common.activeInRange('network', 'networkPackets').asTimeSeries()
      + commonlib.panels.network.timeSeries.packets.stylize()
      + common.hideZeros
      + common.tableLegend,
    networkErrors:
      common.activeInRange('network', 'networkErrors').asTimeSeries()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + common.hideZeros,
    networkDropped:
      common.activeInRange('network', 'networkDropped').asTimeSeries()
      + commonlib.panels.network.timeSeries.dropped.stylize()
      + common.hideZeros,
    networkConnections:
      common.activeInRange('network', 'networkConnections').asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    conntrack:
      signals.network.conntrackCount.asTimeSeries('NF conntrack')
      + signals.network.conntrackMax.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
  },
}
