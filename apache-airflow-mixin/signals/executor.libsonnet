function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      runningTasks: {
        name: 'Executor running tasks',
        type: 'gauge',
        description: 'Number of tasks currently running in the executor.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_executor_running_tasks{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      queuedTasks: {
        name: 'Executor queued tasks',
        type: 'gauge',
        description: 'Number of tasks queued in the executor.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_executor_queued_tasks{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      openSlots: {
        name: 'Executor open slots',
        type: 'gauge',
        description: 'Number of open slots available in the executor.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_executor_open_slots{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
