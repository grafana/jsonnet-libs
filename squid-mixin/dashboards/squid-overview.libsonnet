local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'squid-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';
local getMatcher(cfg) = '%(squidSelector)s, instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local clientRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Client',
  collapsed: false,
};

local clientRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_client_http_requests_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Client requests',
  description: 'The request rate of client.',
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

local clientRequestErrorsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_client_http_errors_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Client request errors',
  description: 'The number of client HTTP errors.',
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
      unit: 'errors/s',
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

local clientCacheHitRatioPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '(rate(squid_client_http_hits_total{' + matcher + '}[$__rate_interval]) / clamp_min(rate(squid_client_http_requests_total{' + matcher + '}[$__rate_interval]),1)) * 100',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Client cache hit ratio',
  description: 'The client cache hit ratio.',
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

local clientRequestSentThroughputPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_client_http_kbytes_out_kbytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Client request sent throughput',
  description: 'The throughput of client HTTP data sent.',
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
      unit: 'KBs',
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

local clientHTTPReceivedThroughputPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_client_http_kbytes_in_kbytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Client HTTP received throughput',
  description: 'The throughput of client HTTP data received.',
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
      unit: 'KBs',
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

local clientCacheHitThroughputPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_client_http_hit_kbytes_out_bytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Client cache hit throughput',
  description: 'The throughput of client cache hit.',
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
      unit: 'KBs',
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

local httpRequestServiceTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'squid_HTTP_Requests_All_50{' + matcher + '} ',
      datasource=promDatasource,
      legendFormat='50%',
    ),
    prometheus.target(
      'squid_HTTP_Requests_All_75{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='75%',
    ),
    prometheus.target(
      'squid_HTTP_Requests_All_95{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='95%',
    ),
  ],
  type: 'timeseries',
  title: 'HTTP request service time',
  description: 'HTTP request service time percentiles.',
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

local cacheHitServiceTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'squid_Cache_Hits_50{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='50%',
    ),
    prometheus.target(
      'squid_Cache_Hits_75{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='75%',
    ),
    prometheus.target(
      'squid_Cache_Hits_95{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='95%',
    ),
  ],
  type: 'timeseries',
  title: 'Cache hit service time',
  description: 'Cache hits service time percentiles.',
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

local cacheMissesServiceTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'squid_Cache_Misses_50{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='50%',
    ),
    prometheus.target(
      'squid_Cache_Misses_75{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='75%',
    ),
    prometheus.target(
      'squid_Cache_Misses_95{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='95%',
    ),
  ],
  type: 'timeseries',
  title: 'Cache misses service time',
  description: 'Cache misses service time percentiles.',
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

local serverRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Server',
  collapsed: false,
};

local serverRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_server_ftp_requests_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='FTP',
    ),
    prometheus.target(
      'rate(squid_server_http_requests_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='HTTP',
    ),
    prometheus.target(
      'rate(squid_server_other_requests_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='other',
    ),
  ],
  type: 'timeseries',
  title: 'Server requests',
  description: 'The number of HTTP, FTP, and other server requests.',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
};

local serverRequestErrorsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_server_ftp_errors_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='FTP',
    ),
    prometheus.target(
      'rate(squid_server_http_errors_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='HTTP',
    ),
    prometheus.target(
      'rate(squid_server_other_errors_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='other',
    ),
  ],
  type: 'timeseries',
  title: 'Server request errors',
  description: 'The number of HTTP, FTP, and other server request errors.',
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
      unit: 'errors/s',
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

local serverRequestSentThroughputPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_server_ftp_kbytes_out_kbytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='FTP',
    ),
    prometheus.target(
      'rate(squid_server_http_kbytes_out_kbytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='HTTP',
    ),
    prometheus.target(
      'rate(squid_server_other_kbytes_out_kbytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='other',
    ),
  ],
  type: 'timeseries',
  title: 'Server request sent throughput',
  description: 'The number of HTTP, FTP, and other server sent throughput.',
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
      unit: 'KBs',
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

local serverObjectSwapPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_swap_ins_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - read',
    ),
    prometheus.target(
      'rate(squid_swap_outs_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - saved',
    ),
  ],
  type: 'timeseries',
  title: 'Server object swap',
  description: 'The number of objects read from disk and the number of objects saved to disk.',
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
      unit: 'cps',
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

local dnsLookupServiceTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'squid_DNS_Lookups_50{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='50%',
    ),
    prometheus.target(
      'squid_DNS_Lookups_75{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='75%',
    ),
    prometheus.target(
      'squid_DNS_Lookups_95{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='95%',
    ),
  ],
  type: 'timeseries',
  title: 'DNS lookup service time',
  description: 'DNS lookup service time percentiles',
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
};

local serverReceivedThroughputPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(squid_server_ftp_kbytes_in_kbytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='FTP',
    ),
    prometheus.target(
      'rate(squid_server_http_kbytes_in_kbytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='HTTP',
    ),
    prometheus.target(
      'rate(squid_server_other_kbytes_in_kbytes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='other',
    ),
  ],
  type: 'timeseries',
  title: 'Server received throughput',
  description: 'The number of HTTP, FTP, and other server throughput.',
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
      unit: 'KBs',
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

local cacheLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename="/var/log/squid/cache.log", ' + matcher + '} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Cache logs',
  description: 'The log file that contains the debug and error messages that Squid generates.',
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

local accessLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename="/var/log/squid/access.log", ' + matcher + '} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Access logs',
  description: 'The log file that contains a record of all HTTP requests and responses processed by the Squid proxy server.',
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
    'squid-overview.json':
      dashboard.new(
        'Squid overview',
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
              'label_values(squid_server_http_requests_total{}, job)',
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
              'label_values(squid_server_http_requests_total{%(multiclusterSelector)s}, cluster)' % $._config,
              label='Cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.*',
              hide=if $._config.enableMultiCluster then '' else 'variable',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(squid_server_http_requests_total{%(multiclusterSelector)s}, instance)' % $._config,
              label='Instance',
              refresh=2,
              includeAll=true,
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
            clientRow { gridPos: { h: 1, w: 24, x: 0, y: 0 } },
            clientRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 1 } },
            clientRequestErrorsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 1 } },
            clientCacheHitRatioPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 1 } },
            clientRequestSentThroughputPanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 0, y: 9 } },
            clientHTTPReceivedThroughputPanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 8, y: 9 } },
            clientCacheHitThroughputPanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 16, y: 9 } },
            httpRequestServiceTimePanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 0, y: 16 } },
            cacheHitServiceTimePanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 8, y: 16 } },
            cacheMissesServiceTimePanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 16, y: 16 } },
            serverRow { gridPos: { h: 1, w: 24, x: 0, y: 23 } },
            serverRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 24 } },
            serverRequestErrorsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 24 } },
            serverRequestSentThroughputPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 24 } },
            serverObjectSwapPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 32 } },
            dnsLookupServiceTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 32 } },
            serverReceivedThroughputPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 32 } },
          ],
          if $._config.enableLokiLogs then [
            cacheLogsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 24, x: 0, y: 40 } },
          ] else [],
          [
          ],
          if $._config.enableLokiLogs then [
            accessLogsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 24, x: 0, y: 46 } },
          ] else [],
          [
          ],
        ])
      ),

  },
}
