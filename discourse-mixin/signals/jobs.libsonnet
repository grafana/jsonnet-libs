function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {
      // Job processing signals
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
        unit: 'none',
        description: 'The amount of sidekiq jobs ran over an interval.',
        sources: {
          prometheus: {
            expr: 'discourse_sidekiq_job_count{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{job_name}}',
          },
        },
      },

      scheduledJobCount: {
        name: 'Scheduled job count',
        type: 'counter',
        unit: 'none',
        description: 'The number of scheduled jobs ran over an interval.',
        sources: {
          prometheus: {
            expr: 'discourse_scheduled_job_count{%(queriesSelector)s}',
            rangeFunction: 'increase',
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
          },
        },
      },

      // Memory signals
      rssMemory: {
        name: 'RSS memory',
        type: 'gauge',
        unit: 'bytes',
        description: 'Total RSS memory used by process.',
        sources: {
          prometheus: {
            expr: 'discourse_rss{%(queriesSelector)s}',
            legendCustomTemplate: 'pid: {{pid}}',
          },
        },
      },

      v8HeapSize: {
        name: 'V8 heap size',
        type: 'gauge',
        unit: 'bytes',
        description: 'Current heap size of V8 engine broken up by process type.',
        sources: {
          prometheus: {
            expr: 'discourse_v8_used_heap_size{%(queriesSelector)s}',
            legendCustomTemplate: '{{type}}',
          },
        },
      },
    },
  }
