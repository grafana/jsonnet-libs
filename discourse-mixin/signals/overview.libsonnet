function(this)
  local legendCustomTemplate = '{{ instance }}';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    legendCustomTemplate: legendCustomTemplate,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {
      // HTTP traffic and latency signals
      httpRequests: {
        name: 'HTTP requests',
        type: 'counter',
        unit: 'reqps',
        description: 'Rate of HTTP requests by status code.',
        sources: {
          prometheus: {
            expr: 'discourse_http_requests{%(queriesSelector)s}',
            aggKeepLabels: ['status'],
            legendCustomTemplate: '{{ api }} - {{ verb }} - {{ status }}',
          },
        },
      },

      latestMedianRequestTime: {
        name: 'Latest median request time',
        type: 'gauge',
        unit: 's',
        description: 'The median amount of time for "latest" page requests.',
        sources: {
          prometheus: {
            expr: 'discourse_http_duration_seconds{%(queriesSelector)s,quantile="0.5",action="latest"}',
          },
        },
      },

      topicMedianRequestTime: {
        name: 'Topic median request time',
        type: 'gauge',
        unit: 's',
        description: 'The median amount of time for "topics show" requests.',
        sources: {
          prometheus: {
            expr: 'discourse_http_duration_seconds{%(queriesSelector)s,quantile="0.5",controller="topics"}',
          },
        },
      },

      latest99thPercentileRequestTime: {
        name: 'Latest 99th percentile request time',
        type: 'gauge',
        unit: 's',
        description: 'The 99th percentile amount of time for "latest" page requests.',
        sources: {
          prometheus: {
            expr: 'discourse_http_duration_seconds{%(queriesSelector)s,quantile="0.99",action="latest"}',
          },
        },
      },

      topic99thPercentileRequestTime: {
        name: 'Topic 99th percentile request time',
        type: 'gauge',
        unit: 's',
        description: 'The 99th percentile amount of time for "topics show" requests.',
        sources: {
          prometheus: {
            expr: 'discourse_http_duration_seconds{%(queriesSelector)s,quantile="0.99",controller="topics"}',
          },
        },
      },

      // Request queue signals
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
