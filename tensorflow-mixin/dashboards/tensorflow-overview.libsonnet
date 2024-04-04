local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'tensorflow-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local servingOverviewRow = {
  collapsed: false,
  title: 'Serving overview',
  type: 'row',
};

local modelRequestRatePanel(matcher) = {
  datasource: promDatasource,
  description: 'Rate of requests over time for the selected model. Grouped by statuses.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'reqps',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'rate(:tensorflow:serving:request_count{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='model_name="{{model_name}}",status="{{status}}"',
    ),
  ],
  title: 'Model request rate',
  transformations: [],
  type: 'timeseries',
};

local modelPredictRequestLatencyPanel(matcher) = {
  datasource: promDatasource,
  description: 'Average request latency of predict requests for the selected model.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'µs',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:serving:request_latency_sum{' + matcher + '}[$__rate_interval])/increase(:tensorflow:serving:request_latency_count{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='model_name="{{model_name}}"',
    ),
  ],
  title: 'Model predict request latency',
  transformations: [],
  type: 'timeseries',
};

local modelPredictRuntimeLatencyPanel(matcher) = {
  datasource: promDatasource,
  description: 'Average runtime latency to fulfill a predict request for the selected model.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'µs',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:serving:runtime_latency_sum{' + matcher + '}[$__rate_interval])/increase(:tensorflow:serving:runtime_latency_count{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='model_name="{{model_name}}"',
    ),
  ],
  title: 'Model predict runtime latency',
  transformations: [],
  type: 'timeseries',
};

local graphBuildCallsPanel(matcher) = {
  datasource: promDatasource,
  description: 'Number of times TensorFlow Serving has created a new client graph.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'calls',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: false,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:core:graph_build_calls{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Graph build calls',
  transformations: [],
  type: 'timeseries',
};

local graphRunsPanel(matcher) = {
  datasource: promDatasource,
  description: 'Number of graph executions.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'runs',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: false,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:core:graph_runs{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Graph runs',
  transformations: [],
  type: 'timeseries',
};

local graphBuildTimePanel(matcher) = {
  datasource: promDatasource,
  description: 'Amount of time Tensorflow has spent creating new client graphs.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'µs',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: false,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:core:graph_build_time_usecs{' + matcher + '}[$__rate_interval])/increase(:tensorflow:core:graph_build_calls{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Graph build time',
  transformations: [],
  type: 'timeseries',
};

local graphRunTimePanel(matcher) = {
  datasource: promDatasource,
  description: 'Amount of time spent executing graphs.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'µs',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: false,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:core:graph_run_time_usecs{' + matcher + '}[$__rate_interval])/increase(:tensorflow:core:graph_runs{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Graph run time',
  transformations: [],
  type: 'timeseries',
};

local batchQueuingLatencyPanel(matcher) = {
  datasource: promDatasource,
  description: 'Current latency in the batching queue.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'µs',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: false,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:serving:batching_session:queuing_latency_sum{' + matcher + '}[$__rate_interval])/increase(:tensorflow:serving:batching_session:queuing_latency_count{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Batch queuing latency',
  transformations: [],
  type: 'timeseries',
};

local batchQueueThroughputPanel(matcher) = {
  datasource: promDatasource,
  description: 'Rate of batch queue throughput over time.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      unit: 'batches/s',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: false,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'rate(:tensorflow:serving:batching_session:queuing_latency_count{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Batch queue throughput',
  transformations: [],
  type: 'timeseries',
};

local containerLogsPanel(matcher) = {
  datasource: lokiDatasource,
  description: 'Logs from the TensorFlow Serving Docker container.',
  options: {
    dedupStrategy: 'none',
    enableLogDetails: true,
    prettifyLogMessage: false,
    showCommonLabels: false,
    showLabels: false,
    showTime: true,
    sortOrder: 'Descending',
    wrapLogMessage: false,
  },
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + matcher + '}',
      legendFormat: '',
      queryType: 'range',
      refId: 'A',
    },
  ],
  title: 'Container logs',
  transformations: [],
  type: 'logs',
};

local getMatcher(cfg) = '%(tensorflowSelector)s, instance=~"$instance"' % cfg;

{
  grafanaDashboards+:: {
    'tensorflow-overview.json':
      dashboard.new(
        'TensorFlow Serving overview',
        time_from='%s' % $._config.dashboardPeriod,
        editable=false,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='Overview of a TensorFlow Serving instance.',
        uid=dashboardUid,
      )
      .addTemplates(std.flattenArrays([
        [
          template.datasource(
            promDatasourceName,
            'prometheus',
            null,
            label='Data source',
            refresh='load',
          ),
          template.new(
            'job',
            promDatasource,
            'label_values(:tensorflow:serving:request_count{}, job)',
            label='Job',
            refresh='time',
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1,
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(:tensorflow:serving:request_count{}, cluster)' % $._config,
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(:tensorflow:serving:request_count{%(tensorflowSelector)s}, instance)', % $._config,
            label='Instance',
            refresh='time',
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1,
          ),
          template.new(
            'model_name',
            promDatasource,
            'label_values(:tensorflow:serving:request_count{%(tensorflowSelector)s}}, model_name)', % $._config,
            label='Model name',
            refresh='time',
            includeAll=true,
            multi=false,
            allValues='.+',
            sort=1,
          ),
        ],
        if $._config.enableLokiLogs then [
          template.datasource(
            lokiDatasourceName,
            'loki',
            null,
            label='Loki datasource',
            refresh='load'
          ),
        ] else [],
      ]))
      .addPanels(
        std.flattenArrays([
          // Model Row
          [
            modelRequestRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 0 } },
            modelPredictRequestLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            modelPredictRuntimeLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          ],
          // Serving Overview Row
          [
            servingOverviewRow(getMatcher($._config)) { gridPos: { h: 1, w: 24, x: 0, y: 16 } },
            graphBuildCallsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 17 } },
            graphRunsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 17 } },
            graphBuildTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
            graphRunTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
            batchQueuingLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 33 } },
            batchQueueThroughputPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 33 } },
          ],
          // Optional Log Row
          if $._config.enableLokiLogs then [
            containerLogsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 41 } },
          ] else [],
        ]),
      ),
  },
}
