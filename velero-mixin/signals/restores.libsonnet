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
      prometheus: 'velero_restore_total',
    },
    signals: {
      restoreTotal: {
        name: 'Total restores',
        type: 'gauge',
        description: 'Current number of existing restores.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_restore_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      restoreAttempts: {
        name: 'Restore attempts',
        type: 'counter',
        description: 'Total number of restore attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_restore_attempt_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      restoreSuccesses: {
        name: 'Restore successes',
        type: 'counter',
        description: 'Total number of successful restores.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_restore_success_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      restoreFailures: {
        name: 'Restore failures',
        type: 'counter',
        description: 'Total number of failed restores.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_restore_failed_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
