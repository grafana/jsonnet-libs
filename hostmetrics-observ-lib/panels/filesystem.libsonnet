local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,

    filesystemUsageTopk:
      signals.filesystem.filesystemUsagePercent.withTopK(common.fleetTopK).asTimeSeries('Disk space usage')
      + commonlib.panels.generic.timeSeries.topkPercentage.stylize()
      + common.topNote
      + common.drillDown,
    rootFilesystemSize:
      signals.filesystem.rootFilesystemSize.asStat()
      + commonlib.panels.disk.stat.total.stylize()
      + common.capacityTextSize,
    filesystemUsagePercent:
      signals.filesystem.filesystemUsagePercent.asTimeSeries()
      + commonlib.panels.disk.timeSeries.usagePercent.stylize(),
    filesystemAvailable:
      signals.filesystem.filesystemAvailable.asTimeSeries()
      + commonlib.panels.disk.timeSeries.available.stylize(),
    filesystemUsageByState:
      signals.filesystem.filesystemUsageByState.asTimeSeries()
      + commonlib.panels.disk.timeSeries.usage.stylize(),
    inodesFree:
      signals.filesystem.inodesFree.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    inodesTotal:
      signals.filesystem.inodesTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
