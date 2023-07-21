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

local cacheHitRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg((rate(varnish_main_cache_hit{job=~"$job",instance=~"$instance"}[$__rate_interval]) / clamp_min(rate(varnish_main_cache_hit{job=~"$job",instance=~"$instance"}[$__rate_interval]) + rate(varnish_main_cache_miss{job=~"$job",instance=~"$instance"}[$__rate_interval]), 1))) * 100\n',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'gauge',
  title: 'Cache hit rate',
  description: 'Rate of cache hits to misses.',
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
          {
            color: 'red',
            value: 0,
          },
          {
            color: '#EAB839',
            value: 50,
          },
          {
            color: 'green',
            value: 80,
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transparent: true,
};

local frontendRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(irate(varnish_main_client_req{job=~"$job", instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{nstance}}',
    ),
  ],
  type: 'stat',
  title: 'Frontend requests',
  description: 'The rate of requests sent to the Varnish Cache frontend.',
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
      unit: 'reqps',
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transparent: true,
};

local backendRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(irate(varnish_backend_req{job=~"$job", instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Backend requests',
  description: 'The rate of requests sent to the Varnish Cache backends.',
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
      unit: 'reqps',
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transparent: true,
};

local sessionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(irate(varnish_main_sessions_total{job=~"$job", instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Sessions',
  description: 'The rate of total sessions created in the Varnish Cache instance.',
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
      unit: '/ sec',
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transparent: true,
};

local cacheHitsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(irate(varnish_main_cache_hit{job=~"$job",instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Cache hits',
  description: 'The rate of cache hits.',
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
      unit: '/ sec',
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transparent: true,
};

local cacheHitPassPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(irate(varnish_main_cache_hitpass{job=~"$job",instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Cache hit pass',
  description: 'Rate of cache hits for pass objects (fulfilled requests that are not cached).',
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
      unit: '/ sec',
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transparent: true,
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transparent: true,
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transparent: true,
};

local backendConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'irate(varnish_main_backend_conn{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Accepted',
    ),
    prometheus.target(
      'irate(varnish_main_backend_recycle{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Recycled',
    ),
    prometheus.target(
      'irate(varnish_main_backend_reuse{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Reused',
    ),
    prometheus.target(
      'irate(varnish_main_backend_busy{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Busy',
    ),
    prometheus.target(
      'irate(varnish_main_backend_unhealthy{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Unhealthy',
    ),
  ],
  type: 'timeseries',
  title: 'Backend connections',
  description: 'Rate of recycled, reused, busy, unhealthy, and accepted backend connections by Varnish Cache.',
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
        fillOpacity: 20,
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
        pointSize: 1,
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
      unit: 'conn/s',
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

local sessionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'irate(varnish_main_sessions{job=~"$job",instance=~"$instance",type="conn"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Connected',
    ),
    prometheus.target(
      'irate(varnish_main_sessions{job=~"$job",instance=~"$instance",type="queued"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Queued',
    ),
    prometheus.target(
      'irate(varnish_main_sessions{job=~"$job",instance=~"$instance",type="dropped"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Dropped',
    ),
  ],
  type: 'timeseries',
  title: 'Sessions',
  description: 'Rate of new connected, queued, and dropped sessions.',
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
        fillOpacity: 20,
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
      unit: 'sess/s',
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

local requestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'irate(varnish_main_client_req{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Frontend',
    ),
    prometheus.target(
      'irate(varnish_main_backend_req{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Backend',
    ),
  ],
  type: 'timeseries',
  title: 'Requests',
  description: 'Rate of frontend and backend requests received.',
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
        fillOpacity: 20,
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local cacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (instance, job) ((rate(varnish_main_cache_hit{job=~"$job",instance=~"$instance"}[$__rate_interval]) / clamp_min(rate(varnish_main_cache_hit{job=~"$job",instance=~"$instance"}[$__rate_interval]) + rate(varnish_main_cache_miss{job=~"$job",instance=~"$instance"}[$__rate_interval]), 1))) * 100',
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
        axisSoftMax: 100,
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
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
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'area',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'percentage',
        steps: [
          {
            color: 'transparent',
            value: null,
          },
          {
            color: 'red',
            value: 0,
          },
          {
            color: 'yellow',
            value: 50,
          },
          {
            color: 'green',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
};

local memoryUsedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'varnish_sma_g_bytes{job=~"$job",instance=~"$instance",type="s0"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Memory used',
  description: 'Bytes allocated from Varnish Cache storage.',
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
        fillOpacity: 20,
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
      unit: 'decbytes',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local cacheEventsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'irate(varnish_main_n_expired{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Expired',
    ),
    prometheus.target(
      'irate(varnish_main_n_lru_nuked{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Nuked',
    ),
  ],
  type: 'timeseries',
  title: 'Cache events',
  description: 'Rate of expired and LRU (least recently used) nuked objects.',
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
        fillOpacity: 20,
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
      sort: 'none',
    },
  },
};

local networkPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'irate(varnish_main_s_resp_hdrbytes{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} -  Frontend header',
    ),
    prometheus.target(
      'irate(varnish_main_s_resp_bodybytes{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - Frontend body',
    ),
    prometheus.target(
      'irate(varnish_backend_beresp_hdrbytes{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} -  {{backend}} - Backend header',
    ),
    prometheus.target(
      'irate(varnish_backend_beresp_bodybytes{job=~"$job",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} -  {{backend}} - Backend body',
    ),
  ],
  type: 'timeseries',
  title: 'Network',
  description: 'Rate for the response bytes of header and body for frontend and backends.',
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
        fillOpacity: 20,
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
      unit: 'decbytes',
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
    overrides: [
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'A',
        },
        properties: [
          {
            id: 'custom.fillOpacity',
            value: 20,
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'B',
        },
        properties: [
          {
            id: 'custom.fillOpacity',
            value: 20,
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'C',
        },
        properties: [
          {
            id: 'custom.fillOpacity',
            value: 20,
          },
        ],
      },
    ],
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

local logsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Logs',
  collapsed: false,
};

local frontendLogsPanel = {
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
  title: 'Frontend logs',
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
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(varnish_main_sessions,instance)',
              label='Instance',
              refresh=2,
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
            cacheHitRatePanel { gridPos: { h: 4, w: 3, x: 0, y: 0 } },
            frontendRequestsPanel { gridPos: { h: 4, w: 3, x: 3, y: 0 } },
            backendRequestsPanel { gridPos: { h: 4, w: 3, x: 6, y: 0 } },
            sessionsPanel { gridPos: { h: 4, w: 3, x: 9, y: 0 } },
            cacheHitsPanel { gridPos: { h: 4, w: 3, x: 12, y: 0 } },
            cacheHitPassPanel { gridPos: { h: 4, w: 3, x: 15, y: 0 } },
            sessionQueueLengthPanel { gridPos: { h: 4, w: 3, x: 18, y: 0 } },
            poolsPanel { gridPos: { h: 4, w: 3, x: 21, y: 0 } },
            backendConnectionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 4 } },
            sessionsPanel { gridPos: { h: 8, w: 12, x: 12, y: 4 } },
            requestsPanel { gridPos: { h: 8, w: 12, x: 0, y: 12 } },
            cacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 12, y: 12 } },
            memoryUsedPanel { gridPos: { h: 7, w: 12, x: 0, y: 20 } },
            cacheEventsPanel { gridPos: { h: 7, w: 12, x: 12, y: 20 } },
            networkPanel { gridPos: { h: 10, w: 12, x: 0, y: 27 } },
            threadsPanel { gridPos: { h: 10, w: 12, x: 12, y: 27 } },
            logsRow { gridPos: { h: 1, w: 24, x: 0, y: 37 } },
          ],
          if $._config.enableLokiLogs then [
            frontendLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 38 } },
          ] else [],
          [
          ],
          if $._config.enableLokiLogs then [
            backendLogsPanel { gridPos: { h: 7, w: 24, x: 0, y: 46 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
