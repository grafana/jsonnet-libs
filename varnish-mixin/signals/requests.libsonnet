function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'varnish_main_sessions',
    },
    signals: {
      // Frontend requests rate
      frontendRequests: {
        name: 'Frontend requests',
        nameShort: 'Frontend req',
        type: 'counter',
        description: 'The delta of requests sent to the Varnish Cache frontend.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'varnish_main_client_req{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Backend requests rate
      backendRequests: {
        name: 'Backend requests',
        nameShort: 'Backend req',
        type: 'raw',
        description: 'The rate of requests sent to the Varnish Cache backends.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by () (rate(varnish_main_backend_req{%(queriesSelector)s}[$__rate_interval]))',
          },
        },
      },

      // Frontend requests for timeseries
      frontendRequestsTimeseries: {
        name: 'Frontend requests',
        nameShort: 'Frontend',
        type: 'counter',
        description: 'Rate of frontend requests received.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'varnish_main_client_req{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - Frontend',
          },
        },
      },

      // Backend requests for timeseries
      backendRequestsTimeseries: {
        name: 'Backend requests',
        nameShort: 'Backend',
        type: 'counter',
        description: 'Rate of backend requests received.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'varnish_main_backend_req{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - Backend',
          },
        },
      },
    },
  }
