local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'presto-coordinator';

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
      'java_lang_Memory_NonHeapMemoryUsage_used{' + matcher + ', presto_cluster=~"$presto_cluster"} / clamp_min((java_lang_Memory_NonHeapMemoryUsage_used{' + matcher + ', presto_cluster=~"$presto_cluster"} + java_lang_Memory_NonHeapMemoryUsage_committed{' + matcher + ', presto_cluster=~"$presto_cluster"}),1)',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
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
      'avg (java_lang_Memory_HeapMemoryUsage_used{' + matcher + ', presto_cluster=~"$presto_cluster"} / clamp_min((java_lang_Memory_HeapMemoryUsage_used{' + matcher + ', presto_cluster=~"$presto_cluster"} + java_lang_Memory_HeapMemoryUsage_committed{' + matcher + ', presto_cluster=~"$presto_cluster"}),1))',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
    ),
  ],
  type: 'gauge',
  title: 'Heap memory usage',
  description: "An average gauge of the JVM's heap memory usage across coordinators.",
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

local errorFailuresOneMinuteCountPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_InternalFailures_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - internal',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_UserErrorFailures_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - user',
    ),
  ],
  type: 'timeseries',
  title: 'Error failures - one minute count',
  description: 'The number of internal and user error failures occurring on the instance.',
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

local normalQueryOneMinuteCountPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_CompletedQueries_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - completed',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_RunningQueries{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - running',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_StartedQueries_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - started',
    ),
  ],
  type: 'timeseries',
  title: 'Normal query - one minute count',
  description: 'A count of completed, running, and started queries.',
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
        axisPlacement: 'left',
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

local abnormalQueryOneMinuteCountPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_FailedQueries_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - failed',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_AbandonedQueries_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - abandoned',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_CanceledQueries_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - canceled',
    ),
  ],
  type: 'timeseries',
  title: 'Abnormal query - one minute count',
  description: 'A count of failed, abandoned, and canceled queries.',
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
        axisPlacement: 'left',
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

local normalQueryOneMinuteRatePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_CompletedQueries_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - completed',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_RunningQueries{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - running',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_StartedQueries_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - started',
    ),
  ],
  type: 'timeseries',
  title: 'Normal query - one minute rate',
  description: 'The rate of normally operating queries such as the completed, running, and started queries.',
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
        axisPlacement: 'left',
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
      unit: 'ops',
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

local abnormalQueryOneMinuteRatePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_FailedQueries_TotalCount{' + matcher + ', presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - failed',
      format='time_series',
    ),
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_AbandonedQueries_TotalCount{' + matcher + ', presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - abandoned',
    ),
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_CanceledQueries_TotalCount{' + matcher + ', presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - canceled',
    ),
  ],
  type: 'timeseries',
  title: 'Abnormal query - one minute rate',
  description: 'The rate of abnormal queries such as the failed, abandoned, and canceled queries.',
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
        axisPlacement: 'left',
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
      unit: 'ops',
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

local queryExecutionTimeOneMinuteCountPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ExecutionTime_OneMinute_P75{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - p75',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ExecutionTime_OneMinute_P95{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - p95',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ExecutionTime_OneMinute_P99{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - p99',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ExecutionTime_OneMinute_P50{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - p99',
    ),
  ],
  type: 'timeseries',
  title: 'Query execution time - one minute count',
  description: 'The time it took to run queries over the past one minute period.\n',
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
          mode: 'none',
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

local cpuTimeConsumedOneMinuteRatePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ConsumedCpuTimeSecs_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' ',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'CPU time consumed - one minute rate',
  description: "CPU time consumed by Presto's QueryManager for executing queries over one-minute intervals, measured in CPU seconds used.",
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
          mode: 'none',
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
      unit: 's',
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

local cpuInputThroughputOneMinuteCountPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_CpuInputByteRate_OneMinute_Total{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' ',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'CPU input throughput - one minute count',
  description: 'The rate at which input data is being read and processed by the CPU.',
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
          mode: 'none',
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
      'increase(java_lang_G1_Young_Generation_CollectionCount{' + matcher + ', presto_cluster=~"$presto_cluster"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' ',
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
      'java_lang_G1_Young_Generation_LastGcInfo_duration{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - non heap',
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
      'java_lang_Memory_NonHeapMemoryUsage_used{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - non heap',
      format='time_series',
    ),
    prometheus.target(
      'java_lang_Memory_HeapMemoryUsage_used{' + matcher + ', presto_cluster=~"$presto_cluster"}',
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
      'java_lang_Memory_HeapMemoryUsage_committed{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - heap',
      format='time_series',
    ),
    prometheus.target(
      'java_lang_Memory_NonHeapMemoryUsage_committed{' + matcher + ', presto_cluster=~"$presto_cluster"}',
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
    'presto-coordinator.json':
      dashboard.new(
        'Presto coordinator',
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
            'label_values(com_facebook_presto_failureDetector_HeartbeatFailureDetector_ActiveCount,job)',
            label='Job',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='.+',
            sort=0
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(com_facebook_presto_failureDetector_HeartbeatFailureDetector_ActiveCount{job=~"$job"}, cluster)',
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
            'label_values(com_facebook_presto_failureDetector_HeartbeatFailureDetector_ActiveCount{job=~"$job"},presto_cluster)',
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
            'label_values(com_facebook_presto_failureDetector_HeartbeatFailureDetector_ActiveCount{job=~"$job", presto_cluster=~"$presto_cluster"},instance)',
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
          nonheapMemoryUsagePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 9, w: 6, x: 0, y: 0 } },
          heapMemoryUsagePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 9, w: 6, x: 6, y: 0 } },
          errorFailuresOneMinuteCountPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 9, w: 12, x: 12, y: 0 } },
          normalQueryOneMinuteCountPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 9, w: 12, x: 0, y: 9 } },
          abnormalQueryOneMinuteCountPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 9, w: 12, x: 12, y: 9 } },
          normalQueryOneMinuteRatePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 9, w: 12, x: 0, y: 18 } },
          abnormalQueryOneMinuteRatePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 9, w: 12, x: 12, y: 18 } },
          queryExecutionTimeOneMinuteCountPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 27 } },
          cpuTimeConsumedOneMinuteRatePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 35 } },
          cpuInputThroughputOneMinuteCountPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 35 } },
          jvmMetricsRow { gridPos: { h: 1, w: 24, x: 0, y: 43 } },
          garbageCollectionCount(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 44 } },
          garbageCollectionDurationPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 44 } },
          memoryUsedPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 52 } },
          memoryCommittedPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 52 } },
        ]
      ),
  },
}
