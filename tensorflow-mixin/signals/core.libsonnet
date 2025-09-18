local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: ':tensorflow:core:graph_build_calls',
    },
    signals: {
      graphBuildCalls: {
        name: 'Graph build calls',
        nameShort: 'Build calls',
        type: 'counter',
        description: 'Number of graph build calls over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: ':tensorflow:core:graph_build_calls{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
      graphRuns: {
        name: 'Graph runs',
        nameShort: 'Graph runs',
        type: 'counter',
        description: 'Number of graph runs over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: ':tensorflow:core:graph_runs{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
      graphBuildTime: {
        name: 'Average graph build time',
        nameShort: 'Build time',
        type: 'raw',
        description: 'Average time taken to build graphs.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'increase(:tensorflow:core:graph_build_time_usecs{%(queriesSelector)s}[$__interval:] offset $__interval)/increase(:tensorflow:core:graph_build_calls{%(queriesSelector)s}[$__interval:] offset $__interval)',
          },
        },
      },
      graphRunTime: {
        name: 'Average graph run time',
        nameShort: 'Run time',
        type: 'raw',
        description: 'Average time taken to run graphs.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'increase(:tensorflow:core:graph_run_time_usecs{%(queriesSelector)s}[$__interval:] offset $__interval)/increase(:tensorflow:core:graph_runs{%(queriesSelector)s}[$__interval:] offset $__interval)',
          },
        },
      },
    },
  }
