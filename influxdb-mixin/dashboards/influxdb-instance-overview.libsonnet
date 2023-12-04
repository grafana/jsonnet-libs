local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'influxdb-instance-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local uptimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'influxdb_uptime_seconds{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Uptime',
  description: 'Time that the InfluxDB process has been running.',
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
        ],
      },
      unit: 's',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local bucketsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'influxdb_buckets_total{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Buckets',
  description: 'Number of buckets on the server.',
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
        ],
      },
      unit: 'none',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local usersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'influxdb_users_total{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Users',
  description: 'Total number of users for the server.',
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
        ],
      },
      unit: 'none',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local replicationsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'influxdb_replications_total{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Replications',
  description: 'Number of replication configurations on the server.',
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
        ],
      },
      unit: 'none',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local remotesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'influxdb_remotes_total{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Remotes',
  description: 'Number of remote connections configured on the server.',
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
        ],
      },
      unit: 'none',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local scrapersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'influxdb_scrapers_total{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Scrapers',
  description: 'Number of scrapers on the server.',
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
        ],
      },
      unit: 'none',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local dashboardsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'influxdb_dashboards_total{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Dashboards',
  description: 'Number of dashboards on the server.',
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
        ],
      },
      unit: 'none',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local threadsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'go_threads{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Threads',
  description: 'Number of threads currently active on the server.',
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
        ],
      },
      unit: 'none',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local goRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Go',
  collapsed: false,
};

local timeSinceLastGCPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'time() - go_memstats_last_gc_time_seconds{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Time since last GC',
  description: 'Amount of time since the last garbage collection cycle.',
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
        ],
      },
      unit: 's',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local gcTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(go_gc_duration_seconds_sum{' + matcher + ', instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'GC time / $__interval',
  description: 'Server CPU time spent on garbage collection.',
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

local gcCPUUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'go_memstats_gc_cpu_fraction{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'GC CPU usage',
  description: 'Percent of server CPU time used for garbage collection.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlYlRd',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
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
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
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

local heapMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'go_memstats_heap_alloc_bytes{' + matcher + ', instance=~"$instance"}/clamp_min((go_memstats_heap_idle_bytes{' + matcher + ', instance=~"$instance"} + go_memstats_heap_alloc_bytes{' + matcher + ', instance=~"$instance"}), 1)',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Heap memory usage',
  description: 'Heap memory usage for the server.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlYlRd',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
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
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      max: 1,
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
      unit: 'percentunit',
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

local goThreadsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'go_threads{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Go threads',
  description: 'Number of OS threads created for the server.',
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
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      decimals: 0,
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

local queriesAndOperationsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Queries and operations',
  collapsed: false,
};

local httpAPIRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(' + matcher + ', instance, status) (rate(http_api_requests_total{' + matcher + ', instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{status}}',
    ),
  ],
  type: 'timeseries',
  title: 'HTTP API requests',
  description: 'Rate of HTTP requests to the API, organized by response code.',
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
      sort: 'desc',
    },
  },
};

local activeQueriesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(' + matcher + ', instance) (qc_compiling_active{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{instance}} - compiling',
    ),
    prometheus.target(
      'sum by(' + matcher + ', instance) (qc_queueing_active{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{instance}} - queueing',
    ),
    prometheus.target(
      'sum by(' + matcher + ', instance) (qc_executing_active{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{instance}} - executing',
    ),
  ],
  type: 'timeseries',
  title: 'Active queries',
  description: 'Number of active queries for the server.',
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
      decimals: 0,
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

local httpOperationsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(' + matcher + ', instance, status) (rate(http_query_request_count{' + matcher + ', instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - query - {{status}}',
    ),
    prometheus.target(
      'sum by(' + matcher + ', instance, status) (rate(http_write_request_count{' + matcher + ', instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - write - {{status}}',
    ),
  ],
  type: 'timeseries',
  title: 'HTTP operations',
  description: 'Rate of database operations from HTTP for the server.',
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
      unit: 'ops',
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

local httpOperationDataPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(' + matcher + ', instance) (rate(http_query_request_bytes{' + matcher + ', instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - query request',
    ),
    prometheus.target(
      'sum by(' + matcher + ', instance) (rate(http_query_response_bytes{' + matcher + ', instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - query response',
    ),
    prometheus.target(
      'sum by(' + matcher + ', instance) (rate(http_write_request_bytes{' + matcher + ', instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - write request',
    ),
    prometheus.target(
      'sum by(' + matcher + ', instance) (rate(http_write_response_bytes{' + matcher + ', instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - write response',
    ),
  ],
  type: 'timeseries',
  title: 'HTTP operation data',
  description: 'Rate of database HTTP operation data for the server.',
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
      unit: 'Bps',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [
        'min',
        'mean',
        'max',
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

local iqlQueryRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(' + matcher + ', instance, result) (rate(influxql_service_requests_total{' + matcher + ', instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{result}}',
    ),
  ],
  type: 'timeseries',
  title: 'IQL query rate',
  description: 'Rate of InfluxQL queries for the server.',
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
      unit: 'queries/s',
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

local iqlQueryResponseTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(' + matcher + ', instance, result) (increase(influxql_service_executing_duration_seconds_sum{' + matcher + ', instance=~"$instance"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{result}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'IQL query response time / $__interval',
  description: 'Response time for recent InfluxQL queries, organized by result.',
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

local boltdbOperationsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(boltdb_reads_total{' + matcher + ', instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - reads',
    ),
    prometheus.target(
      'rate(boltdb_writes_total{' + matcher + ', instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - writes',
    ),
  ],
  type: 'timeseries',
  title: 'BoltDB operations',
  description: 'Rate of reads and writes to the underlying BoltDB storage engine for the server.',
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

local taskSchedulerRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Task scheduler',
  collapsed: false,
};

local activeTasksPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'task_scheduler_current_execution{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Active tasks',
  description: 'Number of tasks currently being executed for the server.',
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
      sort: 'desc',
    },
  },
};

local activeWorkersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'task_executor_total_runs_active{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Active workers',
  description: 'Number of workers currently running tasks on the server.',
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
      sort: 'desc',
    },
  },
};

local workerUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'task_executor_workers_busy{' + matcher + ', instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Worker usage',
  description: 'Percentage of available workers that are currently busy.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlYlRd',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
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
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
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

local executionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(task_scheduler_total_execution_calls{' + matcher + ', instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - total',
    ),
    prometheus.target(
      'rate(task_scheduler_total_execute_failure{' + matcher + ', instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - failed',
    ),
  ],
  type: 'timeseries',
  title: 'Executions',
  description: 'Rate of executions and execution failures for the server.',
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

local schedulesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(task_scheduler_total_schedule_calls{' + matcher + ', instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - total',
    ),
    prometheus.target(
      'rate(task_scheduler_total_schedule_fails{' + matcher + ', instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - failed',
    ),
  ],
  type: 'timeseries',
  title: 'Schedules',
  description: 'Rate of schedule operations and schedule operation failures for the server.',
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

local getMatcher(cfg) = '%(influxdbSelector)s, influxdb_cluster=~"$influxdb_cluster", instance=~"$instance"' % cfg;

{
  grafanaDashboards+:: {
    'influxdb-instance-overview.json':
      dashboard.new(
        'InfluxDB instance overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other InfluxDB dashboards',
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
            'label_values(influxdb_uptime_seconds,job)',
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
            'label_values(influxdb_uptime_seconds{%(multiclusterSelector)s}, cluster)' % $._config,
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'influxdb_cluster',
            promDatasource,
            'label_values(influxdb_uptime_seconds{%(influxdbSelector)s}, influxdb_cluster)' % $._config,
            label='InfluxDB cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(influxdb_uptime_seconds{%(influxdbSelector)s, influxdb_cluster=~"$influxdb_cluster"}, instance)' % $._config,
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          uptimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 0, y: 0 } },
          bucketsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 3, y: 0 } },
          usersPanel(getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 6, y: 0 } },
          replicationsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 9, y: 0 } },
          remotesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 12, y: 0 } },
          scrapersPanel(getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 15, y: 0 } },
          dashboardsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 18, y: 0 } },
          threadsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 3, x: 21, y: 0 } },
          goRow { gridPos: { h: 1, w: 24, x: 0, y: 8 } },
          timeSinceLastGCPanel(getMatcher($._config)) { gridPos: { h: 8, w: 6, x: 0, y: 9 } },
          gcTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 9, x: 6, y: 9 } },
          gcCPUUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 9, x: 15, y: 9 } },
          heapMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 17 } },
          goThreadsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 17 } },
          queriesAndOperationsRow { gridPos: { h: 1, w: 24, x: 0, y: 25 } },
          httpAPIRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 26 } },
          activeQueriesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 26 } },
          httpOperationsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 34 } },
          httpOperationDataPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 34 } },
          iqlQueryRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 42 } },
          iqlQueryResponseTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 42 } },
          boltdbOperationsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 42 } },
          taskSchedulerRow { gridPos: { h: 1, w: 24, x: 0, y: 50 } },
          activeTasksPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 51 } },
          activeWorkersPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 51 } },
          workerUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 51 } },
          executionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 59 } },
          schedulesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 59 } },
        ]
      ),
  },
}
