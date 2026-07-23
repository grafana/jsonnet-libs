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
        commonlib.panels.generic.stat.info.new(
          'Successful backups / $__interval ',
          targets=[signals.clusterOverview.succesfulBackups.asTarget()],
          description='Number of successful backups across all clusters.'
        )
        + stat.options.withGraphMode('area'),

      failedBackupsCount:
        commonlib.panels.generic.stat.info.new(
          'Failed backups / $__interval ',
          targets=[signals.clusterOverview.failedBackups.asTarget()],
          description='Number of failed backups across all clusters'
        )
        + stat.options.withGraphMode('area'),

      successfulRestores:
        commonlib.panels.generic.stat.info.new(
          'Succesful restores / $__interval ',
          targets=[signals.clusterOverview.succesfulRestores.asTarget()],
          description='Number of succesful restores across all clusters.'
        )
        + stat.options.withGraphMode('area'),
      failedRestores:
        commonlib.panels.generic.stat.info.new(
          'Failed restores / $__interval ',
          targets=[signals.clusterOverview.failedRestores.asTarget()],
          description='Number of failed restores across all clusters.'
        )
        + stat.options.withGraphMode('area'),

      alertsPanel:
        alertList.new('Velero alerts')
        + alertList.panelOptions.withDescription('Status of firing alerts for Velero.')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topClustersByBackup:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by backups / $__interval ',
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
          'Top clusters by restores / $__interval ',
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
        commonlib.panels.memory.timeSeries.base.new(
          'Top clusters by backup size',
          targets=[signals.clusterOverview.topClustersByBackupSize.asTarget()],
          description=|||
            Top clusters by size of backups.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      topClustersByVolumeSnapshots:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by volume snapshots / $__interval ',
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
          'Top clusters by CSI snapshots / $__interval ',
          targets=[
            signals.clusterOverview.topClustersByCSISnapshotSuccess.asTarget(),
            signals.clusterOverview.topClustersByCSISnapshotFailure.asTarget(),
            signals.clusterOverview.topClustersByCSISnapshotAttempt.asTarget(),
          ],
          description='Top clusters by number of CSI snapshots.'
        ),

      backupSuccessRate:
        g.panel.gauge.new('Backup success rate (1 hour)')
        + g.panel.gauge.queryOptions.withTargets([signals.overview.backupSuccessRateGauge.asTarget()])
        + g.panel.gauge.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.gauge.panelOptions.withDescription('Success rate of backups within the instance in the past hour.')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.5),
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.9),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),

      restoreSuccessRate:
        g.panel.gauge.new('Restore success rate (1 hour)')
        + g.panel.gauge.queryOptions.withTargets([signals.overview.restoreSuccessRateGauge.asTarget()])
        + g.panel.gauge.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.gauge.panelOptions.withDescription('Success rate of restores within the instance in the past hour.')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.5),
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.9),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),

      restoreValidationFailure:
        commonlib.panels.generic.stat.info.new(
          'Restore validation failure / $__interval ',
          targets=[signals.overview.restoreValidationFailure.asTarget()],
          description='Number of failed restore validations.'
        )
        + stat.options.withGraphMode('area'),
      backupValidationFailure:
        commonlib.panels.generic.stat.info.new(
          'Backup validation failure / $__interval ',
          targets=[signals.overview.backupValidationFailure.asTarget()],
          description='Number of failed backup validations.'
        )
        + stat.options.withGraphMode('area'),
      backupCount:
        commonlib.panels.generic.timeSeries.base.new(
          'Backup count / $__interval ',
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
        commonlib.panels.generic.stat.info.new(
          'Successful backups / $__interval ',
          targets=[signals.overview.succesfulBackupsStat.asTarget()],
          description='Number of successful backups.'
        )
        + stat.options.withGraphMode('area'),
      failedBackups:
        commonlib.panels.generic.stat.info.new(
          'Failed backups / $__interval ',
          targets=[signals.overview.failedBackupsStat.asTarget()],
          description='Number of failed backups.'
        )
        + stat.options.withGraphMode('area'),

      backupSuccessRateTimeseries:
        commonlib.panels.generic.timeSeries.base.new(
          'Backup success rate / $__interval',
          targets=[signals.overview.backupSuccessRate.asTarget()],
          description=|||
            Success rate of backups.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      backupSize:
        commonlib.panels.generic.timeSeries.base.new(
          'Backup size',
          targets=[signals.overview.backupSize.asTarget()],
          description=|||
            Size of backups for this clusters given schedule.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),

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
          'Restore count / $__interval ',
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
        commonlib.panels.generic.timeSeries.base.new(
          'Restore success rate / $__interval',
          targets=[signals.overview.restoreSuccessRate.asTarget()],
          description=|||
            Success rate of restores.
          |||
        ) + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      volumeSnapshotCount:
        commonlib.panels.generic.timeSeries.base.new(
          'Volume snapshot count / $__interval ',
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
        commonlib.panels.generic.timeSeries.base.new(
          'Volume snapshot success rate / $__interval',
          targets=[signals.overview.volumeSnapshotSuccessRate.asTarget()],
          description=|||
            Success rate of volume snapshots.
          |||
        ) + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      csiSnapshotCount:
        commonlib.panels.generic.timeSeries.base.new(
          'CSI snapshot count / $__interval ',
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
        commonlib.panels.generic.timeSeries.base.new(
          'CSI snapshot success rate / $__interval',
          targets=[signals.overview.csiSnapshotSuccessRate.asTarget()],
          description=|||
            Success rate of CSI snapshots.
          |||
        ) + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),
    },
}
