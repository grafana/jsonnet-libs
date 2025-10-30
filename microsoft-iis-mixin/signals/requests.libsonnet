function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      requests: {
        name: 'Requests per second',
        type: 'counter',
        description: 'The request rate split by HTTP Method for an IIS site.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_iis_requests_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{site}} - {{method}}',
          },
        },
      },

      lockedErrors: {
        name: 'Locked errors per second',
        type: 'counter',
        description: 'Requests that resulted in locked errors for an IIS site.',
        unit: 'errors/sec',
        sources: {
          prometheus: {
            expr: 'windows_iis_locked_errors_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{site}} - locked',
          },
        },
      },

      notFoundErrors: {
        name: 'Not found errors per second',
        type: 'counter',
        description: 'Requests that resulted in not found errors for an IIS site.',
        unit: 'errors/sec',
        sources: {
          prometheus: {
            expr: 'windows_iis_not_found_errors_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{site}} - not found',
          },
        },
      },
    },
  }
