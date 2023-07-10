local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-couchbase-node-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};


local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local memoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sys_mem_actual_used{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"} / (clamp_min(sys_mem_actual_free{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"} + sys_mem_actual_used{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}, 1))',
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

local cpuUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, job, instance) (sys_cpu_utilization_rate{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"})',
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

local totalMemoryUsedByServicePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'index_memory_used_total{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - index',
    ),
    prometheus.target(
      'cbas_direct_memory_used_bytes{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - analytics',
    ),
    prometheus.target(
      'sum by(couchbase_cluster, instance, job) (kv_mem_used_bytes{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"})',
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

local backupSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, instance, job) (backup_data_size{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"})',
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

local currentConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'kv_curr_connections{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}',
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

local httpResponseCodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, instance, couchbase_cluster, code) (rate(cm_http_requests_total{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval]))',
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

local httpRequestMethodsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, instance, couchbase_cluster, method) (rate(cm_http_requests_total{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval]))',
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

local queryServiceRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(n1ql_requests{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - total',
    ),
    prometheus.target(
      'rate(n1ql_errors{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - error',
    ),
    prometheus.target(
      'rate(n1ql_invalid_requests{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval])',
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

local queryServiceRequestProcessingTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(n1ql_requests{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >0ms',
    ),
    prometheus.target(
      'rate(n1ql_requests_250ms{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >250ms',
    ),
    prometheus.target(
      'rate(n1ql_requests_500ms{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >500ms',
    ),
    prometheus.target(
      'rate(n1ql_requests_1000ms{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}} - >1000ms',
    ),
    prometheus.target(
      'rate(n1ql_requests_5000ms{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}[$__rate_interval])',
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

local indexServiceRequestsPanel = {
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

local indexCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, job, instance) (index_cache_hits{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}) / (clamp_min(sum by(couchbase_cluster, job, instance) (index_cache_hits{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}), 1) + sum by(couchbase_cluster, job, instance) (index_cache_misses{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}))',
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

local averageScanLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, index, instance, job) (index_avg_scan_latency{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"})',
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

local errorLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename=~"/opt/couchbase/var/lib/couchbase/logs/error.log", job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance"}',
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

local couchbaseLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", filename=~"/opt/couchbase/var/lib/couchbase/logs/couchdb\.log"} |= ``',
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


{
  grafanaDashboards+:: {
    'apache-couchbase-node-overview.json':
      dashboard.new(
        'Apache Couchbase node overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache Couchbase dashboards',
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
              'couchbase_cluster',
              promDatasource,
              'label_values(sys_mem_actual_used,couchbase_cluster)',
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
              'label_values(sys_mem_actual_used,instance)',
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
            memoryUtilizationPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
            cpuUtilizationPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
            totalMemoryUsedByServicePanel { gridPos: { h: 8, w: 8, x: 0, y: 8 } },
            backupSizePanel { gridPos: { h: 8, w: 8, x: 8, y: 8 } },
            currentConnectionsPanel { gridPos: { h: 8, w: 8, x: 16, y: 8 } },
            httpResponseCodesPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
            httpRequestMethodsPanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
            queryServiceRequestsPanel { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
            queryServiceRequestProcessingTimePanel { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
            indexServiceRequestsPanel { gridPos: { h: 8, w: 8, x: 0, y: 32 } },
            indexCacheHitRatioPanel { gridPos: { h: 8, w: 8, x: 8, y: 32 } },
            averageScanLatencyPanel { gridPos: { h: 8, w: 8, x: 16, y: 32 } },
          ],
          if $._config.enableLokiLogs then [
            errorLogsPanel { gridPos: { h: 7, w: 24, x: 0, y: 40 } },
          ] else [],
          [
          ],
          if $._config.enableLokiLogs then [
            couchbaseLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 47 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
