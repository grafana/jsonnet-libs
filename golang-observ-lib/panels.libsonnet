local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):
    {
      version: signals.version.asStat(),
      goRoutines:
        signals.goRoutines.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.standardOptions.withDecimals(0),
      uptime:
        signals.uptime.asStat()
        + commonlib.panels.system.stat.uptime.stylize(),
      cGo:
        signals.cgoCalls.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.timeSeries.standardOptions.withNoValue('0'),
      gcDuration:
        g.panel.timeSeries.new('GC duration')
        + g.panel.timeSeries.panelOptions.withDescription(
          |||
            Amount of time in GC stop-the-world pauses.
            During a stop-the-world pause, all goroutines are paused and only the garbage collector can run
          |||
        )
        + signals.gcDurationMax.asPanelMixin()
        + signals.gcDurationMin.asPanelMixin()
        + signals.gcDurationPercentile.asPanelMixin()
        + commonlib.panels.generic.timeSeries.base.stylize(),
      goThreads:
        signals.goThreads.asStat()
        + commonlib.panels.generic.stat.base.stylize(),
      mem:
        g.panel.timeSeries.new('Memory')
        + g.panel.timeSeries.panelOptions.withDescription('Memory reserved from system.')
        + signals.memReserved.asPanelMixin()
        + signals.memTotal.asPanelMixin()
        + commonlib.panels.memory.timeSeries.usageBytes.stylize(),

      memHeapBytes:
        g.panel.timeSeries.new('Memory heap')
        + g.panel.timeSeries.panelOptions.withDescription('Memory used heap.')
        + signals.memHeapReserved.asPanelMixin()
        + signals.memHeapObjBytes.asPanelMixin()
        + signals.memHeapIdleBytes.asPanelMixin()
        + signals.memHeapInUseBytes.asPanelMixin()
        + signals.memHeapReleasedBytes.asPanelMixin()
        + commonlib.panels.memory.timeSeries.usageBytes.stylize(),

      memHeapObjects:
        g.panel.timeSeries.new('Memory heap objects')
        + signals.memHeapAllocatedObjects.asPanelMixin()
        // + signals.memHeapLiveObjects.asPanelMixin()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      memOffHeap:
        g.panel.timeSeries.new('Memory off-heap')
        + signals.memMspan.asPanelMixin()
        + signals.memMcache.asPanelMixin()
        + signals.memBuckHash.asPanelMixin()
        + signals.memGc.asPanelMixin()
        + signals.memOther.asPanelMixin()
        + commonlib.panels.memory.timeSeries.usageBytes.stylize(),

      memStack:
        g.panel.timeSeries.new('Memory stack')
        + signals.memStack.asPanelMixin()
        + commonlib.panels.memory.timeSeries.usageBytes.stylize(),

      // memoryObjectAllocationRate:
      //   this.signals[type].memoryAllocations.asTimeSeries()
      //   + commonlib.panels.generic.timeSeries.base.stylize(),

      // nextGC:
      //   this.signals[type].nextGC.asTimeSeries()
      //   + commonlib.panels.memory.timeSeries.usageBytes.stylize(),

    },
}
