local g = import './g.libsonnet';
{
  new(this):
    {
      local panels = this.grafana.panels,

      clusterSummary: [
        panels.successfulBackupsCount { gridPos+: { w: 4, h: 4 } },
        panels.failedBackupsCount { gridPos+: { w: 4, h: 4 } },
        panels.successfulRestores { gridPos+: { w: 4, h: 4 } },
        panels.failedRestores { gridPos+: { w: 4, h: 4 } },
        panels.alertsPanel { gridPos+: { w: 8, h: 4 } },
      ],

      topClusters:
        g.panel.row.new('Top clusters')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.topClustersByBackup,
          panels.topClustersByRestore,
          panels.topClustersByBackupSize { gridPos+: { w: 24 } },
          panels.topClustersByVolumeSnapshots,
          panels.topClustersByCSISnapshots,
        ]),

      overviewSummary: [
        panels.backupSuccessRate { gridPos+: { w: 4, h: 4 } },
        panels.restoreSuccessRate { gridPos+: { w: 4, h: 4 } },
        panels.successfulBackups { gridPos+: { w: 4, h: 4 } },
        panels.failedBackups { gridPos+: { w: 4, h: 4 } },
        panels.restoreValidationFailure { gridPos+: { w: 4, h: 4 } },
        panels.backupValidationFailure { gridPos+: { w: 4, h: 4 } },
      ],

      backup:
        g.panel.row.new('Backup')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.backupCount { gridPos+: { w: 16 } },
          panels.backupSuccessRateTimeseries { gridPos+: { w: 8 } },
          panels.backupSize { gridPos+: { w: 24 } },
          panels.backupTime { gridPos+: { w: 24 } },
        ]),

      restore:
        g.panel.row.new('Restore')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.restoreCount { gridPos+: { w: 16 } },
          panels.restoreSuccessRateTimeseries { gridPos+: { w: 8 } },
        ]),

      csiSnapshots:
        g.panel.row.new('CSI snapshots')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.csiSnapshotCount { gridPos+: { w: 16 } },
          panels.csiSnapshotSuccessRateTimeseries { gridPos+: { w: 8 } },
        ]),

      volumeSnapshots:
        g.panel.row.new('Volume snapshots')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.volumeSnapshotCount { gridPos+: { w: 16 } },
          panels.volumeSnapshotSuccessRateTimeseries { gridPos+: { w: 8 } },
        ]),
    },
}
