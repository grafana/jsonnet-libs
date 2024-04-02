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
          'Successful backups',
          targets=[t.succesfulBackups],
          description='Number of successful backups'
        )
        + stat.options.withGraphMode('area'),

      failedBackups:
        commonlib.panels.generic.stat.info.new(
          'Failed backups',
          targets=[t.failedBackups],
          description='Number of failed backups.'
        )
        + stat.options.withGraphMode('area'),

      successfulRestores:
        commonlib.panels.generic.stat.info.new(
          'Succesful restores',
          targets=[t.succesfulRestores],
          description='Number of succesful restores.'
        )
        + stat.options.withGraphMode('area'),
      failedRestores:
        commonlib.panels.generic.stat.info.new(
          'Failed restores',
          targets=[t.failedRestores],
          description='Number of failed restores'
        )
        + stat.options.withGraphMode('area'),

      alertsPanel:
        alertList.new('Velero alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topClustersByBackup:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by backups',
          targets=[t.topClustersByBackupSuccess, t.topClustersByBackupFailure],
          description=|||
            The top clusters by number of backups.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      topClustersByRestore:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by restores',
          targets=[t.topClustersByRestoreSuccess, t.topClustersByRestoreFailure],
          description=|||
            Top clusters by number of restores.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

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
          'Top clusters by volume snapshots',
          targets=[t.topClustersByVolumeSnapshotSuccess, t.topClustersByVolumeSnapshotFailure],
          description=|||
            Top clusters by number of volume snapshots.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      topClustersByCSISnapshots:
        commonlib.panels.generic.timeSeries.base.new(
          'Top clusters by CSI snapshots',
          targets=[t.topClustersByCSISnapshotSuccess, t.topClustersByCSISnapshotFailure],
          description='Top clusters by number of CSI snapshots.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),
    },
}
