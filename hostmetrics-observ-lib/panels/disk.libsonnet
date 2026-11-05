local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    diskIOTopk:
      signals.disk.diskIOTotal.withTopK(common.fleetTopK).asTimeSeries('Disk I/O')
      + commonlib.panels.disk.timeSeries.ioBytesPerSec.stylize()
      + common.tableLegend
      + common.topNote
      + common.drillDown
      + common.hideZeros,
    diskIO:
      common.activeInRange(signals.disk.diskIO).asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioBytesPerSec.stylize()
      + common.hideZeros
      + common.tableLegend,
    diskOperations:
      common.activeInRange(signals.disk.diskOperations).asTimeSeries()
      + commonlib.panels.disk.timeSeries.iops.stylize()
      + common.hideZeros
      + common.tableLegend,
    diskIOTime:
      common.activeInRange(signals.disk.diskIOTime).asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    diskWaitTime:
      common.activeInRange(signals.disk.diskWaitTime).asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioWaitTime.stylize()
      + common.hideZeros,
    diskQueue:
      common.activeInRange(signals.disk.diskQueue).asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioQueue.stylize()
      + common.hideZeros,
    diskPendingOperations:
      signals.disk.diskPendingOperations.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    diskMerged:
      common.activeInRange(signals.disk.diskMerged).asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros
      + common.tableLegend,
  },
}
