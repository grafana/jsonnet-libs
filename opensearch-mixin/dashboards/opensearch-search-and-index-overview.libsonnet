local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'search-and-index-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local requestPerformanceRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Request performance',
  collapsed: false,
};

local requestRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, cluster, index) (opensearch_index_search_query_current_number{cluster=~"$opensearch_cluster", job=~"$job", index=~"$opensearch_index", context=~"total"})',
      datasource=promDatasource,
      legendFormat='{{index}} - query',
    ),
    prometheus.target(
      'sum by (job, cluster, index) (opensearch_index_search_fetch_current_number{cluster=~"$opensearch_cluster", job=~"$job", index=~"$opensearch_index", context=~"total"})',
      datasource=promDatasource,
      legendFormat='{{index}} - fetch',
    ),
    prometheus.target(
      'sum by (job, cluster, index) (opensearch_index_search_scroll_current_number{cluster=~"$opensearch_cluster", job=~"$job", index=~"$opensearch_index", context=~"total"})',
      datasource=promDatasource,
      legendFormat='{{index}} - scroll',
    ),
  ],
  type: 'timeseries',
  title: 'Request rate',
  description: 'Rate of fetch, scroll, and query requests by selected index.',
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

local requestLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(index, job, cluster) (increase(opensearch_index_search_query_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_search_query_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]), 1))',
      datasource=promDatasource,
      legendFormat='{{index}} - query',
      interval='1m',
    ),
    prometheus.target(
      'sum by(index, job, cluster) (increase(opensearch_index_search_fetch_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_search_fetch_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]), 1))',
      datasource=promDatasource,
      legendFormat='{{index}} - fetch',
      interval='1m',
    ),
    prometheus.target(
      'sum by(index, job, cluster) (increase(opensearch_index_search_scroll_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_search_scroll_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]), 1))',
      datasource=promDatasource,
      legendFormat='{{index}} - scroll',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Request latency',
  description: 'Latency of fetch, scroll, and query requests by selected index.',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local cacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(index, job, cluster) (100 * (opensearch_index_requestcache_hit_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}) / clamp_min(opensearch_index_requestcache_hit_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"} + opensearch_index_requestcache_miss_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}, 1))',
      datasource=promDatasource,
      legendFormat='{{index}} - request',
    ),
    prometheus.target(
      'sum by(index, job, cluster) (100 * (opensearch_index_querycache_hit_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}) / clamp_min(opensearch_index_querycache_hit_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"} + opensearch_index_querycache_miss_number{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}, 1))',
      datasource=promDatasource,
      legendFormat='{{index}} - query',
    ),
  ],
  type: 'timeseries',
  title: 'Cache hit ratio',
  description: 'Ratio of query cache and request cache hits and misses.',
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
      sort: 'none',
    },
  },
};

local evictionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(cluster, job, index) (increase(opensearch_index_querycache_evictions_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{index}} - query cache',
      interval='1m',
    ),
    prometheus.target(
      'sum by(cluster, job, index) (increase(opensearch_index_requestcache_evictions_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{index}} - request cache',
      interval='1m',
    ),
    prometheus.target(
      'sum by(cluster, job, index) (increase(opensearch_index_fielddata_evictions_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{index}} - field data',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Evictions',
  description: 'Total evictions count by cache type for the selected index.',
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
      unit: 'evictions',
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

local indexPerformanceRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Index performance',
  collapsed: false,
};

local indexRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_indexing_index_current_number{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Index rate',
  description: 'Rate of indexed documents for the selected index.',
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
      unit: 'documents/s',
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

local indexLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (increase(opensearch_index_indexing_index_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context=~"total"}[$__interval:]) / clamp_min(increase(opensearch_index_indexing_index_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context=~"total"}[$__interval:]),1))',
      datasource=promDatasource,
      legendFormat='{{index}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Index latency',
  description: 'Document indexing latency for the selected index.',
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

local indexFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (increase(opensearch_index_indexing_index_failed_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{index}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Index failures',
  description: 'Number of indexing failures for the selected index.',
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
      unit: 'failures',
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

local flushLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (increase(opensearch_index_flush_total_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_flush_total_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]),1))',
      datasource=promDatasource,
      legendFormat='{{index}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Flush latency',
  description: 'Index flush latency for the selected index.',
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

local mergeTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (increase(opensearch_index_merges_total_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{index}} - total',
      interval='1m',
    ),
    prometheus.target(
      'sum by(job, cluster, index) (increase(opensearch_index_merges_total_stopped_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{index}} - stopped',
      interval='1m',
    ),
    prometheus.target(
      'sum by(job, cluster, index) (increase(opensearch_index_merges_total_throttled_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{index}} - throttled',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Merge time',
  description: 'Index merge time for the selected index.',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local refreshLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (increase(opensearch_index_refresh_total_time_seconds{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_refresh_total_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]),1))',
      datasource=promDatasource,
      legendFormat='{{index}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Refresh latency',
  description: 'Index refresh latency for the selected index.',
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

local translogOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_translog_operations_number{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Translog operations',
  description: 'Current number of translog operations for the selected index.',
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
      unit: 'operations',
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

local docsDeletedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, cluster, index) (opensearch_index_indexing_delete_current_number{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Docs deleted',
  description: 'Rate of documents deleted for the selected index.',
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
      unit: 'documents/s',
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

local indexCapacityRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Index capacity',
  collapsed: true,
};

local documentsIndexedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, cluster, index) (opensearch_index_indexing_index_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Documents indexed',
  description: 'Number of indexed documents for the selected index.',
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
      unit: 'documents',
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

local segmentCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_segments_number{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Segment count',
  description: 'Current number of segments for the selected index.',
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
      unit: 'segments',
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

local mergeCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (increase(opensearch_index_merges_total_docs_count{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{index}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Merge count',
  description: 'Number of merge operations for the selected index.',
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
      unit: 'merges',
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

local cacheSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_querycache_memory_size_bytes{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}} - query',
    ),
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_requestcache_memory_size_bytes{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}} - request',
    ),
  ],
  type: 'timeseries',
  title: 'Cache size',
  description: 'Size of query cache and request cache.',
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
      unit: 'bytes',
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

local storeSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_store_size_bytes{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Store size',
  description: 'Size of the store in bytes for the selected index.',
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
      unit: 'bytes',
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

local segmentSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_segments_memory_bytes{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Segment size',
  description: 'Memory used by segments for the selected index.',
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
      unit: 'bytes',
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

local mergeSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_merges_current_size_bytes{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index", context="total"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Merge size',
  description: 'Size of merge operations in bytes for the selected index.',
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
      unit: 'bytes',
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

local shardCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, index) (opensearch_index_shards_number{job=~"$job", cluster=~"$opensearch_cluster", index=~"$opensearch_index"})',
      datasource=promDatasource,
      legendFormat='{{index}}',
    ),
  ],
  type: 'timeseries',
  title: 'Shard count',
  description: 'The number of index shards for the selected index.',
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
      unit: 'shards',
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
    'search-and-index-overview.json':
      dashboard.new(
        'OpenSearch search and index overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other OpenSearch dashboards',
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
            'label_values(opensearch_index_search_fetch_count, job)',
            label='Job',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=1
          ),
          template.new(
            'opensearch_cluster',
            promDatasource,
            'label_values(opensearch_index_search_fetch_count{job=~"$job"}, cluster)',
            label='OpenSearch Cluster',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=1
          ),
          template.new(
            'opensearch_index',
            promDatasource,
            'label_values(opensearch_index_search_fetch_count{job=~"$job", cluster=~"$opensearch_cluster"}, index)',
            label='Index',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=1
          ),
        ]
      )
      .addPanels(
        [
          requestPerformanceRow { gridPos: { h: 1, w: 24, x: 0, y: 0 } },
          requestRatePanel { gridPos: { h: 8, w: 6, x: 0, y: 1 } },
          requestLatencyPanel { gridPos: { h: 8, w: 6, x: 6, y: 1 } },
          cacheHitRatioPanel { gridPos: { h: 8, w: 6, x: 12, y: 1 } },
          evictionsPanel { gridPos: { h: 8, w: 6, x: 18, y: 1 } },
          indexPerformanceRow { gridPos: { h: 1, w: 24, x: 0, y: 9 } },
          indexRatePanel { gridPos: { h: 8, w: 6, x: 0, y: 10 } },
          indexLatencyPanel { gridPos: { h: 8, w: 6, x: 6, y: 10 } },
          indexFailuresPanel { gridPos: { h: 8, w: 6, x: 12, y: 10 } },
          flushLatencyPanel { gridPos: { h: 8, w: 6, x: 18, y: 10 } },
          mergeTimePanel { gridPos: { h: 8, w: 6, x: 0, y: 18 } },
          refreshLatencyPanel { gridPos: { h: 8, w: 6, x: 6, y: 18 } },
          translogOperationsPanel { gridPos: { h: 8, w: 6, x: 12, y: 18 } },
          docsDeletedPanel { gridPos: { h: 8, w: 6, x: 18, y: 18 } },
          indexCapacityRow { gridPos: { h: 1, w: 24, x: 0, y: 26 } },
          documentsIndexedPanel { gridPos: { h: 8, w: 6, x: 0, y: 27 } },
          segmentCountPanel { gridPos: { h: 8, w: 6, x: 6, y: 27 } },
          mergeCountPanel { gridPos: { h: 8, w: 6, x: 12, y: 27 } },
          cacheSizePanel { gridPos: { h: 8, w: 6, x: 18, y: 27 } },
          storeSizePanel { gridPos: { h: 8, w: 6, x: 0, y: 35 } },
          segmentSizePanel { gridPos: { h: 8, w: 6, x: 6, y: 35 } },
          mergeSizePanel { gridPos: { h: 8, w: 6, x: 12, y: 35 } },
          shardCountPanel { gridPos: { h: 8, w: 6, x: 18, y: 35 } },
        ]
      ),
  },
}
