function(this)
  local legendCustomTemplate = this.legendCustomTemplate;
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'velero_backup_total',
    },
    signals: {
      backupTotal: {
        name: 'Total backups',
        type: 'gauge',
        description: 'Current number of existing backups.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupItems: {
        name: 'Backup items',
        type: 'gauge',
        description: 'Total number of items in the backup.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_items_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupLastStatus: {
        name: 'Backup last status',
        type: 'gauge',
        description: 'Last status of the backup (1=success, 0=failure).',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_last_status{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupDuration: {
        name: 'Backup duration',
        type: 'gauge',
        description: 'Time taken to complete the backup.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'backup_duration_seconds{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupTarballSize: {
        name: 'Backup tarball size',
        type: 'gauge',
        description: 'Size of the backup tarball in bytes.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'velero_backup_tarball_size_bytes{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupAttempts: {
        name: 'Backup attempts',
        type: 'counter',
        description: 'Total number of backup attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_attempt_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupSuccesses: {
        name: 'Backup successes',
        type: 'counter',
        description: 'Total number of successful backups.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_success_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupFailures: {
        name: 'Backup failures',
        type: 'counter',
        description: 'Total number of failed backups.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_failure_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupPartialFailures: {
        name: 'Backup partial failures',
        type: 'counter',
        description: 'Total number of partially failed backups.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_partial_failure_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupDeletionAttempts: {
        name: 'Backup deletion attempts',
        type: 'counter',
        description: 'Total number of backup deletion attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_deletion_attempt_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupDeletionSuccesses: {
        name: 'Backup deletion successes',
        type: 'counter',
        description: 'Total number of successful backup deletions.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_deletion_success_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupDeletionFailures: {
        name: 'Backup deletion failures',
        type: 'counter',
        description: 'Total number of failed backup deletions.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_deletion_failure_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
