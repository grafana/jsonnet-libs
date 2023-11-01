local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'presto-worker';

local promDatasourceName = 'prometheus_datasource';
local getMatcher(cfg) = '%(prestoSelector)s' % cfg;
local getLegendMatcher(cfg) = '%(prestoLegendSelector)s' % cfg;
local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local nonheapMemoryUsagePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg (jvm_nonheap_memory_used{' + matcher + ', presto_cluster=~"$presto_cluster"} / clamp_min((jvm_nonheap_memory_used{' + matcher + ', presto_cluster=~"$presto_cluster"} + jvm_nonheap_memory_committed{' + matcher + ', presto_cluster=~"$presto_cluster"}),1))',
      datasource=promDatasource,
    ),
  ],
  type: 'gauge',
  title: 'Non-heap memory usage',
  description: "An average gauge of the JVM's non-heap memory usage across coordinators.",
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: '#EAB839',
            value: 0.7,
          },
          {
            color: 'red',
            value: 0.8,
          },
        ],
      },
      unit: 'percentunit',
    },
    overrides: [],
  },
  options: {
    minVizHeight: 75,
    minVizWidth: 75,
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showThresholdLabels: false,
    showThresholdMarkers: true,
  },
  pluginVersion: '10.2.0-62263',
};

local heapMemoryUsagePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg (jvm_heap_memory_used{' + matcher + ', presto_cluster=~"$presto_cluster"} / clamp_min((jvm_heap_memory_used{' + matcher + ', presto_cluster=~"$presto_cluster"} + jvm_heap_memory_committed{' + matcher + ', presto_cluster=~"$presto_cluster"}),1))',
      datasource=promDatasource,
    ),
  ],
  type: 'gauge',
  title: 'Heap memory usage',
  description: "An average gauge of the JVM's heap memory usage across workers.",
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: '#EAB839',
            value: 0.7,
          },
          {
            color: 'red',
            value: 0.8,
          },
        ],
      },
      unit: 'percentunit',
    },
    overrides: [],
  },
  options: {
    minVizHeight: 75,
    minVizWidth: 75,
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showThresholdLabels: false,
    showThresholdMarkers: true,
  },
  pluginVersion: '10.2.0-62263',
};

local queuedTasksPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_TaskExecutor_ProcessorExecutor_QueuedTaskCount{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Queued tasks',
  description: 'The number of tasks that are being queued by the task executor.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: '#C8F2C2',
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local failedCompletedTasksPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(presto_TaskManager_FailedTasks_TotalCount{' + matcher + ', presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - failed',
      format='time_series',
    ),
    prometheus.target(
      'rate(presto_TaskExecutor_ProcessorExecutor_CompletedTaskCount{' + matcher + ', presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - completed',
    ),
  ],
  type: 'timeseries',
  title: 'Failed & Completed Tasks',
  description: 'The rate at which tasks have failed and completed',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ops',
    },
    overrides: [
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'A',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'red',
              mode: 'fixed',
            },
          },
          {
            id: 'custom.axisPlacement',
            value: 'left',
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'B',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'green',
              mode: 'fixed',
            },
          },
          {
            id: 'custom.axisPlacement',
            value: 'right',
          },
        ],
      },
    ],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local outputPositionsPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_TaskManager_OutputPositions_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Output positions - one minute rate',
  description: 'The rate of rows (or records) produced by an operation.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'stepBefore',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'rowsps',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local executorPoolSizePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_TaskManager_TaskNotificationExecutor_PoolSize{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - task notification',
      format='time_series',
    ),
    prometheus.target(
      'presto_TaskExecutor_ProcessorExecutor_CorePoolSize{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - process executor core',
    ),
    prometheus.target(
      'presto_TaskExecutor_ProcessorExecutor_PoolSize{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - process executor',
    ),
  ],
  type: 'timeseries',
  title: 'Executor pool size',
  description: 'The pool size of the task notification executor and process executor.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local memoryPoolPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (instance, presto_cluster) (presto_MemoryPool_general_FreeBytes{' + matcher + ', presto_cluster=~"$presto_cluster"})',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - free',
      format='time_series',
    ),
    prometheus.target(
      'sum by (instance, presto_cluster) (presto_MemoryPool_reserved_FreeBytes{' + matcher + ', presto_cluster=~"$presto_cluster"})',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - reserved',
    ),
  ],
  type: 'timeseries',
  title: 'Memory pool',
  description: 'The amount of Presto memory available.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'decbytes',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local dataProcessingThroughputOneMinuteRatePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_TaskManager_InputDataSize_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - input',
      format='time_series',
    ),
    prometheus.target(
      'presto_TaskManager_OutputDataSize_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - output',
    ),
  ],
  type: 'timeseries',
  title: 'Data processing throughput - one minute rate',
  description: 'The rate at which volumes of data are being processed',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'stepBefore',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'Bps',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local jvmMetricsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'JVM metrics',
  collapsed: false,
};

local garbageCollectionCount(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(jvm_gc_collection_count{' + matcher + ', presto_cluster=~"$presto_cluster", name="G1 Young Generation"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      interval='1m',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection count / $__interval',
  description: 'The recent increase in the number of garbage collection events for the JVM.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local garbageCollectionDurationPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_gc_duration{' + matcher + ', presto_cluster=~"$presto_cluster", name="G1 Young Generation"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection duration',
  description: 'The average duration for each garbage collection operation in the JVM.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local memoryUsedPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_nonheap_memory_used{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - non heap',
      format='time_series',
    ),
    prometheus.target(
      'jvm_heap_memory_used{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - heap',
    ),
  ],
  type: 'timeseries',
  title: 'Memory used',
  description: 'The heap and non-heap memory used by the JVM.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'decbytes',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local memoryCommittedPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_heap_memory_committed{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - heap',
      format='time_series',
    ),
    prometheus.target(
      'jvm_nonheap_memory_committed{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - non heap',
    ),
  ],
  type: 'timeseries',
  title: 'Memory committed',
  description: 'The heap and non-heap memory committed.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'decbytes',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

{
  grafanaDashboards+:: {
    'presto-worker.json':
      dashboard.new(
        'Presto worker',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Presto dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates(
        [
          template.datasource(
            promDatasourceName,
            'prometheus',
            null,
            label='Data Source',
            refresh='load'
          ),
          template.new(
            'job',
            promDatasource,
            'label_values(presto_metadata_DiscoveryNodeManager_ActiveNodeCount,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(presto_metadata_DiscoveryNodeManager_ActiveNodeCount{job=~"$job"}, cluster)',
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'presto_cluster',
            promDatasource,
            'label_values(presto_metadata_DiscoveryNodeManager_ActiveNodeCount{job=~"$job"},presto_cluster)',
            label='Presto cluster',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='.*',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(presto_metadata_DiscoveryNodeManager_ActiveNodeCount{job=~"$job", presto_cluster=~"$presto_cluster"},instance)',
            label='Instance',
            refresh=2,
            includeAll=false,
            multi=true,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          nonheapMemoryUsagePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 0, y: 0 } },
          heapMemoryUsagePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 3, y: 0 } },
          queuedTasksPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 6, x: 6, y: 0 } },
          failedCompletedTasksPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          outputPositionsPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          executorPoolSizePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          memoryPoolPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          dataProcessingThroughputOneMinuteRatePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          jvmMetricsRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
          garbageCollectionCount(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
          garbageCollectionDurationPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
          memoryUsedPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 33 } },
          memoryCommittedPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 33 } },
        ]
      ),
  },
}
