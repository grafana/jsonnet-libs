local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'presto-coordinator-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local nonheapMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'java_lang_Memory_NonHeapMemoryUsage_used{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"} / clamp_min((java_lang_Memory_NonHeapMemoryUsage_used{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"} + java_lang_Memory_NonHeapMemoryUsage_committed{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}),1)',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}}',
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

local heapMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg (java_lang_Memory_HeapMemoryUsage_used{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"} / clamp_min((java_lang_Memory_HeapMemoryUsage_used{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"} + java_lang_Memory_HeapMemoryUsage_committed{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}),1))',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}}',
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

local normalQueryOneMinuteCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_CompletedQueries_OneMinute_Count{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - completed',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_RunningQueries{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - running',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_StartedQueries_OneMinute_Count{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - started',
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
        drawStyle: 'bars',
        fillOpacity: 20,
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
      calcs: [
        'min',
        'max',
        'mean',
      ],
      displayMode: 'table',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local abnormalQueryOneMinuteCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_FailedQueries_OneMinute_Count{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - failed',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_AbandonedQueries_OneMinute_Count{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - abandoned',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_CanceledQueries_OneMinute_Count{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - canceled',
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
        drawStyle: 'bars',
        fillOpacity: 20,
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
      calcs: [
        'min',
        'max',
        'mean',
      ],
      displayMode: 'table',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local normalQueryOneMinuteRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_CompletedQueries_OneMinute_Rate{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - completed',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_RunningQueries{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - running',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_StartedQueries_OneMinute_Rate{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - started',
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
    overrides: [],
  },
  options: {
    legend: {
      calcs: [
        'min',
        'max',
        'mean',
      ],
      displayMode: 'table',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local abnormalQueryOneMinuteRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_FailedQueries_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - failed',
      format='time_series',
    ),
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_AbandonedQueries_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - abandoned',
    ),
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_CanceledQueries_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - canceled',
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
    overrides: [],
  },
  options: {
    legend: {
      calcs: [
        'min',
        'max',
        'mean',
      ],
      displayMode: 'table',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local queryExecutionTimeOneMinuteCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ExecutionTime_OneMinute_P75{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - p75',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ExecutionTime_OneMinute_P95{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - p95',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ExecutionTime_OneMinute_P99{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - p99',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ExecutionTime_OneMinute_P50{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - p99',
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
      unit: 'ms',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [
        'min',
        'max',
        'mean',
      ],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local cpuTimeConsumedOneMinuteRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_ConsumedCpuTimeSecs_OneMinute_Rate{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} ',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'CPU time consumed - one minute rate',
  description: 'The rate at which queries are consuming CPU time.',
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
      unit: '/ sec',
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

local cpuInputThroughputOneMinuteCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_CpuInputByteRate_OneMinute_Total{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} ',
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

local memoryPoolPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (presto_cluster, instance) (com_facebook_presto_memory_MemoryPool_FreeBytes{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - free',
      format='time_series',
    ),
    prometheus.target(
      'sum by (presto_cluster, instance) (com_facebook_presto_memory_MemoryPool_ReservedBytes{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - reserved',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local errorFailuresOneMinuteCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_InternalFailures_OneMinute_Count{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - internal',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_UserErrorFailures_OneMinute_Count{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - user',
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
      placement: 'right',
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

local garbageCollectionCount = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(java_lang_G1_Young_Generation_CollectionCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} ',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local garbageCollectionDurationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'java_lang_G1_Young_Generation_LastGcInfo_duration{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - non heap',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local memoryUsedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'java_lang_Memory_NonHeapMemoryUsage_used{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - non heap',
      format='time_series',
    ),
    prometheus.target(
      'java_lang_Memory_HeapMemoryUsage_used{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - heap',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local memoryCommittedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'java_lang_Memory_HeapMemoryUsage_committed{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'java_lang_Memory_NonHeapMemoryUsage_committed{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - non heap',
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
      placement: 'right',
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
    'presto-coordinator-overview.json':
      dashboard.new(
        'Presto coordinator overview',
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
            'label_values(com_facebook_presto_failureDetector_HeartbeatFailureDetector_ActiveCount{job=~"$job", cluster=~"$cluster"},cluster)',
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
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
          nonheapMemoryUsagePanel { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
          heapMemoryUsagePanel { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
          normalQueryOneMinuteCountPanel { gridPos: { h: 9, w: 12, x: 0, y: 6 } },
          abnormalQueryOneMinuteCountPanel { gridPos: { h: 9, w: 12, x: 12, y: 6 } },
          normalQueryOneMinuteRatePanel { gridPos: { h: 9, w: 12, x: 0, y: 15 } },
          abnormalQueryOneMinuteRatePanel { gridPos: { h: 9, w: 12, x: 12, y: 15 } },
          queryExecutionTimeOneMinuteCountPanel { gridPos: { h: 8, w: 24, x: 0, y: 24 } },
          cpuTimeConsumedOneMinuteRatePanel { gridPos: { h: 8, w: 12, x: 0, y: 32 } },
          cpuInputThroughputOneMinuteCountPanel { gridPos: { h: 8, w: 12, x: 12, y: 32 } },
          memoryPoolPanel { gridPos: { h: 8, w: 12, x: 0, y: 40 } },
          errorFailuresOneMinuteCountPanel { gridPos: { h: 8, w: 12, x: 12, y: 40 } },
          jvmMetricsRow { gridPos: { h: 1, w: 24, x: 0, y: 48 } },
          garbageCollectionCount { gridPos: { h: 8, w: 12, x: 0, y: 49 } },
          garbageCollectionDurationPanel { gridPos: { h: 8, w: 12, x: 12, y: 49 } },
          memoryUsedPanel { gridPos: { h: 8, w: 12, x: 0, y: 57 } },
          memoryCommittedPanel { gridPos: { h: 8, w: 12, x: 12, y: 57 } },
        ]
      ),
  },
}
