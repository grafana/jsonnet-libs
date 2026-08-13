// Signals for the Velero cluster view dashboard.
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    // cluster view panels aggregate across instances: queries select on group labels only
    instanceLabels: [],
    enableLokiLogs: this.enableLokiLogs,
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'sum',
    rangeFunction: 'increase',
    discoveryMetric: {
      prometheus: 'velero_backup_success_total',
    },
    signals: {
      successfulBackups: {
        name: 'Successful backups / $__interval',
        nameShort: 'Backups',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Number of successful backups across all clusters.',
        sources: {
          prometheus: {
            expr: 'velero_backup_success_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            legendCustomTemplate: 'Backups',
          },
        },
      },
      failedBackups: {
        name: 'Failed backups / $__interval',
        nameShort: 'Backups',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Number of failed backups across all clusters',
        sources: {
          prometheus: {
            expr: 'velero_backup_failure_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            legendCustomTemplate: 'Backups',
          },
        },
      },
      successfulRestores: {
        name: 'Successful restores / $__interval',
        nameShort: 'Restores',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Number of successful restores across all clusters.',
        sources: {
          prometheus: {
            expr: 'velero_restore_success_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            legendCustomTemplate: 'Restores',
          },
        },
      },
      failedRestores: {
        name: 'Failed restores / $__interval',
        nameShort: 'Restores',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Number of failed restores across all clusters.',
        sources: {
          prometheus: {
            expr: 'velero_restore_failed_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            legendCustomTemplate: 'Restores',
          },
        },
      },
      topClustersByBackupSuccess: {
        name: 'Top clusters by backup success',
        nameShort: 'Backup success',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of successful backups.',
        sources: {
          prometheus: {
            expr: 'velero_backup_success_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - success',
          },
        },
      },
      topClustersByBackupAttempt: {
        name: 'Top clusters by backup attempts',
        nameShort: 'Backup attempts',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of attempted backups.',
        sources: {
          prometheus: {
            expr: 'velero_backup_attempt_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - attempt',
          },
        },
      },
      topClustersByBackupFailure: {
        name: 'Top clusters by backup failures',
        nameShort: 'Backup failures',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of failed backups.',
        sources: {
          prometheus: {
            expr: 'velero_backup_failure_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - failure',
          },
        },
      },
      topClustersByRestoreSuccess: {
        name: 'Top clusters by restore success',
        nameShort: 'Restore success',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of successful restores.',
        sources: {
          prometheus: {
            expr: 'velero_restore_success_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - success',
          },
        },
      },
      topClustersByRestoreAttempt: {
        name: 'Top clusters by restore attempts',
        nameShort: 'Restore attempts',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of attempted restores.',
        sources: {
          prometheus: {
            // preserved from the legacy dashboard: queries the success metric, not attempts
            expr: 'velero_restore_success_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - attempt',
          },
        },
      },
      topClustersByRestoreFailure: {
        name: 'Top clusters by restore failures',
        nameShort: 'Restore failures',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of failed restores.',
        sources: {
          prometheus: {
            expr: 'velero_restore_failed_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - failure',
          },
        },
      },
      topClustersByBackupSize: {
        name: 'Top clusters by backup size',
        nameShort: 'Backup size',
        type: 'gauge',
        aggLevel: 'aggKeepLabels',
        unit: 'decbytes',
        description: 'Top clusters by size of backups.',
        sources: {
          prometheus: {
            expr: 'velero_backup_tarball_size_bytes{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}}',
          },
        },
      },
      topClustersByVolumeSnapshotSuccess: {
        name: 'Top clusters by volume snapshot success',
        nameShort: 'Volume snapshot success',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of successful volume snapshots.',
        sources: {
          prometheus: {
            expr: 'velero_volume_snapshot_success_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - success',
          },
        },
      },
      topClustersByVolumeSnapshotFailure: {
        name: 'Top clusters by volume snapshot failures',
        nameShort: 'Volume snapshot failures',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of failed volume snapshots.',
        sources: {
          prometheus: {
            expr: 'velero_volume_snapshot_failure_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - failure',
          },
        },
      },
      topClustersByVolumeSnapshotAttempt: {
        name: 'Top clusters by volume snapshot attempts',
        nameShort: 'Volume snapshot attempts',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of attempted volume snapshots.',
        sources: {
          prometheus: {
            expr: 'velero_volume_snapshot_attempt_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - attempt',
          },
        },
      },
      topClustersByCSISnapshotSuccess: {
        name: 'Top clusters by CSI snapshot success',
        nameShort: 'CSI snapshot success',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of successful CSI snapshots.',
        sources: {
          prometheus: {
            expr: 'velero_csi_snapshot_success_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - success',
          },
        },
      },
      topClustersByCSISnapshotAttempt: {
        name: 'Top clusters by CSI snapshot attempts',
        nameShort: 'CSI snapshot attempts',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of attempted CSI snapshots.',
        sources: {
          prometheus: {
            expr: 'velero_csi_snapshot_attempt_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - attempt',
          },
        },
      },
      topClustersByCSISnapshotFailure: {
        name: 'Top clusters by CSI snapshot failures',
        nameShort: 'CSI snapshot failures',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Top clusters by number of failed CSI snapshots.',
        sources: {
          prometheus: {
            expr: 'velero_csi_snapshot_failure_total{%(queriesSelector)s}',
            aggKeepLabels: ['cluster'],
            exprWrappers: [['topk by(cluster)($top_cluster_count, ', ')']],
            legendCustomTemplate: '{{cluster}} - failure',
          },
        },
      },
    },
  }
