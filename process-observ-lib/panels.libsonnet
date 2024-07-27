local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):
    {
      uptime:
        signals.process.uptime.asStat()
        + commonlib.panels.system.stat.uptime.stylize(),
      startTime:
        signals.process.startTime.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      loadAverage:
        signals.system.loadAverage1m.asTimeSeries()
        + signals.system.systemCPUCount.asPanelMixin()
        + commonlib.panels.system.timeSeries.loadAverage.stylize(cpuCountName='.*CPU count.*'),

      cpuUsage:
        signals.process.processCPUUsage.asTimeSeries()
        + signals.system.systemCPUUsage.asPanelMixin()
        + commonlib.panels.cpu.timeSeries.utilization.stylize(),

      memoryUsage:
        signals.process.memoryUsedResident.asTimeSeries()
        + signals.process.memoryUsedVirtual.asPanelMixin()
        + commonlib.panels.memory.timeSeries.usageBytes.stylize(),

      filesUsed:
        g.panel.timeSeries.new('Process files open')
        + signals.process.filesMax.asPanelMixin()
        + signals.process.filesOpen.asPanelMixin()
        + commonlib.panels.generic.timeSeries.base.stylize(),
    },
}
