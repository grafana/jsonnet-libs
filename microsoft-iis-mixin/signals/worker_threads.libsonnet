function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      currentThreads: {
        name: 'Current worker threads',
        type: 'gauge',
        description: 'The current number of worker threads processing requests for an IIS application.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_threads{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}} - {{state}}',
          },
        },
      },

      maxThreads: {
        name: 'Maximum worker threads',
        type: 'gauge',
        description: 'The maximum number of worker threads for an IIS application.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_max_threads{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },
    },
  }
