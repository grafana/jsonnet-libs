local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'tensorflow-overview';
local matcher = 'job=~"$job",instance=~"$instance",model_name=~"$model_name"';

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
  title: 'Overview',
  type: 'row',
};

local modelRequestRatePanel = {
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
      'rate(:tensorflow:serving:request_count{job=~"$job",instance=~"$instance",model_name=~"$model_name"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Model Request Rate',
  transformations: [],
  type: 'timeseries',
};

local modelPredictRequestLatencyPanel = {
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
      'increase(:tensorflow:serving:request_latency_sum{job=~"$job",instance=~"$instance",model_name=~"$model_name"}[$__rate_interval])/increase(:tensorflow:serving:request_latency_count{job=~"$job",instance=~"$instance",model_name=~"$model_name"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Model Predict Request Latency',
  transformations: [],
  type: 'timeseries',
};

local modelPredictRuntimeLatencyPanel = {
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
      'increase(:tensorflow:serving:runtime_latency_sum{job=~"$job",instance=~"$instance",model_name=~"$model_name"}[$__rate_interval])/increase(:tensorflow:serving:runtime_latency_count{job=~"$job",instance=~"$instance",model_name=~"$model_name"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Model Predict Request Latency',
  transformations: [],
  type: 'timeseries',
};

local graphBuildCallsPanel = {
  datasource: promDatasource,
  description: 'Number of times TensorFlow has created a new client graph.',
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
      unit: 'none',
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
      'increase(:tensorflow:core:graph_build_calls{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Graph Build Calls',
  transformations: [],
  type: 'timeseries',
};

local graphRunsPanel = {
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
      unit: 'none',
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
      'increase(:tensorflow:core:graph_runs{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Graph Runs',
  transformations: [],
  type: 'timeseries',
};

local graphBuildTimePanel = {
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
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:core:graph_build_time_usecs{job=~"$job",instance=~"$instance"}[$__rate_interval])/increase(:tensorflow:core:graph_build_calls{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Graph Build Time',
  transformations: [],
  type: 'timeseries',
};

local graphRunTimePanel = {
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
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:core:graph_run_time_usecs{job=~"$job",instance=~"$instance"}[$__rate_interval])/increase(:tensorflow:core:graph_runs{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Graph Run Time',
  transformations: [],
  type: 'timeseries',
};

local batchQueuingLatencyPanel = {
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
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'increase(:tensorflow:serving:batching_session:queuing_latency_sum{job=~"$job",instance=~"$instance"}[$__rate_interval])/increase(:tensorflow:serving:batching_session:queuing_latency_count{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Batch Queuing Latency',
  transformations: [],
  type: 'timeseries',
};

local batchQueueThroughputPanel = {
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
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    prometheus.target(
      'rate(:tensorflow:serving:batching_session:queuing_latency_count{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  title: 'Batch Queue Throughput',
  transformations: [],
  type: 'timeseries',
};

local containerLogsPanel = {
  datasource: lokiDatasource,
  description: 'Logs from the TensorGlow Docker container.',
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
      expr: '{instance=~"$instance", job=~"$job"}',
      legendFormat: '',
      queryType: 'range',
      refId: 'A',
    },
  ],
  title: 'Container Logs',
  transformations: [],
  type: 'logs',
};

{
  grafanaDashboards+:: {
    'tensorflow-overview.json':
      dashboard.new(
        'TensorFlow Overview',
        time_from='%s' % $._config.dashboardPeriod,
        editable=false,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='Overview of a TensorFlow instance.',
        uid=dashboardUid,
      )
      .addTemplates(std.flattenArrays([
        [
          template.datasource(
            promDatasourceName,
            'prometheus',
            null,
            label='Data Source',
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
            'instance',
            promDatasource,
            'label_values(:tensorflow:serving:request_count{job=~"$job"}, instance)',
            label='Instance',
            refresh='time',
            includeAll=true,
            multi=false,
            allValues='.+',
            sort=1,
          ),
          template.new(
            'model_name',
            promDatasource,
            'label_values(:tensorflow:serving:request_count{job=~"$job",instance=~"$instance"}, model_name)',
            label='Model Name',
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
            label='Loki Datasource',
            refresh='load'
          ),
        ] else [],
      ]))
      .addPanels(
        std.flattenArrays([
          // Model Row
          [
            modelRequestRatePanel { gridPos: { h: 8, w: 24, x: 0, y: 0 } },
            modelPredictRequestLatencyPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            modelPredictRuntimeLatencyPanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          ],
          // Serving Row
          [
            servingOverviewRow { gridPos: { h: 1, w: 24, x: 0, y: 16 } },
            graphBuildCallsPanel { gridPos: { h: 8, w: 12, x: 0, y: 17 } },
            graphRunsPanel { gridPos: { h: 8, w: 12, x: 12, y: 17 } },
            graphBuildTimePanel { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
            graphRunTimePanel { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
            batchQueuingLatencyPanel { gridPos: { h: 8, w: 12, x: 0, y: 33 } },
            batchQueueThroughputPanel { gridPos: { h: 8, w: 12, x: 12, y: 33 } },
          ],
          // Optional Log Row
          if $._config.enableLokiLogs then [
            containerLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 41 } },
          ] else [],
        ]),
      ),
  },
}
