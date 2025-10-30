function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {
      httpRequests: {
        name: 'HTTP requests',
        type: 'counter',
        unit: 'reqps',
        description: 'Rate of HTTP requests by status code.',
        sources: {
          prometheus: {
            expr: 'discourse_http_requests{%(queriesSelector)s}',
            aggKeepLabels: ['status'],
            legendCustomTemplate: '{{status}}',
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
            expr: 'discourse_http_duration_seconds{quantile="0.5",action="latest",%(queriesSelector)s}',
            aggKeepLabels: ['controller'],
            legendCustomTemplate: '{{controller}}',
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
            expr: 'discourse_http_duration_seconds{quantile="0.5",controller="topics",%(queriesSelector)s}',
            aggKeepLabels: ['controller'],
            legendCustomTemplate: '{{controller}}',
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
            expr: 'discourse_http_duration_seconds{quantile="0.99",action="latest",%(queriesSelector)s}',
            aggKeepLabels: ['controller'],
            legendCustomTemplate: '{{controller}}',
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
            expr: 'discourse_http_duration_seconds{quantile="0.99",controller="topics",%(queriesSelector)s}',
            aggKeepLabels: ['controller'],
            legendCustomTemplate: '{{controller}}',
          },
        },
      },
    },
  }
