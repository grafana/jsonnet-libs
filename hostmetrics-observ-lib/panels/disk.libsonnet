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
      common.activeInRange('disk', 'diskIO').asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioBytesPerSec.stylize()
      + common.hideZeros
      + common.tableLegend,
    diskOperations:
      common.activeInRange('disk', 'diskOperations').asTimeSeries()
      + commonlib.panels.disk.timeSeries.iops.stylize()
      + common.hideZeros
      + common.tableLegend,
    diskIOTime:
      common.activeInRange('disk', 'diskIOTime').asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    diskWaitTime:
      signals.disk.diskWaitTime.asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioWaitTime.stylize()
      + common.hideZeros,
    diskQueue:
      common.activeInRange('disk', 'diskQueue').asTimeSeries()
      + commonlib.panels.disk.timeSeries.ioQueue.stylize()
      + common.hideZeros,
    diskPendingOperations:
      signals.disk.diskPendingOperations.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros,
    diskMerged:
      common.activeInRange('disk', 'diskMerged').asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.hideZeros
      + common.tableLegend,
  },
}
