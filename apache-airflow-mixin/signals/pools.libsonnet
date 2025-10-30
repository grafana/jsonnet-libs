function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      runningSlots: {
        name: 'Pool running slots',
        type: 'gauge',
        description: 'Number of slots currently running in pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_pool_running_slots{%(queriesSelector)s, pool_name=~"$pool_name"}',
            legendCustomTemplate: '{{pool_name}}',
          },
        },
      },

      queuedSlots: {
        name: 'Pool queued slots',
        type: 'gauge',
        description: 'Number of slots queued in pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_pool_queued_slots{%(queriesSelector)s, pool_name=~"$pool_name"}',
            legendCustomTemplate: '{{pool_name}}',
          },
        },
      },

      starvingTasks: {
        name: 'Pool starving tasks',
        type: 'gauge',
        description: 'Number of tasks starving (waiting for resources) in pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_pool_starving_tasks{%(queriesSelector)s, pool_name=~"$pool_name"}',
            legendCustomTemplate: '{{pool_name}}',
          },
        },
      },

      openSlots: {
        name: 'Pool open slots',
        type: 'gauge',
        description: 'Number of open slots available in pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_pool_open_slots{%(queriesSelector)s, pool_name=~"$pool_name"}',
            legendCustomTemplate: '{{pool_name}}',
          },
        },
      },
    },
  }
