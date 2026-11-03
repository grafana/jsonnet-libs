local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    cpuUsageTopk:
      signals.cpu.cpuUsage.withTopK(common.fleetTopK).asTimeSeries('CPU usage')
      + commonlib.panels.generic.timeSeries.topkPercentage.stylize()
      + common.topNote
      + common.drillDown
      + common.hideZeros,
    loadAverageTopk:
      signals.cpu.loadAverage1m.withTopK(common.fleetTopK).asTimeSeries('Load average 1m')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.tableLegend
      + common.topNote
      + common.drillDown
      + common.hideZeros,
    cpuUsageTs:
      signals.cpu.cpuUsage.asTimeSeries()
      + commonlib.panels.cpu.timeSeries.utilization.stylize()
      + common.hideZeros,
    cpuUsageByMode:
      common.activeInRange(signals.cpu.cpuUsageByMode).asTimeSeries()
      + commonlib.panels.cpu.timeSeries.utilizationByMode.stylize()
      + common.hideZeros,
    cpuUsagePerCore:
      signals.cpu.cpuUsagePerCore.asTimeSeries()
      + commonlib.panels.cpu.timeSeries.utilization.stylize()
      + common.hideZeros
      + common.tableLegend,
    cpuTimeByMode:
      common.activeInRange(signals.cpu.cpuTimeByMode).asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    cpuFrequency:
      common.activeInRange(signals.cpu.cpuFrequency).asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros
      + common.tableLegend,
    loadAverage:
      signals.cpu.loadAverage1m.asTimeSeries('Load average')
      + signals.cpu.loadAverage5m.asPanelMixin()
      + signals.cpu.loadAverage15m.asPanelMixin()
      + signals.host.cpuCount.asPanelMixin()
      + commonlib.panels.system.timeSeries.loadAverage.stylize(cpuCountName='.*Cores.*')
      + common.hideZeros,
  },
}
