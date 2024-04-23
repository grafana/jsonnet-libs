local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
      local stat = g.panel.stat,
      local alertList = g.panel.alertList,

      // create stat panel using commonlib
      successfulBackupsCount:
        commonlib.panels.generic.stat.info.new(
          'Successful backups / $__interval ',
          targets=[t.succesfulBackups],
          description='Number of successful backups across all clusters.'
        )
        + stat.options.withGraphMode('area'),

      failedBackupsCount:
        commonlib.panels.generic.stat.info.new(
          'Failed backups / $__interval ',
          targets=[t.failedBackups],
          description='Number of failed backups across all clusters'
        )
        + stat.options.withGraphMode('area'),

      successfulRestores:
        commonlib.panels.generic.stat.info.new(
          'Succesful restores / $__interval ',
          targets=[t.succesfulRestores],
          description='Number of succesful restores across all clusters.'
        )
        + stat.options.withGraphMode('area'),
      failedRestores:
        commonlib.panels.generic.stat.info.new(
          'Failed restores / $__interval ',
          targets=[t.failedRestores],
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
          targets=[t.topClustersByBackupSuccess, t.topClustersByBackupFailure, t.topClustersByBackupAttempt],
          description=|||
            The top clusters by number of backups.
          |||
        ),

      topClustersByRestore:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by restores / $__interval ',
          targets=[t.topClustersByRestoreSuccess, t.topClustersByRestoreFailure, t.topClustersByRestoreAttempt],
          description=|||
            Top clusters by number of restores.
          |||
        ),

      topClustersByBackupSize:
        commonlib.panels.memory.timeSeries.base.new(
          'Top clusters by backup size',
          targets=[t.topClustersByBackupSize],
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
          targets=[t.topClustersByVolumeSnapshotSuccess, t.topClustersByVolumeSnapshotFailure, t.topClustersByVolumeSnapshotAttempt],
          description=|||
            Top clusters by number of volume snapshots.
          |||
        ),

      topClustersByCSISnapshots:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by CSI snapshots / $__interval ',
          targets=[t.topClustersByCSISnapshotSuccess, t.topClustersByCSISnapshotFailure, t.topClustersByCSISnapshotAttempt],
          description='Top clusters by number of CSI snapshots.'
        ),

      backupSuccessRate:
        g.panel.gauge.new('Backup success rate (1 hour)')
        + g.panel.gauge.queryOptions.withTargets([t.backupSuccessRateGauge])
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
        + g.panel.gauge.queryOptions.withTargets([t.restoreSuccessRateGauge])
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
          targets=[t.restoreValidationFailure],
          description='Number of failed restore validations.'
        )
        + stat.options.withGraphMode('area'),
      backupValidationFailure:
        commonlib.panels.generic.stat.info.new(
          'Backup validation failure / $__interval ',
          targets=[t.backupValidationFailure],
          description='Number of failed backup validations.'
        )
        + stat.options.withGraphMode('area'),
      backupCount:
        commonlib.panels.generic.timeSeries.base.new(
          'Backup count / $__interval ',
          targets=[t.backupSuccess, t.backupFailure, t.backupAttempt],
          description=|||
            Number of failed and successful backups.
          |||
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      successfulBackups:
        commonlib.panels.generic.stat.info.new(
          'Successful backups / $__interval ',
          targets=[t.succesfulBackupsStat],
          description='Number of successful backups.'
        )
        + stat.options.withGraphMode('area'),
      failedBackups:
        commonlib.panels.generic.stat.info.new(
          'Failed backups / $__interval ',
          targets=[t.failedBackupsStat],
          description='Number of failed backups.'
        )
        + stat.options.withGraphMode('area'),

      backupSuccessRateTimeseries:
        commonlib.panels.generic.timeSeries.base.new(
          'Backup success rate / $__interval',
          targets=[t.backupSuccessRate],
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
          targets=[t.backupSize],
          description=|||
            Size of backups for this clusters given schedule.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),

      backupTime:
        g.panel.heatmap.new('Backup time')
        + g.panel.heatmap.queryOptions.withTargets([t.backupTime])
        + g.panel.heatmap.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.heatmap.panelOptions.withDescription('The time it took to create backups.')
        + g.panel.heatmap.options.yAxis.withUnit('s')
        + g.panel.heatmap.options.withLegend('true')
        + g.panel.heatmap.options.withCalculate('true'),

      restoreCount:
        commonlib.panels.generic.timeSeries.base.new(
          'Restore count / $__interval ',
          targets=[t.restoreSuccess, t.restoreFailure, t.restoreAttempt],
          description=|||
            Number of failed and successful restores.
          |||
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      restoreSuccessRateTimeseries:
        commonlib.panels.generic.timeSeries.base.new(
          'Restore success rate / $__interval',
          targets=[t.restoreSuccessRate],
          description=|||
            Success rate of restores.
          |||
        ) + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      volumeSnapshotCount:
        commonlib.panels.generic.timeSeries.base.new(
          'Volume snapshot count / $__interval ',
          targets=[t.volumeSnapshotSuccess, t.volumeSnapshotFailure, t.volumeSnapshotAttempt],
          description=|||
            Number of failed and successful volume snapshots.
          |||
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      volumeSnapshotSuccessRateTimeseries:
        commonlib.panels.generic.timeSeries.base.new(
          'Volume snapshot success rate / $__interval',
          targets=[t.volumeSnapshotSuccessRate],
          description=|||
            Success rate of volume snapshots.
          |||
        ) + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      csiSnapshotCount:
        commonlib.panels.generic.timeSeries.base.new(
          'CSI snapshot count / $__interval ',
          targets=[t.csiSnapshotSuccess, t.csiSnapshotFailure, t.csiSnapshotAttempt],
          description=|||
            Number of failed and successful CSI snapshots.
          |||
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      csiSnapshotSuccessRateTimeseries:
        commonlib.panels.generic.timeSeries.base.new(
          'CSI snapshot success rate / $__interval',
          targets=[t.csiSnapshotSuccessRate],
          description=|||
            Success rate of CSI snapshots.
          |||
        ) + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),
    },
}
