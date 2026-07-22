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

      restoreSuccessTotal: {
        name: 'Total successful restores',
        type: 'raw',
        description: 'Cumulative number of successful restores.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'velero_restore_success_total{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      restoreAttempts: {
        name: 'Restore attempts',
        type: 'raw',
        description: 'Number of restore attempts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_restore_attempt_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Attempts',
          },
        },
      },

      restoreSuccesses: {
        name: 'Restore successes',
        type: 'raw',
        description: 'Number of successful restores.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_restore_success_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Success',
          },
        },
      },

      restoreFailures: {
        name: 'Restore failures',
        type: 'raw',
        description: 'Number of failed restores.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(velero_restore_failed_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: 'Failure',
          },
        },
      },
    },
  }
