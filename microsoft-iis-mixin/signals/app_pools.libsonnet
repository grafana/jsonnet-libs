function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      currentWorkerProcesses: {
        name: 'Current worker processes',
        type: 'gauge',
        description: 'The current number of worker processes for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_current_worker_processes{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      applicationPoolState: {
        name: 'Application pool state',
        type: 'gauge',
        description: 'The current state of an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_current_application_pool_state{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}} - {{state}}',
          },
        },
      },
    },
  }
