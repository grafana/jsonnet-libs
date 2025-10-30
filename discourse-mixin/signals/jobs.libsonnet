function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {
      sidekiqJobDuration: {
        name: 'Sidekiq job duration',
        type: 'counter',
        unit: 's',
        description: 'Time spent in Sidekiq jobs broken out by job name.',
        sources: {
          prometheus: {
            expr: 'discourse_sidekiq_job_duration_seconds{%(queriesSelector)s}',
            aggKeepLabels: ['job_name'],
            legendCustomTemplate: '{{job_name}}',
          },
        },
      },

      scheduledJobDuration: {
        name: 'Scheduled job duration',
        type: 'counter',
        unit: 's',
        description: 'Time spent in scheduled jobs broken out by job name.',
        sources: {
          prometheus: {
            expr: 'discourse_scheduled_job_duration_seconds{%(queriesSelector)s}',
            aggKeepLabels: ['job_name'],
            legendCustomTemplate: '{{job_name}}',
          },
        },
      },

      sidekiqJobCount: {
        name: 'Sidekiq job count',
        type: 'counter',
        rangeFunction: 'increase',
        unit: 'none',
        description: 'The amount of sidekiq jobs ran over an interval.',
        sources: {
          prometheus: {
            expr: 'discourse_sidekiq_job_count{%(queriesSelector)s}',
            aggKeepLabels: ['job_name'],
            legendCustomTemplate: '{{job_name}}',
          },
        },
      },

      scheduledJobCount: {
        name: 'Scheduled job count',
        type: 'counter',
        rangeFunction: 'increase',
        unit: 'none',
        description: 'The number of scheduled jobs ran over an interval.',
        sources: {
          prometheus: {
            expr: 'discourse_scheduled_job_count{%(queriesSelector)s}',
            aggKeepLabels: ['job_name'],
            legendCustomTemplate: '{{job_name}}',
          },
        },
      },

      sidekiqJobsEnqueued: {
        name: 'Sidekiq jobs enqueued',
        type: 'gauge',
        aggFunction: 'max',
        unit: 'none',
        description: 'Current number of jobs in Sidekiq queue.',
        sources: {
          prometheus: {
            expr: 'discourse_sidekiq_jobs_enqueued{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      sidekiqWorkerCount: {
        name: 'Sidekiq worker count',
        type: 'raw',
        unit: 'none',
        description: 'Current number of Sidekiq workers.',
        sources: {
          prometheus: {
            expr: 'count(discourse_rss{type="sidekiq",%(queriesSelector)s})',
            legendCustomTemplate: '',
          },
        },
      },

      webWorkerCount: {
        name: 'Web worker count',
        type: 'raw',
        unit: 'none',
        description: 'Current number of web workers.',
        sources: {
          prometheus: {
            expr: 'count(discourse_rss{type="web",%(queriesSelector)s})',
            legendCustomTemplate: '',
          },
        },
      },
    },
  }
