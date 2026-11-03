local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    memoryUsageTopk:
      signals.memory.memoryUsagePercent.withTopK(common.fleetTopK).asTimeSeries('Memory usage')
      + commonlib.panels.generic.timeSeries.topkPercentage.stylize()
      + common.topNote
      + common.drillDown
      + common.hideZeros,
    memoryTotal:
      signals.memory.memoryTotal.asStat()
      + commonlib.panels.memory.stat.total.stylize()
      + common.capacityTextSize,
    memoryUsageTs:
      signals.memory.memoryUsagePercent.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usagePercent.stylize()
      + common.hideZeros,
    memoryUsageByState:
      signals.memory.memoryUsageByState.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize()
      + common.hideZeros,
    memoryAvailable:
      signals.memory.memoryAvailable.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize()
      + common.hideZeros,
    memoryTotalTs:
      signals.memory.memoryTotal.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize()
      + common.hideZeros,
    memoryDirtyAndShared:
      signals.memory.memoryDirty.asTimeSeries('Memory dirty and shared')
      + signals.memory.memoryShared.asPanelMixin()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize()
      + common.hideZeros,
    swapUsage:
      signals.memory.swapUsage.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize()
      + common.hideZeros,
    pagingOperations:
      common.activeInRange(signals.memory.pagingOperations).asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    pageFaults:
      common.activeInRange(signals.memory.pageFaults).asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
  },
}
