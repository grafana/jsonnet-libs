local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    diskIOTopk:
      signals.disk.diskIOTotal.withTopK(common.fleetTopK).asTimeSeries('Disk I/O')
      + commonlib.panels.disk.timeSeries.ioBytesPerSec.stylize()
      + common.fleetLegend
      + common.topNote
      + common.drillDown,
    diskIO:
      signals.disk.diskIO.asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioBytesPerSec.stylize(),
    diskOperations:
      signals.disk.diskOperations.asTimeSeries()
      + commonlib.panels.disk.timeSeries.iops.stylize(),
    diskIOTime:
      signals.disk.diskIOTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    diskWaitTime:
      signals.disk.diskWaitTime.asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioWaitTime.stylize(),
    diskQueue:
      signals.disk.diskQueue.asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioQueue.stylize(),
    diskPendingOperations:
      signals.disk.diskPendingOperations.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    diskMerged:
      signals.disk.diskMerged.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
