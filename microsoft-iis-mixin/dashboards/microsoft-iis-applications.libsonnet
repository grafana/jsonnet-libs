local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'microsoft-iis-applications';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local requestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(app, job, instance) (rate(windows_iis_worker_requests_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
    ),
  ],
  type: 'timeseries',
  title: 'Requests',
  description: 'The HTTP request rate for an IIS application.',
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

local requestErrorsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(app, instance, job, status_code) (rate(windows_iis_worker_request_errors_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}} - {{status_code}}',
    ),
  ],
  type: 'timeseries',
  title: 'Request errors',
  description: 'Requests that have resulted in errors for an IIS application.',
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

local websocketConnectionAttemptsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(app, instance, job) (increase(windows_iis_worker_websocket_connection_attempts_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Websocket connection attempts',
  description: 'The number of attempted websocket connections for an IIS application.',
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

local websocketConnectionSuccessRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(app, job, instance) (increase(windows_iis_worker_websocket_connection_accepted_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_websocket_connection_attempts_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]),1)) * 100',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Websocket connection success rate',
  description: 'The success rate of websocket connection attempts for an IIS application.',
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

local currentWorkerThreadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(app, instance, job, state) (windows_iis_worker_threads{job=~"$job", instance=~"$instance", app=~"$application"})',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}} - {{state}}',
    ),
  ],
  type: 'timeseries',
  title: 'Current worker threads',
  description: 'The current number of worker threads processing requests for an IIS application.',
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

local threadPoolUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, instance, app) (windows_iis_worker_threads{job=~"$job", instance=~"$instance", app=~"$application"})/ clamp_min(sum by (job, instance, app) (windows_iis_worker_max_threads{job=~"$job", instance=~"$instance", app=~"$application"}),1) * 100',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
    ),
  ],
  type: 'timeseries',
  title: 'Thread pool utilization',
  description: 'The current application thread pool utilization for an IIS application.',
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

local workerProcessesRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Worker processes',
  collapsed: false,
};

local currentWorkerProcessesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(app, job, instance) (windows_iis_current_worker_processes{job=~"$job", instance=~"$instance", app=~"$application"})',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
    ),
  ],
  type: 'timeseries',
  title: 'Current worker processes',
  description: 'The current number of worker processes processing requests for an IIS application.',
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

local workerProcessFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_total_worker_process_failures{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Worker process failures',
  description: 'The number of worker process failures for an IIS application.',
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

local workerProcessStartupFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_total_worker_process_startup_failures{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Worker process startup failures',
  description: 'The number of worker process startup failures for an IIS application.',
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

local workerProcessShutdownFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_total_worker_process_shutdown_failures{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Worker process shutdown failures',
  description: 'The number of worker process shutdown failures for an IIS application.',
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

local workerProcessPingFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(windows_iis_total_worker_process_ping_failures{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Worker process ping failures',
  description: 'The number of worker process ping failures for an IIS application.',
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
      'sum by(job, instance, app) (increase(windows_iis_worker_file_cache_hits_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_file_cache_queries_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]),1)) * 100',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'File cache hit ratio',
  description: 'The current file cache hit ratio for an IIS application.',
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

local uriCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, job, app) (increase(windows_iis_worker_uri_cache_hits_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_uri_cache_queries_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]),1)) * 100',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'URI cache hit ratio',
  description: 'The current URI cache hit ratio for an IIS application.',
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

local metadataCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, instance, app)(increase(windows_iis_worker_metadata_cache_hits_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_metadata_cache_queries_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]),1)) * 100',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Metadata cache hit ratio',
  description: 'The current metadata cache hit ratio for an IIS site.',
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

local outputCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, instance, app) (increase(windows_iis_worker_output_cache_hits_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_output_queries_total{job=~"$job", instance=~"$instance", app=~"$application"}[$__interval:]),1))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{app}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Output cache hit ratio',
  description: 'The current output cache hit ratio for an IIS application.',
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
    'microsoft-iis-applications.json':
      dashboard.new(
        'Microsoft IIS applications',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Microsoft IIS dashboards',
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
            'label_values(windows_iis_requests_total{},job)',
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
            'label_values(windows_iis_requests_total{job=~"$job"},instance)',
            label='Instance',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'application',
            promDatasource,
            'label_values(windows_iis_current_application_pool_state{job=~"$job", instance=~"$instance"},app)',
            label='Application',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          requestsPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          requestErrorsPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          websocketConnectionAttemptsPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          websocketConnectionSuccessRatePanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          currentWorkerThreadsPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          threadPoolUtilizationPanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          workerProcessesRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
          currentWorkerProcessesPanel { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
          workerProcessFailuresPanel { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
          workerProcessStartupFailuresPanel { gridPos: { h: 8, w: 8, x: 0, y: 33 } },
          workerProcessShutdownFailuresPanel { gridPos: { h: 8, w: 8, x: 8, y: 33 } },
          workerProcessPingFailuresPanel { gridPos: { h: 8, w: 8, x: 16, y: 33 } },
          cacheRow { gridPos: { h: 1, w: 24, x: 0, y: 41 } },
          fileCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 0, y: 42 } },
          uriCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 12, y: 42 } },
          metadataCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 0, y: 50 } },
          outputCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 12, y: 50 } },
        ]
      ),

  },
}
