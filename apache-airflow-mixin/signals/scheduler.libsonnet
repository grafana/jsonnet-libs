function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      tasksExecutable: {
        name: 'Scheduler executable tasks',
        type: 'gauge',
        description: 'Number of tasks that are ready for execution in the scheduler.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_scheduler_tasks_executable{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      tasksStarving: {
        name: 'Scheduler starving tasks',
        type: 'gauge',
        description: 'Number of tasks that are starving (waiting for resources) in the scheduler.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_scheduler_tasks_starving{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
