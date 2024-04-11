local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local dashboardUid = 'oracledb-overview';

local prometheus = grafana.prometheus;
local promDatasourceName = 'prometheus_datasource';
local getMatcher(cfg) = '%(oracledbSelector)s, instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '$loki_datasource',
};

local databaseStatusPanel(matcher) = {
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

local sessionsPanel(matcher) = {
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

local processPanel(matcher) = {
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

local alertLogPanel(matcher) = {
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
      expr: '{filename=~"/.*/.*/diag/rdbms/.*/.*/trace/alert_.*log",' + matcher + '}',
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

local applicationWaitTimePanel(matcher) = {
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

local commitTimePanel(matcher) = {
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

local concurrencyWaitTime(matcher) = {
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

local configurationWaitTime(matcher) = {
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

local networkWaitTime(matcher) = {
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

local schedulerWaitTime(matcher) = {
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

local systemIOWaitTime(matcher) = {
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

local userIOWaitTime(matcher) = {
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

local tablespaceSizePanel(matcher) = {
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
        'OracleDB overview',
        time_from='%s' % $._config.dashboardPeriod,
        editable=true,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        graphTooltip='shared_crosshair',
        uid=dashboardUid,
      )
      .addTemplates(
        std.flattenArrays(
          [
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
            ],
            if $._config.enableLokiLogs then
              [
                {
                  hide: 0,
                  label: 'Loki datasource',
                  name: 'loki_datasource',
                  query: 'loki',
                  refresh: 1,
                  regex: '',
                  type: 'datasource',
                },
              ] else [],
            [
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
                query='label_values(oracledb_tablespace_bytes{%(oracledbSelector)s, instance=~"$instance"}, tablespace)' % $._config,
                label='Tablespace',
                refresh='time',
                includeAll=true,
                multi=true,
                allValues='.+',
                sort=1
              ),
            ],
          ],
        )
      )
      .addPanels(
        std.flattenArrays([
          [
            databaseStatusPanel(getMatcher($._config)) { gridPos: { h: 6, w: 4, x: 0, y: 0 } },
            sessionsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 10, x: 4, y: 0 } },
            processPanel(getMatcher($._config)) { gridPos: { h: 6, w: 10, x: 14, y: 0 } },
          ],
          if $._config.enableLokiLogs then [
            alertLogPanel(getMatcher($._config)) { gridPos: { h: 7, w: 24, x: 0, y: 6 } },
          ] else [],
          [
            waitTimerow { gridPos: { h: 1, w: 24, x: 0, y: 13 } },
          ],
          [
            applicationWaitTimePanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 0, y: 14 } },
            commitTimePanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 6, y: 14 } },
            concurrencyWaitTime(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 12, y: 14 } },
            configurationWaitTime(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 18, y: 14 } },
          ],
          [
            networkWaitTime(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 0, y: 20 } },
            schedulerWaitTime(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 6, y: 20 } },
            systemIOWaitTime(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 12, y: 20 } },
            userIOWaitTime(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 18, y: 20 } },
          ],
          [
            tablespaceRow { gridPos: { h: 1, w: 24, x: 0, y: 26 } },
          ],
          [
            tablespaceSizePanel(getMatcher($._config)) { gridPos: { h: 6, w: 24, x: 0, y: 27 } },
          ],
        ])
      ),
  },
}
