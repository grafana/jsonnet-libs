// Signals for the Velero overview dashboard.
// Signals are type 'raw' with the complete legacy expressions baked in to keep
// dashboard output identical to the pre-signals implementation.
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    // overview panels additionally filter by the dashboard-level schedule variable
    instanceLabels: this.instanceLabels + ['schedule'],
    enableLokiLogs: this.enableLokiLogs,
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    discoveryMetric: {
      prometheus: 'velero_backup_success_total',
    },
    signals: {
      restoreValidationFailure: {
        name: 'Restore validation failure / $__interval ',
        nameShort: 'Restore validation failures',
        type: 'raw',
        description: 'Number of failed restore validations.',
        sources: {
          prometheus: {
            expr: 'sum(increase(label_replace(velero_restore_validation_failed_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))',
            legendCustomTemplate: 'failure',
          },
        },
      },
      backupValidationFailure: {
        name: 'Backup validation failure / $__interval ',
        nameShort: 'Backup validation failures',
        type: 'raw',
        description: 'Number of failed backup validations.',
        sources: {
          prometheus: {
            expr: 'sum(increase(label_replace(velero_backup_validation_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))',
            legendCustomTemplate: 'failure',
          },
        },
      },
      successfulBackupsStat: {
        name: 'Successful backups / $__interval ',
        nameShort: 'Backups',
        type: 'raw',
        description: 'Number of successful backups.',
        sources: {
          prometheus: {
            expr: 'sum(increase(velero_backup_success_total{%(queriesSelector)s}[$__interval:]))',
            legendCustomTemplate: 'Backups',
          },
        },
      },
      failedBackupsStat: {
        name: 'Failed backups / $__interval ',
        nameShort: 'Backups',
        type: 'raw',
        description: 'Number of failed backups.',
        sources: {
          prometheus: {
            expr: 'sum(increase(velero_backup_failure_total{%(queriesSelector)s}[$__interval:]))',
            legendCustomTemplate: 'Backups',
          },
        },
      },
      backupSuccess: {
        name: 'Successful backup count',
        nameShort: 'Backup success',
        type: 'raw',
        description: 'Number of successful backups by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_backup_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
            legendCustomTemplate: '{{schedule}} - success',
          },
        },
      },
      backupAttempt: {
        name: 'Attempted backup count',
        nameShort: 'Backup attempts',
        type: 'raw',
        description: 'Number of attempted backups by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_backup_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
            legendCustomTemplate: '{{schedule}} - attempt',
          },
        },
      },
      backupFailure: {
        name: 'Failed backup count',
        nameShort: 'Backup failures',
        type: 'raw',
        description: 'Number of failed backups by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_backup_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
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
        type: 'raw',
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
        type: 'raw',
        unit: 's',
        description: 'The time it took to create backups.',
        sources: {
          prometheus: {
            expr: 'sum(increase(label_replace(velero_backup_duration_seconds_bucket{le!="+Inf", %(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])) by (le)',
            legendCustomTemplate: '',
          },
        },
      },
      restoreSuccess: {
        name: 'Successful restore count',
        nameShort: 'Restore success',
        type: 'raw',
        description: 'Number of successful restores by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_restore_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
            legendCustomTemplate: '{{schedule}} - success',
          },
        },
      },
      restoreFailure: {
        name: 'Failed restore count',
        nameShort: 'Restore failures',
        type: 'raw',
        description: 'Number of failed restores by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_restore_failed_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
            legendCustomTemplate: '{{schedule}} - failure',
          },
        },
      },
      restoreAttempt: {
        name: 'Attempted restore count',
        nameShort: 'Restore attempts',
        type: 'raw',
        description: 'Number of attempted restores by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_restore_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
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
            expr: 'increase(label_replace(velero_restore_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]) / clamp_min(increase(label_replace(velero_restore_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]),1)',
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
        type: 'raw',
        description: 'Number of successful volume snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_volume_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
            legendCustomTemplate: '{{schedule}} - success',
          },
        },
      },
      volumeSnapshotFailure: {
        name: 'Failed volume snapshot count',
        nameShort: 'Volume snapshot failures',
        type: 'raw',
        description: 'Number of failed volume snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_volume_snapshot_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
            legendCustomTemplate: '{{schedule}} - failure',
          },
        },
      },
      volumeSnapshotAttempt: {
        name: 'Attempted volume snapshot count',
        nameShort: 'Volume snapshot attempts',
        type: 'raw',
        description: 'Number of attempted volume snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'increase(label_replace(velero_volume_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])',
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
            expr: 'increase(label_replace(velero_volume_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]) / clamp_min(increase(label_replace(velero_volume_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]),1)',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
      csiSnapshotSuccess: {
        name: 'Successful CSI snapshot count',
        nameShort: 'CSI snapshot success',
        type: 'raw',
        description: 'Number of successful CSI snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'sum by (schedule) (increase(label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))',
            legendCustomTemplate: '{{schedule}} - success',
          },
        },
      },
      csiSnapshotFailure: {
        name: 'Failed CSI snapshot count',
        nameShort: 'CSI snapshot failures',
        type: 'raw',
        description: 'Number of failed CSI snapshots by schedule.',
        sources: {
          prometheus: {
            // preserved from the legacy dashboard: queries the success metric, not failures
            expr: 'sum by (schedule) (increase(label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))',
            legendCustomTemplate: '{{schedule}} - failure',
          },
        },
      },
      csiSnapshotAttempt: {
        name: 'Attempted CSI snapshot count',
        nameShort: 'CSI snapshot attempts',
        type: 'raw',
        description: 'Number of attempted CSI snapshots by schedule.',
        sources: {
          prometheus: {
            expr: 'sum by (schedule) (increase(label_replace(velero_csi_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))',
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
            expr: 'sum by (schedule) (increase(label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]) / clamp_min(increase(label_replace(velero_csi_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]),1)) ',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },
    },
  }
