local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'couchdb-overview';

local promDatasourceName = 'prometheus_datasource';
local matcher = 'job=~"$job", couchdb_cluster=~"$couchdb_cluster"';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local numberOfClustersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count by(couchdb_cluster, job) (couchdb_request_time_seconds_count{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{ couchdb_cluster }}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Number of clusters',
  description: 'The number of clusters being reported.',
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
            color: 'yellow',
            value: null,
          },
          {
            color: 'red',
            value: 0,
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
  pluginVersion: '9.2.3',
};

local numberOfNodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(count by(couchdb_cluster, job) (couchdb_request_time_seconds_count{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{ couchdb_cluster }}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Number of nodes',
  description: 'The number of nodes being reported.',
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
            color: 'red',
            value: null,
          },
          {
            color: 'red',
            value: 0,
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
  pluginVersion: '9.2.3',
};

local clusterHealthPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(min by(job, couchdb_cluster) (couchdb_couch_replicator_cluster_is_stable{' + matcher + '})) / count(count by(job, couchdb_cluster) (couchdb_couch_replicator_cluster_is_stable{' + matcher + '})) * 100',
      datasource=promDatasource,
      legendFormat='{{ couchdb_cluster }}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Clusters healthy',
  description: 'Percentage of clusters that have all nodes that are currently reporting healthy.',
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
            color: 'yellow',
            value: null,
          },
          {
            color: 'red',
            value: 0,
          },
          {
            color: 'yellow',
            value: 1,
          },
          {
            color: 'green',
            value: 100,
          },
        ],
      },
      unit: 'percent',
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
    text: {},
    textMode: 'auto',
  },
  pluginVersion: '9.2.3',
};

local openOSFilesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchdb_cluster, job) (couchdb_open_os_files_total{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Open OS files',
  description: 'The total number of file descriptors open aggregated across all nodes.',
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

local openDatabasesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (couchdb_open_databases_total{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Open databases',
  description: 'The total number of open databases aggregated across all nodes.',
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

local databaseWritesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (rate(couchdb_database_writes_total{' + matcher + '}[$__rate_interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Database writes',
  description: 'The number of database writes aggregated across all nodes.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local databaseReadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (rate(couchdb_database_reads_total{' + matcher + '}[$__rate_interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Database reads',
  description: 'The number of database reads aggregated across all nodes.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local viewReadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (rate(couchdb_httpd_view_reads_total{' + matcher + '}[$__rate_interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'View reads',
  description: 'The number of view reads aggregated across all nodes.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local viewTimeoutsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (rate(couchdb_httpd_view_timeouts_total{' + matcher + '}[$__rate_interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'View timeouts',
  description: 'The number of view requests that timed out aggregated across all nodes.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local temporaryViewReadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (rate(couchdb_httpd_temporary_view_reads_total{' + matcher + '}[$__rate_interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Temporary view reads',
  description: 'The number of temporary view reads aggregated across all nodes.',
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
      mode: 'single',
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

local requestMethodsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster, method) (rate(couchdb_httpd_request_methods{' + matcher + '}[$__rate_interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - {{method}}',
    ),
  ],
  type: 'timeseries',
  title: 'Request methods',
  description: 'The request rate split by HTTP Method aggregated across all nodes.',
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

local averageRequestLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, couchdb_cluster, quantile) (couchdb_request_time_seconds{' + matcher + ', quantile=~"0.5"})',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - p50',
    ),
    prometheus.target(
      'avg by(job, couchdb_cluster, quantile) (couchdb_request_time_seconds{' + matcher + ', quantile=~"0.75"})',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - p75',
    ),
    prometheus.target(
      'avg by(job, couchdb_cluster, quantile) (couchdb_request_time_seconds{' + matcher + ', quantile=~"0.95"})',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - p95',
    ),
    prometheus.target(
      'avg by(job, couchdb_cluster, quantile) (couchdb_request_time_seconds{' + matcher + ', quantile=~"0.99"})',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - p99',
    ),
  ],
  type: 'timeseries',
  title: 'Request latency quantiles',
  description: 'The average request latency quantiles aggregated across all nodes.',
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
  pluginVersion: '9.2.3',
};

local bulkRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (rate(couchdb_httpd_bulk_requests_total{' + matcher + '}[$__rate_interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Bulk requests',
  description: 'The number of bulk requests aggregated across all nodes.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local responseStatusOverviewPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_httpd_status_codes{' + matcher + ', code=~"2.*"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - 2xx',
    ),
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_httpd_status_codes{' + matcher + ', code=~"3.*"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - 3xx',
    ),
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_httpd_status_codes{' + matcher + ', code=~"4.*"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - 4xx',
    ),
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_httpd_status_codes{' + matcher + ', code=~"5.*"}[$__interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - 5xx',
    ),
  ],
  type: 'piechart',
  title: 'Response status overview',
  description: 'The responses grouped by HTTP status type (2xx, 3xx, 4xx, and 5xx) aggregated across all nodes.',
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

local goodResponseStatusesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster, code) (rate(couchdb_httpd_status_codes{' + matcher + ', code=~"[23].*"}[$__rate_interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - {{code}}',
    ),
  ],
  type: 'timeseries',
  title: 'Response statuses',
  description: 'The response rate split by good HTTP statuses aggregated across all nodes.',
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

local errorResponseStatusesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster, code) (rate(couchdb_httpd_status_codes{' + matcher + ', code=~"[45].*"}[$__rate_interval:])) != 0',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}} - {{code}}',
    ),
  ],
  type: 'timeseries',
  title: 'Error response statuses',
  description: 'The response rate split by error HTTP statuses aggregated across all nodes.',
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

local replicationRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Replication',
  collapsed: false,
};

local replicatorChangesManagerDeathsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_couch_replicator_changes_manager_deaths_total{' + matcher + '}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Replicator changes manager deaths',
  description: 'Number of replicator changes manager processor deaths across all nodes.',
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

local replicatorChangesQueueDeathsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_couch_replicator_changes_queue_deaths_total{' + matcher + '}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Replicator changes queue deaths',
  description: 'Number of replicator changes queue processor deaths across all nodes.',
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

local replicatorChangesReaderDeathsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_couch_replicator_changes_reader_deaths_total{' + matcher + '}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Replicator changes reader deaths',
  description: 'Number of replicator changes reader processor deaths across all nodes.',
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

local replicatorConnectionOwnerCrashesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_couch_replicator_connection_owner_crashes_total{' + matcher + '}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Replicator connection owner crashes',
  description: 'Number of replicator connection owner crashes across all nodes.',
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

local replicatorConnectionWorkerCrashesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_couch_replicator_connection_worker_crashes_total{' + matcher + '}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Replicator connection worker crashes',
  description: 'Number of replicator connection worker crashes across all nodes.',
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

local replicatorJobCrashesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (increase(couchdb_couch_replicator_jobs_crashes_total{' + matcher + '}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Replicator job crashes',
  description: 'Number of replicator job crashes across all nodes.',
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

local replicatorJobsPendingPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchdb_cluster) (couchdb_couch_replicator_jobs_pending{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{couchdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Replicator jobs pending',
  description: 'Number of replicator jobs pending across all nodes.',
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
};

{
  grafanaDashboards+:: {
    'couchdb-overview.json':
      dashboard.new(
        'Apache CouchDB overview',
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
            'label_values(couchdb_couch_replicator_cluster_is_stable, job)',
            label='Job',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
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
        ]
      )
      .addPanels(
        [
          numberOfClustersPanel { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
          numberOfNodesPanel { gridPos: { h: 6, w: 8, x: 8, y: 0 } },
          clusterHealthPanel { gridPos: { h: 6, w: 8, x: 16, y: 0 } },
          openOSFilesPanel { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          openDatabasesPanel { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          databaseWritesPanel { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
          databaseReadsPanel { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
          viewReadsPanel { gridPos: { h: 6, w: 8, x: 0, y: 18 } },
          viewTimeoutsPanel { gridPos: { h: 6, w: 8, x: 8, y: 18 } },
          temporaryViewReadsPanel { gridPos: { h: 6, w: 8, x: 16, y: 18 } },
          requestsRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
          bulkRequestsPanel { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
          averageRequestLatencyPanel { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
          requestMethodsPanel { gridPos: { h: 6, w: 12, x: 0, y: 31 } },
          responseStatusOverviewPanel { gridPos: { h: 6, w: 12, x: 12, y: 31 } },
          goodResponseStatusesPanel { gridPos: { h: 6, w: 12, x: 0, y: 37 } },
          errorResponseStatusesPanel { gridPos: { h: 6, w: 12, x: 12, y: 37 } },
          replicationRow { gridPos: { h: 1, w: 24, x: 0, y: 43 } },
          replicatorChangesManagerDeathsPanel { gridPos: { h: 6, w: 8, x: 0, y: 44 } },
          replicatorChangesQueueDeathsPanel { gridPos: { h: 6, w: 8, x: 8, y: 44 } },
          replicatorChangesReaderDeathsPanel { gridPos: { h: 6, w: 8, x: 16, y: 44 } },
          replicatorConnectionOwnerCrashesPanel { gridPos: { h: 6, w: 12, x: 0, y: 50 } },
          replicatorConnectionWorkerCrashesPanel { gridPos: { h: 6, w: 12, x: 12, y: 50 } },
          replicatorJobCrashesPanel { gridPos: { h: 6, w: 12, x: 0, y: 56 } },
          replicatorJobsPendingPanel { gridPos: { h: 6, w: 12, x: 12, y: 56 } },
        ]
      ),
  },
}
