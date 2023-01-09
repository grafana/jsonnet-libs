local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local dashboardUid = 'oracledb-overview';

local prometheus = grafana.prometheus;
local promDatasourceName = 'prometheus_datasource';
local matcher = 'job=~"$job", instance=~"$instance"';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '$loki_datasource',
};

local databaseStatusPanel = {
  description: 'Database status either Up or Down. Colored to be green when Up or red when Down',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [
        {
          options: {
            '0': {
              index: 0,
              text: 'Down',
            },
            '1': {
              index: 1,
              text: 'OK',
            },
          },
          type: 'value',
        },
      ],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'red',
          },
          {
            color: 'green',
            value: 1,
          },
        ],
      },
    },
    overrides: [],
  },
  options: {
    colorMode: 'value',
    graphMode: 'none',
    justifyMode: 'auto',
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    textMode: 'auto',
  },
  pluginVersion: '9.1.8',
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_up{' + matcher + '}',
      legendFormat: '__auto',
      range: true,
      refId: 'A',
    },
  ],
  title: 'Database status',
  type: 'stat',
};

local cpuSecondsPanel = {
  datasource: promDatasource,
  description: 'Amount of CPU time, in seconds, used by OracleDB over a window.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
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
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'increase(process_cpu_seconds_total{' + matcher + '}[$__rate_interval])',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'CPU seconds',
  type: 'timeseries',
};

local virtualMemoryPanel = {
  datasource: promDatasource,
  description: 'Used virtual memory overtime.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
      unit: 'bytes',
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
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'process_virtual_memory_bytes{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'Virtual memory',
  type: 'timeseries',
};

local openFdsPanel = {
  datasource: promDatasource,
  description: 'Number of open file descriptors and the limit overtime.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
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
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'process_open_fds{' + matcher + '}',
      legendFormat: '{{instance}} - open',
      range: true,
      refId: 'OPEN',
    },
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'process_max_fds{' + matcher + '}',
      hide: false,
      legendFormat: '{{instance}} - limit',
      range: true,
      refId: 'MAX',
    },
  ],
  title: 'Open file descriptors',
  type: 'timeseries',
};

local sessionsPanel = {
  datasource: promDatasource,
  description: 'Number of sessions and the limit overtime.',
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
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_resource_current_utilization{' + matcher + ',resource_name="sessions"}',
      legendFormat: '{{instance}} - open',
      range: true,
      refId: 'Open',
    },
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_resource_limit_value{' + matcher + ',resource_name="sessions"}',
      hide: false,
      legendFormat: '{{instance}} - limit',
      range: true,
      refId: 'Limit',
    },
  ],
  title: 'Sessions',
  type: 'timeseries',
};

local processPanel = {
  datasource: promDatasource,
  description: 'Number of processes and the limit overtime.',
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
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_resource_current_utilization{' + matcher + ',resource_name="processes"}',
      legendFormat: '{{instance}} - current',
      range: true,
      refId: 'Current',
    },
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_resource_limit_value{' + matcher + ',resource_name="processes"}',
      hide: false,
      legendFormat: '{{instance}} - limit',
      range: true,
      refId: 'Limit',
    },
  ],
  title: 'Processes',
  type: 'timeseries',
};

local alertLogPanel = {
  datasource: lokiDatasource,
  description: 'Recent logs from alert log file',
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
  pluginVersion: '9.1.8',
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'builder',
      expr: '{filename=~"/u01/base/diag/rdbms/.*/.*/trace/alert_.*log",' + matcher + '}',
      queryType: 'range',
      refId: 'A',
    },
  ],
  title: 'Alert logs',
  type: 'logs',
};

local waitTimerow = {
  collapsed: false,
  title: 'Wait time',
  type: 'row',
};

local applicationWaitTimePanel = {
  datasource: promDatasource,
  description: 'Application wait time, in seconds, waiting for wait events.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_wait_time_application{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'Application wait time',
  type: 'timeseries',
};

local commitTimePanel = {
  datasource: promDatasource,
  description: 'Commit wait time, in seconds, waiting for wait events.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_wait_time_commit{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'Commit wait time',
  type: 'timeseries',
};

local concurrencyWaitTime = {
  datasource: promDatasource,
  description: 'Concurrency wait time, in seconds, waiting for wait events.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_wait_time_concurrency{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'Concurrency wait time',
  type: 'timeseries',
};

local configurationWaitTime = {
  datasource: promDatasource,
  description: 'Configuration wait time, in seconds waiting for wait events.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_wait_time_configuration{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'Configuration wait time',
  type: 'timeseries',
};

local networkWaitTime = {
  datasource: promDatasource,
  description: 'Network wait time, in seconds, waiting for wait events.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_wait_time_network{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'Network wait time',
  type: 'timeseries',
};

local schedulerWaitTime = {
  datasource: promDatasource,
  description: 'Scheduler wait time, in seconds, waiting for wait events.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_wait_time_scheduler{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'Scheduler wait time',
  type: 'timeseries',
};

local systemIOWaitTime = {
  datasource: promDatasource,
  description: 'System I/O wait time, in seconds, waiting for wait events.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_wait_time_system_io{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'System I/O wait time',
  type: 'timeseries',
};

local userIOWaitTime = {
  datasource: promDatasource,
  description: 'User I/O wait time, in seconds, waiting for wait events.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
  targets: [
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_wait_time_user_io{' + matcher + '}',
      legendFormat: '{{instance}}',
      range: true,
      refId: 'A',
    },
  ],
  title: 'User I/O wait time',
  type: 'timeseries',
};

local tablespaceRow = {
  collapsed: false,
  title: 'Tablespace',
  type: 'row',
};

local tablespaceSizePanel = {
  datasource: promDatasource,
  description: 'Shows the size overtime for the tablespace.',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
      unit: 'bytes',
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
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_tablespace_bytes{' + matcher + ',tablespace=~"$tablespace"}',
      legendFormat: '{{instance}} - {{tablespace}} - used',
      range: true,
      refId: 'Used Bytes',
    },
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_tablespace_free{' + matcher + ',tablespace=~"$tablespace"}',
      hide: false,
      legendFormat: '{{instance}} - {{tablespace}} - free',
      range: true,
      refId: 'Free',
    },
    {
      datasource: promDatasource,
      editorMode: 'code',
      expr: 'oracledb_tablespace_max_bytes{' + matcher + ',tablespace=~"$tablespace"}',
      hide: false,
      legendFormat: '{{instance}} - {{tablespace}} - max',
      range: true,
      refId: 'Max',
    },
  ],
  title: 'Tablespace size',
  type: 'timeseries',
};

{
  grafanaDashboards+:: {
    'oracledb-overview.json':
      dashboard.new(
        'OracleDB Overview',
        time_from='%s' % $._config.dashboardPeriod,
        editable=true,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        graphTooltip='shared_crosshair',
        uid=dashboardUid,
      )
      .addTemplates(
        [
          {
            hide: 0,
            label: 'Data source',
            name: promDatasourceName,
            query: 'prometheus',
            refresh: 1,
            regex: '',
            type: 'datasource',
          },
          {
            hide: 0,
            label: 'Loki datasource',
            name: 'loki_datasource',
            query: 'loki',
            refresh: 1,
            regex: '',
            type: 'datasource',
          },
          template.new(
            'job',
            promDatasource,
            query='label_values(oracledb_up, job)',
            label='Job',
            refresh='time',
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            name='instance',
            label='Instance',
            datasource='$prometheus_datasource',
            query='label_values(oracledb_up, instance)',
            current='',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'tablespace',
            promDatasource,
            query='label_values(oracledb_tablespace_bytes, tablespace)',
            label='Tablespace',
            refresh='time',
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
        ],
      )
      .addPanels(
        std.flattenArrays([
          [
            databaseStatusPanel { gridPos: { h: 4, w: 4, x: 0, y: 0 } },
            cpuSecondsPanel { gridPos: { h: 4, w: 12, x: 4, y: 0 } },
            virtualMemoryPanel { gridPos: { h: 4, w: 8, x: 16, y: 0 } },
          ],
          [
            openFdsPanel { gridPos: { h: 6, w: 8, x: 0, y: 4 } },
            sessionsPanel { gridPos: { h: 6, w: 8, x: 8, y: 4 } },
            processPanel { gridPos: { h: 6, w: 8, x: 16, y: 4 } },
          ],
          if $._config.enableLokiLogs then [
            alertLogPanel { gridPos: { h: 7, w: 24, x: 0, y: 10 } },
          ] else [],
          [
            waitTimerow { gridPos: { h: 1, w: 24, x: 0, y: 17 } },
          ],
          [
            applicationWaitTimePanel { gridPos: { h: 6, w: 6, x: 0, y: 18 } },
            commitTimePanel { gridPos: { h: 6, w: 6, x: 6, y: 18 } },
            concurrencyWaitTime { gridPos: { h: 6, w: 6, x: 12, y: 18 } },
            configurationWaitTime { gridPos: { h: 6, w: 6, x: 18, y: 18 } },
          ],
          [
            networkWaitTime { gridPos: { h: 6, w: 6, x: 0, y: 24 } },
            schedulerWaitTime { gridPos: { h: 6, w: 6, x: 6, y: 24 } },
            systemIOWaitTime { gridPos: { h: 6, w: 6, x: 12, y: 24 } },
            userIOWaitTime { gridPos: { h: 6, w: 6, x: 18, y: 24 } },
          ],
          [
            tablespaceRow { gridPos: { h: 1, w: 24, x: 0, y: 30 } },
          ],
          [
            tablespaceSizePanel { gridPos: { h: 6, w: 24, x: 0, y: 31 } },
          ],
        ])
      ),
  },
}
