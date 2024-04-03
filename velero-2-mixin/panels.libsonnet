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

      failedBackups:
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
          targets=[t.topClustersByBackupSuccess, t.topClustersByBackupFailure],
          description=|||
            The top clusters by number of backups.
          |||
        ),

      topClustersByRestore:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by restores / $__interval ',
          targets=[t.topClustersByRestoreSuccess, t.topClustersByRestoreFailure],
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
          targets=[t.topClustersByVolumeSnapshotSuccess, t.topClustersByVolumeSnapshotFailure],
          description=|||
            Top clusters by number of volume snapshots.
          |||
        ),

      topClustersByCSISnapshots:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by CSI snapshots / $__interval ',
          targets=[t.topClustersByCSISnapshotSuccess, t.topClustersByCSISnapshotFailure],
          description='Top clusters by number of CSI snapshots.'
        ),
    },
}
