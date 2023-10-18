local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'presto-worker-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local queuedTasksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_executor_TaskExecutor_ProcessorExecutor_QueuedTaskCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Queued tasks',
  description: 'The rate at which tasks are being queued by the task executor.',
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
      unit: 'cps',
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

local failedTasksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_TaskManager_FailedTasks_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Failed tasks',
  description: 'The rate at which tasks are failing.',
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
      unit: 'cps',
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

local completedTasksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_executor_TaskExecutor_ProcessorExecutor_CompletedTaskCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Completed tasks',
  description: 'The number of tasks that are completed by the task executor.',
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
      unit: 'cps',
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

local outputPositionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_TaskManager_OutputPositions_OneMinute_Count{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Output positions',
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

local executorPoolSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_execution_TaskManager_TaskNotificationExecutor_PoolSize{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - task notification',
      format='time_series',
    ),
    prometheus.target(
      'com_facebook_presto_execution_executor_TaskExecutor_ProcessorExecutor_CorePoolSize{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - process executor core',
    ),
    prometheus.target(
      'com_facebook_presto_execution_executor_TaskExecutor_ProcessorExecutor_PoolSize{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - process executor',
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

local memoryPoolPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (instance, presto_cluster) (com_facebook_presto_memory_MemoryPool_FreeBytes{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - free',
      format='time_series',
    ),
    prometheus.target(
      'sum by (instance, presto_cluster) (com_facebook_presto_memory_MemoryPool_ReservedBytes{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"})',
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

local dataThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_TaskManager_InputDataSize_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - input',
      format='time_series',
    ),
    prometheus.target(
      'rate(com_facebook_presto_execution_TaskManager_OutputDataSize_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - {{instance}} - output',
    ),
  ],
  type: 'timeseries',
  title: 'Data throughput',
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
      unit: 'Bps',
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
    'presto-worker-overview.json':
      dashboard.new(
        'Presto worker overview',
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
            includeAll=true,
            multi=true,
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
          queuedTasksPanel { gridPos: { h: 8, w: 8, x: 0, y: 0 } },
          failedTasksPanel { gridPos: { h: 8, w: 8, x: 8, y: 0 } },
          completedTasksPanel { gridPos: { h: 8, w: 8, x: 16, y: 0 } },
          outputPositionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          executorPoolSizePanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          memoryPoolPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          dataThroughputPanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          jvmMetricsRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
          memoryUsedPanel { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
          memoryCommittedPanel { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
        ]
      ),
  },
}
