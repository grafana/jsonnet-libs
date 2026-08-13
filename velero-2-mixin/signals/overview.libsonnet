// Signals for the Velero overview dashboard.
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    // overview panels additionally filter by the dashboard-level schedule variable
    instanceLabels: this.instanceLabels + ['schedule'],
    enableLokiLogs: this.enableLokiLogs,
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'sum',
    rangeFunction: 'increase',
    discoveryMetric: {
      prometheus: 'velero_backup_success_total',
    },
    signals: {
      restoreValidationFailure: {
        name: 'Restore validation failure / $__interval',
        nameShort: 'Restore validation failures',
        type: 'counter',
        description: 'Number of failed restore validations.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_restore_validation_failed_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            exprWrappers: [['sum(', ')']],
            legendCustomTemplate: 'failure',
          },
        },
      },
      backupValidationFailure: {
        name: 'Backup validation failure / $__interval',
        nameShort: 'Backup validation failures',
        type: 'counter',
        description: 'Number of failed backup validations.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_backup_validation_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            exprWrappers: [['sum(', ')']],
            legendCustomTemplate: 'failure',
          },
        },
      },
      successfulBackupsStat: {
        name: 'Successful backups / $__interval',
        nameShort: 'Backups',
        type: 'counter',
        description: 'Number of successful backups.',
        sources: {
          prometheus: {
            expr: 'velero_backup_success_total{%(queriesSelector)s}',
            exprWrappers: [['sum(', ')']],
            legendCustomTemplate: 'Backups',
          },
        },
      },
      failedBackupsStat: {
        name: 'Failed backups / $__interval',
        nameShort: 'Backups',
        type: 'counter',
        description: 'Number of failed backups.',
        sources: {
          prometheus: {
            expr: 'velero_backup_failure_total{%(queriesSelector)s}',
            exprWrappers: [['sum(', ')']],
            legendCustomTemplate: 'Backups',
          },
        },
      },
      backupSuccess: {
        name: 'Successful backup count',
        nameShort: 'Backup success',
        type: 'counter',
        description: 'Number of successful backups by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_backup_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - success',
          },
        },
      },
      backupAttempt: {
        name: 'Attempted backup count',
        nameShort: 'Backup attempts',
        type: 'counter',
        description: 'Number of attempted backups by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_backup_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - attempt',
          },
        },
      },
      backupFailure: {
        name: 'Failed backup count',
        nameShort: 'Backup failures',
        type: 'counter',
        description: 'Number of failed backups by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_backup_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - failure',
          },
        },
      },
      backupSuccessRate: {
        name: 'Backup success rate / $__interval',
        nameShort: 'Backup success rate',
        type: 'raw',
        unit: 'percentunit',
        description: 'Success rate of backups.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_backup_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__rate_interval:]) / clamp_min(rate(label_replace(velero_backup_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__rate_interval:]),1)',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
      backupSuccessRateGauge: {
        name: 'Backup success rate (1 hour)',
        nameShort: 'Backup success rate',
        type: 'raw',
        unit: 'percentunit',
        description: 'Success rate of backups within the instance in the past hour.',
        sources: {
          prometheus: {
            expr: 'avg by (instance) (label_replace(increase(velero_backup_success_total{%(queriesSelector)s}[1h]), "schedule", "none", "schedule", "^$") / label_replace(increase(velero_backup_attempt_total{%(queriesSelector)s}[1h]), "schedule", "none", "schedule", "^$") >  0)',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
      backupSize: {
        name: 'Backup size',
        nameShort: 'Backup size',
        type: 'gauge',
        unit: 'decbytes',
        description: 'Size of backups for this clusters given schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_backup_tarball_size_bytes{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
      backupTime: {
        name: 'Backup time',
        nameShort: 'Backup time',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        unit: 's',
        description: 'The time it took to create backups.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_backup_duration_seconds_bucket{le!="+Inf", %(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            aggKeepLabels: ['le'],
            legendCustomTemplate: '',
          },
        },
      },
      restoreSuccess: {
        name: 'Successful restore count',
        nameShort: 'Restore success',
        type: 'counter',
        description: 'Number of successful restores by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_restore_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - success',
          },
        },
      },
      restoreFailure: {
        name: 'Failed restore count',
        nameShort: 'Restore failures',
        type: 'counter',
        description: 'Number of failed restores by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_restore_failed_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - failure',
          },
        },
      },
      restoreAttempt: {
        name: 'Attempted restore count',
        nameShort: 'Restore attempts',
        type: 'counter',
        description: 'Number of attempted restores by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_restore_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - attempt',
          },
        },
      },
      restoreSuccessRate: {
        name: 'Restore success rate / $__interval',
        nameShort: 'Restore success rate',
        type: 'raw',
        unit: 'percentunit',
        description: 'Success rate of restores.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_restore_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:] offset -$__interval) / clamp_min(increase(label_replace(velero_restore_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:] offset -$__interval),1)',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
      restoreSuccessRateGauge: {
        name: 'Restore success rate (1 hour)',
        nameShort: 'Restore success rate',
        type: 'raw',
        unit: 'percentunit',
        description: 'Success rate of restores within the instance in the past hour.',
        sources: {
          prometheus: {
            expr: 'avg by (instance) (label_replace(increase(velero_restore_success_total{%(queriesSelector)s}[1h]), "schedule", "none", "schedule", "^$") / label_replace(increase(velero_restore_attempt_total{%(queriesSelector)s}[1h]), "schedule", "none", "schedule", "^$") >  0)',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
      volumeSnapshotSuccess: {
        name: 'Successful volume snapshot count',
        nameShort: 'Volume snapshot success',
        type: 'counter',
        description: 'Number of successful volume snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_volume_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - success',
          },
        },
      },
      volumeSnapshotFailure: {
        name: 'Failed volume snapshot count',
        nameShort: 'Volume snapshot failures',
        type: 'counter',
        description: 'Number of failed volume snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_volume_snapshot_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - failure',
          },
        },
      },
      volumeSnapshotAttempt: {
        name: 'Attempted volume snapshot count',
        nameShort: 'Volume snapshot attempts',
        type: 'counter',
        description: 'Number of attempted volume snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_volume_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            legendCustomTemplate: '{{schedule}} - attempt',
          },
        },
      },
      volumeSnapshotSuccessRate: {
        name: 'Volume snapshot success rate / $__interval',
        nameShort: 'Volume snapshot success rate',
        type: 'raw',
        unit: 'percentunit',
        description: 'Success rate of volume snapshots.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_volume_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:] offset -$__interval) / clamp_min(increase(label_replace(velero_volume_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:] offset -$__interval),1)',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
      csiSnapshotSuccess: {
        name: 'Successful CSI snapshot count',
        nameShort: 'CSI snapshot success',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Number of successful CSI snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            aggKeepLabels: ['schedule'],
            legendCustomTemplate: '{{schedule}} - success',
          },
        },
      },
      csiSnapshotFailure: {
        name: 'Failed CSI snapshot count',
        nameShort: 'CSI snapshot failures',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Number of failed CSI snapshots by schedule.',
        sources: {
          prometheus: {
            // preserved from the legacy dashboard: queries the success metric, not failures
            expr: 'label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            aggKeepLabels: ['schedule'],
            legendCustomTemplate: '{{schedule}} - failure',
          },
        },
      },
      csiSnapshotAttempt: {
        name: 'Attempted CSI snapshot count',
        nameShort: 'CSI snapshot attempts',
        type: 'counter',
        aggLevel: 'aggKeepLabels',
        description: 'Number of attempted CSI snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'label_replace(velero_csi_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")',
            aggKeepLabels: ['schedule'],
            legendCustomTemplate: '{{schedule}} - attempt',
          },
        },
      },
      csiSnapshotSuccessRate: {
        name: 'CSI snapshot success rate / $__interval',
        nameShort: 'CSI snapshot success rate',
        type: 'raw',
        unit: 'percentunit',
        description: 'Success rate of CSI snapshots.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:] offset -$__interval) / clamp_min(increase(label_replace(velero_csi_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:] offset -$__interval),1)',
            exprWrappers: [['sum by (schedule) (', ')']],
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
    },
  }
