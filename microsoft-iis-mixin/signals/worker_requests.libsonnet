function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      requests: {
        name: 'Worker requests per second',
        type: 'counter',
        description: 'The HTTP request rate for an IIS application.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_requests_total{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      requestErrors: {
        name: 'Worker request errors per second',
        type: 'counter',
        description: 'Requests that have resulted in errors for an IIS application.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_request_errors_total{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}} - {{status_code}}',
          },
        },
      },
    },
  }
