function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    signals: {
      activeRequests: {
        name: 'Active requests',
        type: 'gauge',
        unit: 'reqps',
        description: 'Active web requests for the entire application.',
        sources: {
          prometheus: {
            expr: 'discourse_active_app_reqs{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      queuedRequests: {
        name: 'Queued requests',
        type: 'gauge',
        unit: 'reqps',
        description: 'Queued web requests for the entire application.',
        sources: {
          prometheus: {
            expr: 'discourse_queued_app_reqs{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      pageViews: {
        name: 'Page views',
        type: 'counter',
        unit: 'views/sec',
        description: 'Rate of pageviews for the entire application.',
        sources: {
          prometheus: {
            expr: 'discourse_page_views{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
