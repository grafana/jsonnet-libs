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
        type: 'counter',
        description: 'Total number of volume snapshot attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_volume_snapshot_attempt_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      volumeSnapshotSuccesses: {
        name: 'Volume snapshot successes',
        type: 'counter',
        description: 'Total number of successful volume snapshots.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_volume_snapshot_success_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      volumeSnapshotFailures: {
        name: 'Volume snapshot failures',
        type: 'counter',
        description: 'Total number of failed volume snapshots.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_volume_snapshot_failure_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      csiSnapshotAttempts: {
        name: 'CSI snapshot attempts',
        type: 'counter',
        description: 'Total number of CSI snapshot attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_csi_snapshot_attempt_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      csiSnapshotSuccesses: {
        name: 'CSI snapshot successes',
        type: 'counter',
        description: 'Total number of successful CSI snapshots.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_csi_snapshot_success_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      csiSnapshotFailures: {
        name: 'CSI snapshot failures',
        type: 'counter',
        description: 'Total number of failed CSI snapshots.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_csi_snapshot_failure_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
