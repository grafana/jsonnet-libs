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
      signals.disk.diskIO.asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioBytesPerSec.stylize()
      + common.hideZeros
      + common.tableLegend,
    diskOperations:
      signals.disk.diskOperations.asTimeSeries()
      + commonlib.panels.disk.timeSeries.iops.stylize()
      + common.hideZeros
      + common.tableLegend,
    diskIOTime:
      signals.disk.diskIOTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    diskWaitTime:
      signals.disk.diskWaitTime.asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioWaitTime.stylize()
      + common.hideZeros,
    diskQueue:
      signals.disk.diskQueue.asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioQueue.stylize()
      + common.hideZeros,
    diskPendingOperations:
      signals.disk.diskPendingOperations.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    diskMerged:
      signals.disk.diskMerged.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
  },
}
