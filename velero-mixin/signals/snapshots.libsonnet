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
      prometheus: 'velero_volume_snapshot_attempt_total',
    },
    signals: {
      volumeSnapshotAttempts: {
        name: 'Volume snapshot attempts',
        type: 'raw',
        description: 'Number of volume snapshot attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_volume_snapshot_attempt_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Attempts',
          },
        },
      },

      volumeSnapshotSuccesses: {
        name: 'Volume snapshot successes',
        type: 'raw',
        description: 'Number of successful volume snapshots.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_volume_snapshot_success_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Success',
          },
        },
      },

      volumeSnapshotFailures: {
        name: 'Volume snapshot failures',
        type: 'raw',
        description: 'Number of failed volume snapshots.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_volume_snapshot_failure_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Failure',
          },
        },
      },

      csiSnapshotAttempts: {
        name: 'CSI snapshot attempts',
        type: 'raw',
        description: 'Number of CSI snapshot attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_csi_snapshot_attempt_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Attempts',
          },
        },
      },

      csiSnapshotSuccesses: {
        name: 'CSI snapshot successes',
        type: 'raw',
        description: 'Number of successful CSI snapshots.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_csi_snapshot_success_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Success',
          },
        },
      },

      csiSnapshotFailures: {
        name: 'CSI snapshot failures',
        type: 'raw',
        description: 'Number of failed CSI snapshots.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_csi_snapshot_failure_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Failure',
          },
        },
      },
    },
  }
