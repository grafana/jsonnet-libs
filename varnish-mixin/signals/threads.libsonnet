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
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'varnish_main_sessions',
    },
    signals: {
      // Thread pools
      threadPools: {
        name: 'Thread pools',
        nameShort: 'Pools',
        type: 'raw',
        description: 'Number of thread pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'varnish_main_pools{%(queriesSelector)s}',
          },
        },
      },

      // Threads failed
      threadsFailed: {
        name: 'Threads failed',
        nameShort: 'Failed',
        type: 'counter',
        description: 'Number of failed threads.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'varnish_main_threads_failed{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Failed',
          },
        },
      },

      // Threads created
      threadsCreated: {
        name: 'Threads created',
        nameShort: 'Created',
        type: 'counter',
        description: 'Number of created threads.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'varnish_main_threads_created{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Created',
          },
        },
      },

      // Threads limited
      threadsLimited: {
        name: 'Threads limited',
        nameShort: 'Limited',
        type: 'counter',
        description: 'Number of limited threads.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'varnish_main_threads_limited{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Limited',
          },
        },
      },

      // Threads total
      threadsTotal: {
        name: 'Threads total',
        nameShort: 'Total',
        type: 'gauge',
        description: 'Total number of current threads.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'varnish_main_threads{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - Total',
          },
        },
      },
    },
  }
