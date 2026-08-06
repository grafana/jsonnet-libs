local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local signals = this.signals,
      local stat = g.panel.stat,
      local alertList = g.panel.alertList,

      // create stat panel using commonlib
      successfulBackupsCount:
        signals.clusterOverview.successfulBackups.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('area'),

      failedBackupsCount:
        signals.clusterOverview.failedBackups.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('area'),

      successfulRestores:
        signals.clusterOverview.successfulRestores.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('area'),
      failedRestores:
        signals.clusterOverview.failedRestores.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('area'),

      alertsPanel:
        alertList.new('Velero alerts')
        + alertList.panelOptions.withDescription('Status of firing alerts for Velero.')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topClustersByBackup:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by backups / $__interval',
          targets=[
            signals.clusterOverview.topClustersByBackupSuccess.asTarget(),
            signals.clusterOverview.topClustersByBackupFailure.asTarget(),
            signals.clusterOverview.topClustersByBackupAttempt.asTarget(),
          ],
          description=|||
            The top clusters by number of backups.
          |||
        ),

      topClustersByRestore:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by restores / $__interval',
          targets=[
            signals.clusterOverview.topClustersByRestoreSuccess.asTarget(),
            signals.clusterOverview.topClustersByRestoreFailure.asTarget(),
            signals.clusterOverview.topClustersByRestoreAttempt.asTarget(),
          ],
          description=|||
            Top clusters by number of restores.
          |||
        ),

      topClustersByBackupSize:
        signals.clusterOverview.topClustersByBackupSize.asTimeSeries()
        + commonlib.panels.memory.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      topClustersByVolumeSnapshots:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by volume snapshots / $__interval',
          targets=[
            signals.clusterOverview.topClustersByVolumeSnapshotSuccess.asTarget(),
            signals.clusterOverview.topClustersByVolumeSnapshotFailure.asTarget(),
            signals.clusterOverview.topClustersByVolumeSnapshotAttempt.asTarget(),
          ],
          description=|||
            Top clusters by number of volume snapshots.
          |||
        ),

      topClustersByCSISnapshots:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by CSI snapshots / $__interval',
          targets=[
            signals.clusterOverview.topClustersByCSISnapshotSuccess.asTarget(),
            signals.clusterOverview.topClustersByCSISnapshotFailure.asTarget(),
            signals.clusterOverview.topClustersByCSISnapshotAttempt.asTarget(),
          ],
          description='Top clusters by number of CSI snapshots.'
        ),

      // title, description and unit come from the signal
      backupSuccessRate:
        signals.overview.backupSuccessRateGauge.asGauge()
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.5),
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.9),
        ]),

      restoreSuccessRate:
        signals.overview.restoreSuccessRateGauge.asGauge()
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.5),
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.9),
        ]),

      restoreValidationFailure:
        signals.overview.restoreValidationFailure.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('area'),
      backupValidationFailure:
        signals.overview.backupValidationFailure.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('area'),
      backupCount:
        commonlib.panels.generic.timeSeries.base.new(
          'Backup count / $__interval',
          targets=[
            signals.overview.backupSuccess.asTarget(),
            signals.overview.backupFailure.asTarget(),
            signals.overview.backupAttempt.asTarget(),
          ],
          description=|||
            Number of failed and successful backups.
          |||
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      successfulBackups:
        signals.overview.successfulBackupsStat.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('area'),
      failedBackups:
        signals.overview.failedBackupsStat.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('area'),

      backupSuccessRateTimeseries:
        signals.overview.backupSuccessRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      backupSize:
        signals.overview.backupSize.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      backupTime:
        g.panel.heatmap.new('Backup time')
        + g.panel.heatmap.queryOptions.withTargets([signals.overview.backupTime.asTarget()])
        + g.panel.heatmap.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.heatmap.panelOptions.withDescription('The time it took to create backups.')
        + g.panel.heatmap.options.yAxis.withUnit('s')
        + g.panel.heatmap.options.withLegend('true')
        + g.panel.heatmap.options.withCalculate('true'),

      restoreCount:
        commonlib.panels.generic.timeSeries.base.new(
          'Restore count / $__interval',
          targets=[
            signals.overview.restoreSuccess.asTarget(),
            signals.overview.restoreFailure.asTarget(),
            signals.overview.restoreAttempt.asTarget(),
          ],
          description=|||
            Number of failed and successful restores.
          |||
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      restoreSuccessRateTimeseries:
        signals.overview.restoreSuccessRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      volumeSnapshotCount:
        commonlib.panels.generic.timeSeries.base.new(
          'Volume snapshot count / $__interval',
          targets=[
            signals.overview.volumeSnapshotSuccess.asTarget(),
            signals.overview.volumeSnapshotFailure.asTarget(),
            signals.overview.volumeSnapshotAttempt.asTarget(),
          ],
          description=|||
            Number of failed and successful volume snapshots.
          |||
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      volumeSnapshotSuccessRateTimeseries:
        signals.overview.volumeSnapshotSuccessRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      csiSnapshotCount:
        commonlib.panels.generic.timeSeries.base.new(
          'CSI snapshot count / $__interval',
          targets=[
            signals.overview.csiSnapshotSuccess.asTarget(),
            signals.overview.csiSnapshotFailure.asTarget(),
            signals.overview.csiSnapshotAttempt.asTarget(),
          ],
          description=|||
            Number of failed and successful CSI snapshots.
          |||
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      csiSnapshotSuccessRateTimeseries:
        signals.overview.csiSnapshotSuccessRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),
    },
}
