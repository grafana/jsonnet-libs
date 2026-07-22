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
        type: 'raw',
        description: 'Size of the backup tarball in bytes averaged over the last 15 minutes.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'avg_over_time(velero_backup_tarball_size_bytes{%(queriesSelector)s}[15m])',
            legendCustomTemplate: '{{schedule}}',
          },
        },
      },

      backupSuccessTotal: {
        name: 'Total successful backups',
        type: 'raw',
        description: 'Cumulative number of successful backups.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_success_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupDeletionAttemptTotal: {
        name: 'Total backup deletion attempts',
        type: 'raw',
        description: 'Cumulative number of backup deletion attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_backup_deletion_attempt_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      backupAttempts: {
        name: 'Backup attempts',
        type: 'raw',
        description: 'Number of backup attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_backup_attempt_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Attempts',
          },
        },
      },

      backupSuccesses: {
        name: 'Backup successes',
        type: 'raw',
        description: 'Number of successful backups.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_backup_success_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Success',
          },
        },
      },

      backupFailures: {
        name: 'Backup failures',
        type: 'raw',
        description: 'Number of failed backups.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_backup_failure_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Failures',
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
        type: 'raw',
        description: 'Number of backup deletion attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_backup_deletion_attempt_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Attemps',  // legacy dashboard legend kept verbatim (sic)
          },
        },
      },

      backupDeletionSuccesses: {
        name: 'Backup deletion successes',
        type: 'raw',
        description: 'Number of successful backup deletions.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_backup_deletion_success_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Success',
          },
        },
      },

      backupDeletionFailures: {
        name: 'Backup deletion failures',
        type: 'raw',
        description: 'Number of failed backup deletions.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_backup_deletion_failure_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Failure',
          },
        },
      },
    },
  }
