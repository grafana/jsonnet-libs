local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-airflow-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local getMatcher(cfg) = '%(airflowSelector)s, instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local dagFileParsingErrorsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'airflow_dag_processing_import_errors{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'DAG file parsing errors',
  description: 'The number of errors from trying to parse DAG files in an Apache Airflow system.',
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
      decimals: 0,
      mappings: [],
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 1,
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local slaMissesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(airflow_sla_missed{' + matcher + '}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'SLA misses',
  description: 'The number of Service Level Agreement misses for any DAG runs in the Apache Airflow system.',
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
      decimals: 0,
      mappings: [],
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local taskFailuresPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(airflow_ti_failures{' + matcher + '}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Task failures',
  description: 'The overall task instances failures for an Apache Airflow system.',
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
      decimals: 0,
      mappings: [],
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 1,
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local dagSuccessDurationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(airflow_dagrun_duration_success_sum{' + matcher + ', dag_id=~"$dag_id"}[$__interval:])/clamp_min(increase(airflow_dagrun_duration_success_count{' + matcher + ', dag_id=~"$dag_id"}[$__interval:]),1)',
      datasource=promDatasource,
      legendFormat='{{dag_id}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'DAG success duration',
  description: 'The average time taken for recent successful DAG runs by DAG ID in the Apache Airflow system.',
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
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local dagFailedDurationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(airflow_dagrun_duration_failed_sum{' + matcher + ', dag_id=~"$dag_id"}[$__interval:])/clamp_min(increase(airflow_dagrun_duration_failed_count{' + matcher + ', dag_id=~"$dag_id"}[$__interval:]),1)',
      datasource=promDatasource,
      legendFormat='{{dag_id}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'DAG failed duration',
  description: 'The average time taken for recent failed DAG runs by DAG ID in the Apache Airflow system.',
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
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local taskDurationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(airflow_dag_task_duration_sum{' + matcher + ', dag_id=~"$dag_id", task_id=~"$task_id"}[$__interval:]) / clamp_min(increase(airflow_dag_task_duration_count{' + matcher + ', dag_id=~"$dag_id", task_id=~"$task_id"}[$__interval:]),1) != 0',
      datasource=promDatasource,
      legendFormat='{{dag_id}} - {{task_id}}',
      interval='1m',
    ),
  ],
  type: 'bargauge',
  title: 'Task duration',
  description: 'The average time taken for recent task runs by Task ID in the Apache Airflow system.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
      min: 0,
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
    displayMode: 'gradient',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'horizontal',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
    text: {},
  },
  pluginVersion: '9.2.3',
  transformations: [],
};

local taskCountSummaryPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, instance, dag_id, state) (increase(airflow_task_finish_total{' + matcher + ', dag_id=~"$dag_id"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{dag_id}} - {{state}}',
      interval='1m',
    ),
  ],
  type: 'piechart',
  title: 'Task count summary',
  description: 'The number of task counts by DAG ID in the Apache Airflow system.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
      },
      mappings: [],
    },
    overrides: [],
  },
  options: {
    legend: {
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    pieType: 'pie',
    reduceOptions: {
      calcs: [
        'sum',
      ],
      fields: '',
      values: false,
    },
    tooltip: {
      mode: 'multi',
      sort: 'asc',
    },
  },
};

local taskCountsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(airflow_task_finish_total{' + matcher + ', dag_id=~"$dag_id", task_id=~"$task_id", state=~"$state"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{dag_id}} - {{task_id}} - {{state}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Task counts',
  description: 'The number of task counts by Task ID in the Apache Airflow system.',
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
      decimals: 0,
      mappings: [],
      min: 0,
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
      sort: 'none',
    },
  },
  pluginVersion: '9.2.3',
};

local taskLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + matcher + ', dag_id=~"$dag_id", task_id=~"$task_id", filename=~".*/airflow/logs/dag_id.*"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Task logs',
  description: 'Logs for each individual task run on the DAGs.',
  options: {
    dedupStrategy: 'none',
    enableLogDetails: true,
    prettifyLogMessage: false,
    showCommonLabels: false,
    showLabels: false,
    showTime: false,
    sortOrder: 'Descending',
    wrapLogMessage: false,
  },
};

local schedulerDetailsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Scheduler details',
  collapsed: false,
};

local dagScheduleDelayPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(airflow_dagrun_schedule_delay_sum{' + matcher + ', dag_id=~"$dag_id"}[$__interval:]) / clamp_min(increase(airflow_dagrun_schedule_delay_count{' + matcher + ', dag_id=~"$dag_id"}[$__interval:]),1)',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{dag_id}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'DAG schedule delay',
  description: 'The amount of average delay between recent scheduled DAG runtime and the actual DAG runtime by DAG ID in the Apache Airflow system.',
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
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local schedulerTasksPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'airflow_scheduler_tasks_executable{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - executable',
    ),
    prometheus.target(
      'airflow_scheduler_tasks_starving{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - starving',
    ),
  ],
  type: 'timeseries',
  title: 'Scheduler tasks',
  description: 'The number of current tasks that the scheduler is handling in the Apache Airflow system.',
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
      decimals: 0,
      mappings: [],
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
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
      sort: 'none',
    },
  },
};

local executorTasksPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'airflow_executor_running_tasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - running',
    ),
    prometheus.target(
      'airflow_executor_queued_tasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - queued',
    ),
    prometheus.target(
      'airflow_executor_open_slots{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - open',
    ),
  ],
  type: 'timeseries',
  title: 'Executor tasks',
  description: 'The number of current tasks that the executors are handling in the Apache Airflow system.',
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
      decimals: 0,
      mappings: [],
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
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
      sort: 'none',
    },
  },
};

local poolTaskSlotsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'airflow_pool_running_slots{' + matcher + ', pool_name=~"$pool_name"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{pool_name}} - running',
    ),
    prometheus.target(
      'airflow_pool_queued_slots{' + matcher + ', pool_name=~"$pool_name"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{pool_name}} - queued',
    ),
    prometheus.target(
      'airflow_pool_starving_tasks{' + matcher + ', pool_name=~"$pool_name"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{pool_name}} - starving',
    ),
    prometheus.target(
      'airflow_pool_open_slots{' + matcher + ', pool_name=~"$pool_name"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{pool_name}} - open',
    ),
  ],
  type: 'timeseries',
  title: 'Pool task slots',
  description: 'The number of current task slots that the pools are handling in the Apache Airflow system.',
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
      decimals: 0,
      mappings: [],
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
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
      sort: 'none',
    },
  },
};

local schedulerLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + matcher + ', dag_file=~"$dag_file", filename=~".*/airflow/logs/scheduler/latest/.*"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Scheduler logs',
  description: 'Shows the scheduler logs by DAG file.',
  options: {
    dedupStrategy: 'none',
    enableLogDetails: true,
    prettifyLogMessage: false,
    showCommonLabels: false,
    showLabels: false,
    showTime: false,
    sortOrder: 'Descending',
    wrapLogMessage: false,
  },
};

{
  grafanaDashboards+:: {
    'apache-airflow-overview.json':
      dashboard.new(
        'Apache Airflow overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )

      .addTemplates(
        std.flattenArrays([
          [
            template.datasource(
              promDatasourceName,
              'prometheus',
              null,
              label='Prometheus data source',
              refresh='load'
            ),
          ],
          if $._config.enableLokiLogs then [
            template.datasource(
              lokiDatasourceName,
              'loki',
              null,
              label='Loki data source',
              refresh='load'
            ),
          ] else [],
          [
            template.new(
              'job',
              promDatasource,
              'label_values(airflow_scheduler_tasks_executable,job)',
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
              'label_values(airflow_scheduler_tasks_executable{%(multiclusterSelector)s}, cluster)' % $._config,
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
              'label_values(airflow_scheduler_tasks_executable{%(airflowSelector)s}, instance)',
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'dag_id',
              promDatasource,
              'label_values(airflow_task_start_total{%(airflowSelector)s, instance=~"$instance"}, dag_id)',
              label='DAG',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'task_id',
              promDatasource,
              'label_values(airflow_task_start_total{%(airflowSelector)s, instance=~"$instance", dag_id=~"$dag_id"}, task_id)',
              label='Task',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'state',
              promDatasource,
              'label_values(airflow_task_finish_total{%(airflowSelector)s, instance=~"$instance", dag_id=~"$dag_id", task_id=~"$task_id"}, state)',
              label='Task state',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'pool_name',
              promDatasource,
              'label_values(airflow_pool_open_slots{%(airflowSelector)s, instance=~"$instance"}, pool_name)',
              label='Pool',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),

          ],
          if $._config.enableLokiLogs then [
            template.new(
              'dag_file',
              lokiDatasource,
              'label_values(dag_file)',
              label='DAG file',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
          ] else [],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            dagFileParsingErrorsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 0 } },
            slaMissesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 0 } },
            taskFailuresPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 0 } },
            dagSuccessDurationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            dagFailedDurationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
            taskDurationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
            taskCountSummaryPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
            taskCountsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 24 } },
          ],
          if $._config.enableLokiLogs then [
            taskLogsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 32 } },
          ] else [],
          [
            schedulerDetailsRow { gridPos: { h: 1, w: 24, x: 0, y: 40 } },
            dagScheduleDelayPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 41 } },
            schedulerTasksPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 41 } },
            executorTasksPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 49 } },
            poolTaskSlotsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 49 } },
          ],
          if $._config.enableLokiLogs then [
            schedulerLogsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 57 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
