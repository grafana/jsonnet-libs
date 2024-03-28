local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'couchbase-node-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local memoryUtilizationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sys_mem_actual_used{' + matcher + '} / (clamp_min(sys_mem_actual_free{' + matcher + '} + sys_mem_actual_used{' + matcher + '}, 1))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Memory utilization',
  description: 'Percentage of memory allocated to Couchbase on this node actually in use.',
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

local cpuUtilizationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, job, instance) (sys_cpu_utilization_rate{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'CPU utilization',
  description: 'CPU utilization percentage across all available cores on this Couchbase node.',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local totalMemoryUsedByServicePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'index_memory_used_total{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - index',
    ),
    prometheus.target(
      'cbas_direct_memory_used_bytes{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - analytics',
    ),
    prometheus.target(
      'sum by(couchbase_cluster, instance, job) (kv_mem_used_bytes{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - data',
    ),
  ],
  type: 'timeseries',
  title: 'Total memory used by service',
  description: 'Memory used by the index, analytics, and data services for a node.',
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
      sort: 'desc',
    },
  },
};

local backupSizePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, instance, job) (backup_data_size{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'bargauge',
  title: 'Backup size',
  description: 'Size of locally replicated cluster data for a Couchbase node.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'green',
        mode: 'fixed',
      },
      mappings: [],
      min: 1,
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
    displayMode: 'basic',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'vertical',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
    valueMode: 'color',
  },
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local currentConnectionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'kv_curr_connections{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Current connections',
  description: 'Number of active connections to a node.',
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
        lineInterpolation: 'stepBefore',
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

local httpResponseCodesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, instance, couchbase_cluster, code) (rate(cm_http_requests_total{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - {{code}}',
    ),
  ],
  type: 'timeseries',
  title: 'HTTP response codes',
  description: 'Rate of HTTP response codes handled by the cluster manager.',
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
      min: 0.001,
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
      sort: 'desc',
    },
  },
};

local httpRequestMethodsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, instance, couchbase_cluster, method) (rate(cm_http_requests_total{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - {{method}}',
    ),
  ],
  type: 'timeseries',
  title: 'HTTP request methods',
  description: 'Rate of HTTP request methods handled by the cluster manager.',
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
      sort: 'desc',
    },
  },
};

local queryServiceRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(n1ql_requests{' + matcher + '}[$__rate_interval]) + rate(n1ql_invalid_requests{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - total',
    ),
    prometheus.target(
      'rate(n1ql_errors{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - error',
    ),
    prometheus.target(
      'rate(n1ql_invalid_requests{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - invalid',
    ),
  ],
  type: 'timeseries',
  title: 'Query service requests',
  description: 'Rate of N1QL requests processed by the query service for a node.',
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
      sort: 'desc',
    },
  },
};

local queryServiceRequestProcessingTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(n1ql_requests{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >0ms',
    ),
    prometheus.target(
      'rate(n1ql_requests_250ms{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >250ms',
    ),
    prometheus.target(
      'rate(n1ql_requests_500ms{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >500ms',
    ),
    prometheus.target(
      'rate(n1ql_requests_1000ms{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >1000ms',
    ),
    prometheus.target(
      'rate(n1ql_requests_5000ms{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >5000ms',
    ),
  ],
  type: 'timeseries',
  title: 'Query service request processing time',
  description: 'Rate of queries grouped by processing time.',
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
      sort: 'desc',
    },
  },
};

local indexServiceRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, instance, job) (rate(index_num_requests{couchbase_cluster=~"$couchbase_cluster", job=~"$job", instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Index service requests',
  description: 'Rate of index service requests served.',
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
      sort: 'desc',
    },
  },
};

local indexCacheHitRatioPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, job, instance) (increase(index_cache_hits{' + matcher + '}[$__rate_interval])) / (clamp_min(sum by(couchbase_cluster, job, instance) (increase(index_cache_hits{' + matcher + '}[$__rate_interval])), 1) + sum by(couchbase_cluster, job, instance) (increase(index_cache_misses{' + matcher + '}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Index cache hit ratio',
  description: 'Ratio at which cache scans result in a hit rather than a miss.',
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
        spanNulls: true,
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

local averageScanLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, index, instance, job) (index_avg_scan_latency{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - {{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Average scan latency',
  description: 'Average time to serve a scan request per index.',
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
      unit: 'ns',
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

local errorLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + matcher + '} |~ `error|couchbase.log.error`',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Error logs',
  description: 'Recent error logs from a node.',
  options: {
    dedupStrategy: 'none',
    enableLogDetails: true,
    prettifyLogMessage: true,
    showCommonLabels: false,
    showLabels: false,
    showTime: false,
    sortOrder: 'Descending',
    wrapLogMessage: false,
  },
};

local couchbaseLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + matcher + '} |~ `couchdb`',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Couchbase logs',
  description: 'Recent couchbase logs from a node.',
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

local getMatcher(cfg) = '%(couchbaseSelector)s, couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"' % cfg;

{
  grafanaDashboards+:: {
    'couchbase-node-overview.json':
      dashboard.new(
        'Couchbase node overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Couchbase dashboards',
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
              'label_values(sys_mem_actual_used,job)',
              label='Job',
              refresh=2,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'cluster',
              promDatasource,
              'label_values(sys_mem_actual_used{%(multiclusterSelector)s}, cluster)' % $._config,
              label='Cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.*',
              hide=if $._config.enableMultiCluster then '' else 'variable',
              sort=0
            ),
            template.new(
              'couchbase_cluster',
              promDatasource,
              'label_values(sys_mem_actual_used{%(couchbaseSelector)s},couchbase_cluster)' % $._config,
              label='Couchbase cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(sys_mem_actual_used{%(couchbaseSelector)s},instance)' % $._config,
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
            memoryUtilizationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
            cpuUtilizationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
            totalMemoryUsedByServicePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 8 } },
            backupSizePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 8 } },
            currentConnectionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 8 } },
            httpResponseCodesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
            httpRequestMethodsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
            queryServiceRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
            queryServiceRequestProcessingTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
            indexServiceRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 32 } },
            indexCacheHitRatioPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 32 } },
            averageScanLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 32 } },
          ],
          if $._config.enableLokiLogs then [
            errorLogsPanel(getMatcher($._config)) { gridPos: { h: 7, w: 24, x: 0, y: 40 } },
          ] else [],
          [
          ],
          if $._config.enableLokiLogs then [
            couchbaseLogsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 47 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
