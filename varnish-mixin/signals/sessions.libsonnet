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
      // Sessions rate
      sessionsRate: {
        name: 'Sessions rate',
        nameShort: 'Sessions',
        type: 'raw',
        description: 'The rate of total sessions created in the Varnish Cache instance.',
        unit: 'sess/s',
        sources: {
          prometheus: {
            expr: 'sum by () (irate(varnish_main_sessions_total{%(queriesSelector)s}[$__rate_interval]))',
          },
        },
      },

      // Sessions connected
      sessionsConnected: {
        name: 'Sessions connected',
        nameShort: 'Connected',
        type: 'counter',
        description: 'Rate of new connected sessions.',
        unit: 'sess',
        sources: {
          prometheus: {
            expr: 'varnish_main_sessions{%(queriesSelector)s,type="conn"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Connected',
          },
        },
      },

      // Sessions queued
      sessionsQueued: {
        name: 'Sessions queued',
        nameShort: 'Queued',
        type: 'counter',
        description: 'Rate of queued sessions.',
        unit: 'sess',
        sources: {
          prometheus: {
            expr: 'varnish_main_sessions{%(queriesSelector)s,type="queued"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Queued',
          },
        },
      },

      // Sessions dropped
      sessionsDropped: {
        name: 'Sessions dropped',
        nameShort: 'Dropped',
        type: 'counter',
        description: 'Rate of dropped sessions.',
        unit: 'sess',
        sources: {
          prometheus: {
            expr: 'varnish_main_sessions{%(queriesSelector)s,type="dropped"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Dropped',
          },
        },
      },

      // Session queue length
      sessionQueueLength: {
        name: 'Session queue length',
        nameShort: 'Queue length',
        type: 'raw',
        description: 'Length of session queue waiting for threads.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by () (varnish_main_thread_queue_len{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
