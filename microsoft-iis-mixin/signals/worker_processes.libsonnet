function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      totalFailures: {
        name: 'Total worker process failures',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Total worker process failures for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_total_worker_process_failures{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      startupFailures: {
        name: 'Worker process startup failures',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Worker process startup failures for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_total_worker_process_startup_failures{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      shutdownFailures: {
        name: 'Worker process shutdown failures',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Worker process shutdown failures for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_total_worker_process_shutdown_failures{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      pingFailures: {
        name: 'Worker process ping failures',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Worker process ping failures for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_total_worker_process_ping_failures{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },
    },
  }
