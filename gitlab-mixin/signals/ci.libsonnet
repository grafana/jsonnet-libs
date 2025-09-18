// for CI related signals
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'gitlab_ci_active_jobs_sum',
    },
    signals: {
      activeJobs: {
        name: 'GitLab CI active jobs',
        nameShort: 'Active jobs',
        type: 'counter',
        description: 'Rate of job activations per second.',
        unit: 'activations/s',
        sources: {
          prometheus: {
            expr: 'gitlab_ci_active_jobs_sum{%(queriesSelector)s}',
            legendCustomTemplate: '{{ plan }}',
          },
        },
      },

      pipelinesCreated: {
        name: 'Pipelines created',
        nameShort: 'Pipelines',
        type: 'counter',
        description: 'Rate of pipeline instances created.',
        unit: 'pipelines/s',
        sources: {
          prometheus: {
            expr: 'pipelines_created_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ source }}',
          },
        },
      },


      pipelineBuildsCreated: {
        name: 'Pipeline builds created',
        nameShort: 'Builds',
        type: 'raw',
        description: 'The number of builds created within pipelines per second, grouped by source.',
        unit: 'builds/s',
        sources: {
          prometheus: {
            expr: 'sum by (source) (rate(gitlab_ci_pipeline_size_builds_sum{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ source }}',
          },
        },
      },


      traceOperations: {
        name: 'Build trace operations',
        nameShort: 'Trace ops',
        type: 'counter',
        description: 'The rate of build trace operations performed.',
        unit: 'ops/s',
        sources: {
          prometheus: {
            expr: 'gitlab_ci_trace_operations_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ operation }}',
          },
        },
      },
    },
  }
