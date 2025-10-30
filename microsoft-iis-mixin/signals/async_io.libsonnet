function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      blockedRequests: {
        name: 'Blocked async I/O requests',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of async I/O requests that are currently queued for an IIS site.',
        unit: 'requests',
        sources: {
          prometheus: {
            expr: 'windows_iis_blocked_async_io_requests_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      rejectedRequests: {
        name: 'Rejected async I/O requests',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of async I/O requests that have been rejected for an IIS site.',
        unit: 'requests',
        sources: {
          prometheus: {
            expr: 'windows_iis_rejected_async_io_requests_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },
    },
  }
