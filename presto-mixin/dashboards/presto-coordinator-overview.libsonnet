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

local normalQueryCountPanel = {
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
  title: 'Normal query count',
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

local abnormalQueryCountPanel = {
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
  title: 'Abnormal query count',
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
        fillOpacity: 25,
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

local normalQueryRatesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_CompletedQueries_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - completed',
      format='time_series',
    ),
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_RunningQueries{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - running',
    ),
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_StartedQueries_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - started',
    ),
  ],
  type: 'timeseries',
  title: 'Normal query rates',
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

local abnormalQueryRatesPanel = {
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
  title: 'Abnormal query rates',
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

local queryExecutionTimeOverOneMinutePanel = {
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
  ],
  type: 'timeseries',
  title: 'Query execution time over one minute',
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

local cpuTimeConsumedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_ConsumedCpuTimeSecs_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} ',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'CPU time consumed',
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

local cpuInputThroughputOverOneMinutePanel = {
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
  title: 'CPU input throughput over one minute',
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

local errorFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_InternalFailures_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - internal',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_QueryManager_UserErrorFailures_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - user',
    ),
  ],
  type: 'timeseries',
  title: 'Error failures',
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
            includeAll=true,
            multi=true,
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
          normalQueryCountPanel { gridPos: { h: 9, w: 12, x: 0, y: 0 } },
          abnormalQueryCountPanel { gridPos: { h: 9, w: 12, x: 12, y: 0 } },
          normalQueryRatesPanel { gridPos: { h: 9, w: 12, x: 0, y: 9 } },
          abnormalQueryRatesPanel { gridPos: { h: 9, w: 12, x: 12, y: 9 } },
          queryExecutionTimeOverOneMinutePanel { gridPos: { h: 8, w: 24, x: 0, y: 18 } },
          cpuTimeConsumedPanel { gridPos: { h: 8, w: 12, x: 0, y: 26 } },
          cpuInputThroughputOverOneMinutePanel { gridPos: { h: 8, w: 12, x: 12, y: 26 } },
          memoryPoolPanel { gridPos: { h: 8, w: 12, x: 0, y: 34 } },
          errorFailuresPanel { gridPos: { h: 8, w: 12, x: 12, y: 34 } },
          jvmMetricsRow { gridPos: { h: 1, w: 24, x: 0, y: 42 } },
          garbageCollectionCount { gridPos: { h: 8, w: 12, x: 0, y: 43 } },
          garbageCollectionDurationPanel { gridPos: { h: 8, w: 12, x: 12, y: 43 } },
          memoryUsedPanel { gridPos: { h: 8, w: 12, x: 0, y: 51 } },
          memoryCommittedPanel { gridPos: { h: 8, w: 12, x: 12, y: 51 } },
        ]
      ),
  },
}
