// Ranking signals for the overview dashboard. Each one declares the complete
// topk/bottomk ranking query: the framework supplies the `<agg> by (<pivot>)`
// clause from aggKeepLabels, and the *_over_time subquery is written into expr
// because the signal framework has no range-aggregation helper for it
// (rangeFunction covers rate/irate/increase/delta/idelta only).
//
// Signals come in test_name/node_name pairs because the overview shows both
// rankings side by side, and the pivot label is part of the query.
function(this)
  {
    filteringSelector: this.overviewSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    datasource: 'prometheus_datasource',
    aggLevel: 'aggKeepLabels',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'catchpoint_load_time',
    },
    signals: {
      loadTimeByTest: {
        name: 'Top average total load time by tests',
        nameShort: 'Load time',
        type: 'gauge',
        description: 'The top average total load time among all tests over the specified interval.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_load_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['test_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{test_name}}',
          },
        },
      },
      loadTimeByNode: {
        name: 'Top average total load time by nodes',
        nameShort: 'Load time',
        type: 'gauge',
        description: 'The top average total load time among all nodes over the specified interval.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_load_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['node_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{node_name}}',
          },
        },
      },
      documentCompleteTimeByTest: {
        name: 'Top average document completion time by tests',
        nameShort: 'Doc complete',
        type: 'gauge',
        description: 'The top average document completion time among all tests over the specified interval.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_document_complete_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['test_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{test_name}}',
          },
        },
      },
      documentCompleteTimeByNode: {
        name: 'Top average document completion time by nodes',
        nameShort: 'Doc complete',
        type: 'gauge',
        description: 'The top average document completion time among all nodes over the specified interval.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_document_complete_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['node_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{node_name}}',
          },
        },
      },
      connectTimeByTest: {
        name: 'Top average connection setup time by tests',
        nameShort: 'Connect time',
        type: 'gauge',
        description: 'The top average connection setup time among all tests over the specified interval.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_connect_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['test_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{test_name}}',
          },
        },
      },
      connectTimeByNode: {
        name: 'Top average connection setup time by nodes',
        nameShort: 'Connect time',
        type: 'gauge',
        description: 'The top average connection setup time among all nodes over the specified interval.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_connect_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['node_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{node_name}}',
          },
        },
      },
      contentLoadTimeByTest: {
        name: 'Top average content loading time',
        nameShort: 'Content load',
        type: 'gauge',
        description: 'The top average content loading time among all tests over the specified interval.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_content_load_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['test_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{test_name}}',
          },
        },
      },
      contentLoadTimeByNode: {
        name: 'Top average content loading time by nodes',
        nameShort: 'Content load',
        type: 'gauge',
        description: 'The top average content loading time among all nodes over the specified interval.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_content_load_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['node_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{node_name}}',
          },
        },
      },
      redirectTimeByTest: {
        name: 'Top average redirects by tests',
        nameShort: 'Redirect time',
        type: 'gauge',
        description: 'The top average number of redirects among all tests over the specified interval.',
        unit: '',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_redirect_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['test_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{test_name}}',
          },
        },
      },
      redirectTimeByNode: {
        name: 'Top average redirects by nodes',
        nameShort: 'Redirect time',
        type: 'gauge',
        description: 'The top average number of redirects among all nodes over the specified interval.',
        unit: '',
        sources: {
          prometheus: {
            expr: 'avg_over_time(catchpoint_redirect_time{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['node_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{node_name}}',
          },
        },
      },
      anyErrorByTest: {
        name: 'Top errors by tests',
        nameShort: 'Any error',
        type: 'gauge',
        aggFunction: 'sum',
        description: 'The top number of errors encountered among all tests over the specified interval.',
        unit: '',
        sources: {
          prometheus: {
            expr: 'sum_over_time(catchpoint_any_error{%(queriesSelector)s}[$__interval:])',
            aggKeepLabels: ['test_name'],
            exprWrappers: [['topk(1, ', ')']],
            legendCustomTemplate: '{{test_name}}',
          },
        },
      },
      // Raw because the ranked value is a ratio of two metrics; the avg-by-pivot
      // and bottomk stages that the framework would otherwise contribute have to
      // ride along in exprWrappers, since raw ignores the aggregation template.
      requestSuccessRatioByTest: {
        name: 'Bottom average success request ratio by tests',
        nameShort: 'Success ratio',
        type: 'raw',
        description: 'The lowest average success request ratio among all tests over the specified interval.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'avg_over_time(((catchpoint_requests_count{%(queriesSelector)s} - catchpoint_failed_requests_count{%(queriesSelector)s}) / clamp_min(catchpoint_requests_count{%(queriesSelector)s},1))[$__interval:])',
            exprWrappers: [['avg by (test_name) (', ')'], ['bottomk(1, ', ')']],
            legendCustomTemplate: '{{test_name}}',
          },
        },
      },
      requestSuccessRatioByNode: {
        name: 'Bottom average success request ratio by nodes',
        nameShort: 'Success ratio',
        type: 'raw',
        description: 'The lowest average success request ratio among all nodes over the specified interval.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'avg_over_time(((catchpoint_requests_count{%(queriesSelector)s} - catchpoint_failed_requests_count{%(queriesSelector)s}) / clamp_min(catchpoint_requests_count{%(queriesSelector)s},1))[$__interval:])',
            exprWrappers: [['avg by (node_name) (', ')'], ['bottomk(1, ', ')']],
            legendCustomTemplate: '{{node_name}}',
          },
        },
      },
    },
  }
