local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'varnish-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local cacheHitPassPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'varnish_main_cache_hitpass{job=~"$job",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Cache hit pass',
  description: 'Number of cache hits for pass objects.',
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
    graphMode: 'area',
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
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local sessionQueueLengthPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'varnish_main_thread_queue_len{job=~"$job",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Session queue length',
  description: 'Length of session queue waiting for threads.',
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
    graphMode: 'area',
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
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local poolsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'varnish_main_pools{job=~"$job",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Pools',
  description: 'Number of thread pools.',
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
    graphMode: 'area',
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
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local Row = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: '',
  collapsed: false,
};

local backendConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(varnish_main_backend_conn{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Accepted',
    ),
    prometheus.target(
      'increase(varnish_main_backend_recycle{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Recycled',
    ),
    prometheus.target(
      'increase(varnish_main_backend_reuse{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Reused',
    ),
    prometheus.target(
      'increase(varnish_main_backend_busy{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Busy',
    ),
    prometheus.target(
      'increase(varnish_main_backend_unhealthy{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Unhealthy',
    ),
  ],
  type: 'timeseries',
  title: 'Backend connections',
  description: 'Number of recycled, reused, busy, unhealthy, and accepted backend connections by Varnish Cache.',
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

local sessionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(varnish_main_sessions{job=~"$job",instance=~"$instance",type="conn"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Connected',
    ),
    prometheus.target(
      'increase(varnish_main_sessions{job=~"$job",instance=~"$instance",type="queued"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Queued',
    ),
    prometheus.target(
      'increase(varnish_main_sessions{job=~"$job",instance=~"$instance",type="dropped"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Dropped',
    ),
  ],
  type: 'timeseries',
  title: 'Sessions',
  description: 'Number of connected, queued, and dropped sessions.',
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

local requestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(varnish_main_client_req{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Client',
    ),
    prometheus.target(
      'increase(varnish_main_backend_req{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Backend',
    ),
  ],
  type: 'timeseries',
  title: 'Requests',
  description: 'Number of client and backend requests received.',
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

local cacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(varnish_main_cache_hit{job=~"$job",instance=~"$instance"}[$__interval:]) / clamp_min((increase(varnish_main_cache_hit{job=~"$job",instance=~"$instance"}[$__interval:]) + increase(varnish_main_cache_miss{job=~"$job",instance=~"$instance"}[$__interval:])),1) * 100',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Cache hit ratio',
  description: 'Ratio of cache hits to cache misses.',
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

local threadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(varnish_main_threads_failed{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Failed',
    ),
    prometheus.target(
      'increase(varnish_main_threads_created{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Created',
    ),
    prometheus.target(
      'increase(varnish_main_threads_limited{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Limited',
    ),
    prometheus.target(
      'varnish_main_threads{job=~"$job",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - Total',
    ),
  ],
  type: 'timeseries',
  title: 'Threads',
  description: 'Number of failed, created, limited, and current threads.',
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

local cachePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(varnish_main_n_expired{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Expired',
    ),
    prometheus.target(
      'increase(varnish_main_n_lru_nuked{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Nuked',
    ),
    prometheus.target(
      'varnish_sma_g_bytes{job=~"$job",instance=~"$instance",type="s0"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - Used memory',
    ),
  ],
  type: 'timeseries',
  title: 'Cache',
  description: 'Number of expired, LRU nuked objects, and current cache storage used in bytes.',
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
    },
    overrides: [
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'C',
        },
        properties: [
          {
            id: 'custom.axisPlacement',
            value: 'right',
          },
          {
            id: 'unit',
            value: 'decbytes',
          },
        ],
      },
    ],
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

local networkPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(varnish_main_s_resp_hdrbytes{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Client header',
    ),
    prometheus.target(
      'increase(varnish_main_s_resp_bodybytes{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Client body',
    ),
    prometheus.target(
      'increase(varnish_backend_beresp_hdrbytes{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Backend header',
    ),
    prometheus.target(
      'increase(varnish_backend_beresp_bodybytes{job=~"$job",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Backend body',
    ),
  ],
  type: 'timeseries',
  title: 'Network',
  description: 'Response bytes of header and body for client and backends.',
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

local logsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Logs',
  collapsed: false,
};

local clientLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename="/var/log/varnish/varnishncsa.log", job=~"$job", instance=~"$instance"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Client logs',
  description: 'Client logs for Varnish Cache.',
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

local backendLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename="/var/log/varnish/varnishncsa-backend.log", job=~"$job", instance=~"$instance"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Backend logs',
  description: 'Backend logs for Varnish Cache.',
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
    'varnish-overview.json':
      dashboard.new(
        'Varnish overview',
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
              'label_values(varnish_main_sessions,job)',
              label='Job',
              refresh=2,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(varnish_main_sessions,instance)',
              label='Instance',
              refresh=2,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            cacheHitPassPanel { gridPos: { h: 8, w: 3, x: 0, y: 0 } },
            sessionQueueLengthPanel { gridPos: { h: 8, w: 3, x: 3, y: 0 } },
            poolsPanel { gridPos: { h: 8, w: 3, x: 6, y: 0 } },
            Row { gridPos: { h: 1, w: 24, x: 0, y: 8 } },
            backendConnectionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 9 } },
            sessionsPanel { gridPos: { h: 8, w: 12, x: 12, y: 9 } },
            requestsPanel { gridPos: { h: 8, w: 12, x: 0, y: 17 } },
            cacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 12, y: 17 } },
            threadsPanel { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
            cachePanel { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
            networkPanel { gridPos: { h: 9, w: 24, x: 0, y: 33 } },
            logsRow { gridPos: { h: 1, w: 24, x: 0, y: 42 } },
          ],
          if $._config.enableLokiLogs then [
            clientLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 43 } },
          ] else [],
          [
          ],
          if $._config.enableLokiLogs then [
            backendLogsPanel { gridPos: { h: 7, w: 24, x: 0, y: 51 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
