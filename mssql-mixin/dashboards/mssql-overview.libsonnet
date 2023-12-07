local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'mssql-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local connectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mssql_connections{instance=~"$instance", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{db}}',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'The number of network connections to each database.',
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
        fillOpacity: 54,
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
          mode: 'normal',
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
      unit: 'connections',
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

local batchRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mssql_batch_requests_total{instance=~"$instance", job=~"$job"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Batch requests',
  description: 'Number of batch requests.',
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
      unit: 'reqps',
    },
    overrides: [],
  },
  interval: '1m',
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

local severeErrorsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mssql_kill_connection_errors_total{instance=~"$instance", job=~"$job"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Severe errors',
  description: 'Number of severe errors that caused connections to be killed.',
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
      unit: 'errors',
    },
    overrides: [],
  },
  interval: '1m',
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

local deadlocksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mssql_deadlocks_total{instance=~"$instance", job=~"$job"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Deadlocks',
  description: 'Rate of deadlocks occurring over time.',
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
      unit: 'deadlocks',
    },
    overrides: [],
  },
  interval: '1m',
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

local osMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mssql_os_memory{instance=~"$instance", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{state}}',
    ),
  ],
  type: 'timeseries',
  title: 'OS memory usage',
  description: 'The amount of physical memory available and used by SQL Server.',
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
        fillOpacity: 51,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineStyle: {
          fill: 'solid',
        },
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
};

local memoryManagerPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mssql_server_total_memory_bytes{instance=~"$instance", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - total',
    ),
    prometheus.target(
      'mssql_server_target_memory_bytes{instance=~"$instance", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - target',
    ),
  ],
  type: 'timeseries',
  title: 'Memory manager',
  description: 'The committed memory and target committed memory for the SQL Server memory manager. See https://learn.microsoft.com/en-us/sql/relational-databases/performance-monitor/monitor-memory-usage?view=sql-server-ver16#isolating-memory-used-by-',
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
        fillOpacity: 51,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineStyle: {
          fill: 'solid',
        },
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local committedMemoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * mssql_server_total_memory_bytes{instance=~"$instance", job=~"$job"} / clamp_min(mssql_available_commit_memory_bytes{instance=~"$instance", job=~"$job"},1)',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'gauge',
  title: 'Committed memory utilization',
  description: 'The committed memory utilization',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
      max: 100,
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
      unit: 'percent',
    },
    overrides: [],
  },
  options: {
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
  pluginVersion: '9.1.7',
};

local errorLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{instance=~"$instance", job=~"$job", log_type="mssql_error"}',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Error logs',
  description: 'Recent logs from the error log file.',
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

local databaseRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Database',
  collapsed: false,
};

local databaseWriteStallDurationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mssql_io_stall_seconds_total{instance=~"$instance", job=~"$job", db=~"$database", operation="write"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{db}}',
    ),
  ],
  type: 'timeseries',
  title: 'Database write stall duration',
  description: 'The current stall (latency) for database writes.',
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
        ],
      },
      unit: 's',
    },
    overrides: [],
  },
  interval: '1m',
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

local databaseReadStallDurationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mssql_io_stall_seconds_total{instance=~"$instance", job=~"$job", db=~"$database", operation="read"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{db}}',
    ),
  ],
  type: 'timeseries',
  title: 'Database read stall duration',
  description: 'The current stall (latency) for database reads.',
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
        ],
      },
      unit: 's',
    },
    overrides: [],
  },
  interval: '1m',
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

local transactionLogExpansionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mssql_log_growths_total{instance=~"$instance", job=~"$job", db=~"$database"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{db}}',
    ),
  ],
  type: 'timeseries',
  title: 'Transaction log expansions',
  description: 'Number of times the transaction log has been expanded for a database.',
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
      unit: 'expansions',
    },
    overrides: [],
  },
  interval: '1m',
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

{
  grafanaDashboards+:: {
    'mssql-overview.json':
      dashboard.new(
        'MSSQL overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='An overview of an MSSQL instance.',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other MSSQL dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates(
        std.flattenArrays([
          [
            template.datasource(
              promDatasourceName,
              'prometheus',
              null,
              label='Data Source',
              refresh='load'
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
          [
            template.new(
              'job',
              promDatasource,
              'label_values(mssql_build_info{}, job)',
              label='Job',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=2
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(mssql_build_info{job=~"$job"}, instance)',
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=2
            ),
            template.new(
              'database',
              promDatasource,
              'label_values(mssql_log_growths_total{job=~"$job", instance=~"$instance"}, db)',
              label='Database',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=2
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            connectionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
            batchRequestsPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
            severeErrorsPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            deadlocksPanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
            osMemoryUsagePanel { gridPos: { h: 8, w: 24, x: 0, y: 16 } },
            memoryManagerPanel { gridPos: { h: 8, w: 16, x: 0, y: 24 } },
            committedMemoryUtilizationPanel { gridPos: { h: 8, w: 8, x: 16, y: 24 } },
          ],
          if $._config.enableLokiLogs then [
            errorLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 32 } },
          ] else [],
          [
            databaseRow { gridPos: { h: 1, w: 24, x: 0, y: 40 } },
            databaseWriteStallDurationPanel { gridPos: { h: 8, w: 12, x: 0, y: 41 } },
            databaseReadStallDurationPanel { gridPos: { h: 8, w: 12, x: 12, y: 41 } },
            transactionLogExpansionsPanel { gridPos: { h: 8, w: 24, x: 0, y: 49 } },
          ],
        ])
      ),

  },
}
