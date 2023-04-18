local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'microsoft-iis-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local requestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_iis_requests_total{job=~"$job", instance=~"$instance", site=~"$site"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{site}} - {{method}}',
    ),
  ],
  type: 'timeseries',
  title: 'Requests',
  description: 'The request rate split by HTTP Method for an IIS site',
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
      decimals: 0,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
};

local requestErrorsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_iis_locked_errors_total{job=~"$job", instance=~"$instance", site=~"$site"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{site}} - locked',
    ),
    prometheus.target(
      'rate(windows_iis_not_found_errors_total{job=~"$job", instance=~"$instance", site=~"$site"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{site}} - not found',
    ),
  ],
  type: 'timeseries',
  title: 'Request errors',
  description: 'Requests that have resulted in errors for an IIS site.',
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
      unit: 'errors/sec',
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

local blockedAsyncIORequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_blocked_async_io_requests_total{job=~"$job", instance=~"$instance", site=~"$site"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{site}}',
    ),
  ],
  type: 'timeseries',
  title: 'Blocked async I/O requests',
  description: 'Number of async I/O requests that are currently queued for an IIS site.',
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
      unit: 'requests',
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
      mode: 'none',
      sort: 'none',
    },
  },
};

local rejectedAsyncIORequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_rejected_async_io_requests_total{job=~"$job", instance=~"$instance", site=~"$site"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{site}}',
    ),
  ],
  type: 'timeseries',
  title: 'Rejected async I/O requests',
  description: 'Number of async I/O requests that have been rejected for an IIS site.',
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
      unit: 'requests',
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

local trafficSentPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_iis_sent_bytes_total{job=~"$job", instance=~"$instance", site=~"$site"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{site}}',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic sent',
  description: 'The traffic sent by an IIS site.',
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
      unit: 'Bps',
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

local trafficReceivedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_iis_received_bytes_total{job=~"$job", instance=~"$instance", site=~"$site"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{site}}',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic received',
  description: 'The traffic received by an IIS site.',
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
      unit: 'Bps',
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

local filesSentPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_iis_files_sent_total{job=~"$job", instance=~"$instance",  site=~"$site"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{site}}',
    ),
  ],
  type: 'timeseries',
  title: 'Files sent',
  description: 'The files sent by an IIS site.',
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
      unit: 'files/s',
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

local filesReceivedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_iis_files_received_total{job=~"$job", instance=~"$instance",  site=~"$site"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{site}}',
    ),
  ],
  type: 'timeseries',
  title: 'Files received',
  description: 'The files received by an IIS site.',
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
      unit: 'files/s',
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

local currentConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'windows_iis_current_connections{job=~"$job", instance=~"$instance", site=~"$site"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{site}}',
    ),
  ],
  type: 'timeseries',
  title: 'Current connections',
  description: 'The number of current connections to an IIS site.',
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

local attemptedConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_connection_attempts_all_instances_total{job=~"$job", instance=~"$instance", site=~"$site"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{site}}',
    ),
  ],
  type: 'timeseries',
  title: 'Attempted connections',
  description: 'The number of attempted connections to an IIS site.',
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

local accessLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", site=~"$site"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Access logs',
  description: 'Recent access logs from access logs file for an IIS site.',
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

local cacheRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Cache',
  collapsed: false,
};

local fileCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_server_file_cache_hits_total{job=~"$job", instance=~"$instance"}[$__interval:]) / clamp_min(increase(windows_iis_server_file_cache_queries_total{job=~"$job", instance=~"$instance"}[$__interval:]),1) * 100',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'File cache hit ratio',
  description: 'The current file cache hit ratio for an IIS server.',
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
      mode: 'single',
      sort: 'none',
    },
  },
  pluginVersion: '9.5.0-cloud.2.f143d34',
};

local uriCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, job) (increase(windows_iis_server_uri_cache_hits_total{job=~"$job", instance=~"$instance"}[$__interval:]) / clamp_min(increase(windows_iis_server_uri_cache_queries_total{job=~"$job", instance=~"$instance"}[$__interval:]),1)) * 100',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'URI cache hit ratio',
  description: 'The current URI cache hit ratio for an IIS server.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local metadataCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_server_metadata_cache_hits_total{job=~"$job", instance=~"$instance"}[$__interval:]) / clamp_min(increase(windows_iis_server_metadata_cache_queries_total{job=~"$job", instance=~"$instance"}[$__interval:]),1) * 100',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Metadata cache hit ratio',
  description: 'The current metadata cache hit ratio for an IIS server.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local outputCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_server_output_cache_hits_total{job=~"$job", instance=~"$instance"}[$__interval:]) / clamp_min(increase(windows_iis_server_output_cache_queries_total{job=~"$job", instance=~"$instance"}[$__interval:]), 1) * 100',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Output cache hit ratio',
  description: 'The current output cache hit ratio for an IIS site.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

{
  grafanaDashboards+:: {
    'microsoft-iis-overview.json':
      dashboard.new(
        'Microsoft IIS overview',
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
              'label_values(windows_iis_requests_total{}, job)',
              label='Job',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(windows_iis_requests_total{job=~"$job"}, instance)',
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'site',
              promDatasource,
              'label_values(windows_iis_requests_total{job=~"$job",instance=~"$instance"}, site)',
              label='Site',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            requestsPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
            requestErrorsPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
            blockedAsyncIORequestsPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            rejectedAsyncIORequestsPanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
            trafficSentPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
            trafficReceivedPanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
            filesSentPanel { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
            filesReceivedPanel { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
            currentConnectionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 32 } },
            attemptedConnectionsPanel { gridPos: { h: 8, w: 12, x: 12, y: 32 } },
          ],
          if $._config.enableLokiLogs then [
            accessLogsPanel { gridPos: { h: 10, w: 24, x: 0, y: 40 } },
          ] else [],
          [
            cacheRow { gridPos: { h: 1, w: 24, x: 0, y: 50 } },
            fileCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 0, y: 51 } },
            uriCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 12, y: 51 } },
            metadataCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 0, y: 59 } },
            outputCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 12, y: 59 } },
          ],
        ])
      ),

  },
}
