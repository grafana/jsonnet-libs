local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'couchdb-nodes';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';
local getMatcher(cfg) = '%(couchDBSelector)s, couchdb_cluster=~"$couchdb_cluster", instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local erlangMemoryUsagePanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'couchdb_erlang_memory_bytes{' + getMatcher(cfg) + ', memory_type="total"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Erlang memory usage',
  description: "The amount of memory used by a node's Erlang Virtual Machine.",
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
      sort: 'none',
    },
  },
};

local openOSFilesPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'couchdb_open_os_files_total{' + getMatcher(cfg) + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Open OS files',
  description: 'The total number of file descriptors open on a node',
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

local openDatabasesPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'couchdb_open_databases_total{' + getMatcher(cfg) + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Open databases',
  description: 'The total number of open databases on a node.',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local databaseWritesPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_database_writes_total{' + getMatcher(cfg) + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Database writes',
  description: 'The number of database writes on a node.',
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
      unit: 'wps',
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

local databaseReadsPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_database_reads_total{' + getMatcher(cfg) + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Database reads',
  description: 'The number of database reads on a node.',
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
      unit: 'rps',
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

local viewReadsPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_httpd_view_reads_total{' + getMatcher(cfg) + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'View reads',
  description: 'The number of view reads on a node.',
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
      unit: 'rps',
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

local viewTimeoutsPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_httpd_view_timeouts_total{' + getMatcher(cfg) + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'View timeouts',
  description: 'The number of view requests that timed out on a node.',
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

local temporaryViewReadsPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_httpd_temporary_view_reads_total{' + getMatcher(cfg) + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Temporary view reads',
  description: 'The number of temporary view reads on a node.',
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
      unit: 'rps',
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

local requestsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Requests',
  collapsed: false,
};

local requestMethodsPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_httpd_request_methods{' + getMatcher(cfg) + '}[$__rate_interval]) != 0',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{method}}',
    ),
  ],
  type: 'timeseries',
  title: 'Request methods',
  description: 'The request rate split by HTTP Method for a node.',
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
  options: {
    legend: {
      calcs: [],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local requestLatencyPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'couchdb_request_time_seconds{' + getMatcher(cfg) + ', quantile="0.5"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - p50',
    ),
    prometheus.target(
      'couchdb_request_time_seconds{' + getMatcher(cfg) + ', quantile="0.75"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - p75',
    ),
    prometheus.target(
      'couchdb_request_time_seconds{' + getMatcher(cfg) + ', quantile="0.95"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - p95',
    ),
    prometheus.target(
      'couchdb_request_time_seconds{' + getMatcher(cfg) + ', quantile="0.99"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - p99',
    ),
  ],
  type: 'timeseries',
  title: 'Request latency quantiles',
  description: 'The request latency quantiles for a node.',
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
      unit: 's',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local bulkRequestsPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_httpd_bulk_requests_total{' + getMatcher(cfg) + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Bulk requests',
  description: 'The number of bulk requests for a node.',
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

local responseStatusOverviewPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, couchdb_cluster) (increase(couchdb_httpd_status_codes{' + getMatcher(cfg) + ', code=~"2.*"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{instance}} - 2xx',
      interval='1m',
    ),
    prometheus.target(
      'sum by(instance, couchdb_cluster) (increase(couchdb_httpd_status_codes{' + getMatcher(cfg) + ', code=~"3.*"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{instance}} - 3xx',
      interval='1m',
    ),
    prometheus.target(
      'sum by(instance, couchdb_cluster) (increase(couchdb_httpd_status_codes{' + getMatcher(cfg) + ', code=~"4.*"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{instance}} - 4xx',
      interval='1m',
    ),
    prometheus.target(
      'sum by(instance, couchdb_cluster) (increase(couchdb_httpd_status_codes{' + getMatcher(cfg) + ', code=~"5.*"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{instance}} - 5xx',
      interval='1m',
    ),
  ],
  type: 'piechart',
  title: 'Response status overview',
  description: 'The responses grouped by HTTP status type (2xx, 3xx, 4xx, and 5xx) for a node.',
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
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    pieType: 'pie',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local goodResponseStatusesPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_httpd_status_codes{' + getMatcher(cfg) + ', code=~"[23].*"}[$__rate_interval]) != 0',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{code}}',
    ),
  ],
  type: 'timeseries',
  title: 'Good response statuses',
  description: 'The response rate split by good HTTP statuses for a node.',
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
  options: {
    legend: {
      calcs: [],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local errorResponseStatusesPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(couchdb_httpd_status_codes{' + getMatcher(cfg) + ', code=~"[45].*"}[$__rate_interval]) != 0',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{code}}',
    ),
  ],
  type: 'timeseries',
  title: 'Error response statuses',
  description: 'The response rate split by error HTTP statuses for a node.',
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
  options: {
    legend: {
      calcs: [],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local logsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Logs',
  collapsed: false,
};

local logTypesPanel(cfg) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(couchdb_couch_log_requests_total{' + getMatcher(cfg) + ', level=~"$log_level"}[$__interval:]) != 0',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{level}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Log types',
  description: 'The number of logged messages for a node.',
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
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local systemLogsPanel(cfg) = if !cfg.enableMultiCluster then {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + getMatcher(cfg) + ', filename="/var/log/couchdb/couchdb.log"} |~ "$log_level"',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'System logs',
  description: 'Recent logs from the Apache CouchDB logs file for a node.',
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
} else {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + getMatcher(cfg) + '} |~ "$log_level"',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'System logs',
  description: 'Recent logs from the Apache CouchDB logs file for a node.',
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
    'couchdb-nodes.json':
      dashboard.new(
        'Apache CouchDB nodes',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache CouchDB dashboards',
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
              'label_values(couchdb_couch_replicator_cluster_is_stable, job)',
              label='Job',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
            template.new(
              'cluster',
              promDatasource,
              'label_values(couchdb_couch_replicator_cluster_is_stable{%(multiClusterSelector)s}, cluster)' % $._config,
              label='Cluster',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              hide=if $._config.enableMultiCluster then '' else 'variable' % $._config,
              sort=0
            ),
            template.new(
              'couchdb_cluster',
              promDatasource,
              'label_values(couchdb_couch_replicator_cluster_is_stable{job=~"$job"}, couchdb_cluster)',
              label='CouchDB cluster',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(couchdb_couch_replicator_cluster_is_stable{couchdb_cluster=~"$couchdb_cluster"}, instance)',
              label='Instance',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
            template.new(
              'log_level',
              promDatasource,
              'label_values(couchdb_couch_log_requests_total{instance=~"$instance"}, level)',
              label='Log level',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            erlangMemoryUsagePanel($._config) { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
            openOSFilesPanel($._config) { gridPos: { h: 6, w: 8, x: 8, y: 0 } },
            openDatabasesPanel($._config) { gridPos: { h: 6, w: 8, x: 16, y: 0 } },
            databaseWritesPanel($._config) { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
            databaseReadsPanel($._config) { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
            viewReadsPanel($._config) { gridPos: { h: 6, w: 8, x: 0, y: 12 } },
            viewTimeoutsPanel($._config) { gridPos: { h: 6, w: 8, x: 8, y: 12 } },
            temporaryViewReadsPanel($._config) { gridPos: { h: 6, w: 8, x: 16, y: 12 } },
            requestsRow { gridPos: { h: 1, w: 24, x: 0, y: 18 } },
            bulkRequestsPanel($._config) { gridPos: { h: 6, w: 12, x: 0, y: 19 } },
            requestLatencyPanel($._config) { gridPos: { h: 6, w: 12, x: 12, y: 19 } },
            requestMethodsPanel($._config) { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
            responseStatusOverviewPanel($._config) { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
            goodResponseStatusesPanel($._config) { gridPos: { h: 6, w: 12, x: 0, y: 31 } },
            errorResponseStatusesPanel($._config) { gridPos: { h: 6, w: 12, x: 12, y: 31 } },
            logsRow { gridPos: { h: 1, w: 24, x: 0, y: 37 } },
            logTypesPanel($._config) { gridPos: { h: 6, w: 24, x: 0, y: 38 } },
          ],
          if $._config.enableLokiLogs then [
            systemLogsPanel($._config) { gridPos: { h: 6, w: 24, x: 0, y: 44 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
