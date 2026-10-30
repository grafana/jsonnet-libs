local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    cpuUsageTopk:
      signals.cpu.cpuUsage.withTopK(common.fleetTopK).asTimeSeries('CPU usage')
      + commonlib.panels.generic.timeSeries.topkPercentage.stylize()
      + common.topNote
      + common.drillDown,
    loadAverageTopk:
      signals.cpu.loadAverage1m.withTopK(common.fleetTopK).asTimeSeries('Load average 1m')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.fleetLegend
      + common.topNote
      + common.drillDown,
    cpuUsageTs:
      signals.cpu.cpuUsage.asTimeSeries()
      + commonlib.panels.cpu.timeSeries.utilization.stylize(),
    cpuUsageByMode:
      signals.cpu.cpuUsageByMode.asTimeSeries()
      + commonlib.panels.cpu.timeSeries.utilizationByMode.stylize(),
    cpuUsagePerCore:
      signals.cpu.cpuUsagePerCore.asTimeSeries()
      + commonlib.panels.cpu.timeSeries.utilization.stylize(),
    cpuTimeByMode:
      signals.cpu.cpuTimeByMode.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    cpuFrequency:
      signals.cpu.cpuFrequency.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    loadAverage:
      signals.cpu.loadAverage1m.asTimeSeries('Load average')
      + signals.cpu.loadAverage5m.asPanelMixin()
      + signals.cpu.loadAverage15m.asPanelMixin()
      + signals.host.cpuCount.asPanelMixin()
      + commonlib.panels.system.timeSeries.loadAverage.stylize(cpuCountName='.*Cores.*'),
  },
}
