local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-solr-query-performance';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local updateHandlersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url, collection, core) (increase(solr_metrics_core_update_handler_adds_total{' + matcher + '}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Update handlers / $__interval',
  description: 'Counts the increase in document additions over the specified interval.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local coreSearchAndRetrievalQueryLoadPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_5minRate{' + matcher + ', searchHandler=~"/select|/query|/get",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Core search and retrieval query load',
  description: 'Measures the average rate of queries per second over a 5-minute period for core search and retrieval operations.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local coreSearchAndRetrieval95pQueryLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p95_ms{' + matcher + ', searchHandler=~"/select|/query|/get",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Core search and retrieval 95p query latency',
  description: 'Represents the 95th percentile latency for core search and retrieval queries.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      sort: 'desc',
    },
  },
};
local coreSearchAndRetrieval99pQueryLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p99_ms{' + matcher + ', searchHandler=~"/select|/query|/get",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Core search and retrieval 99p query latency',
  description: 'Represents the 99th percentile latency for core search and retrieval queries, measured in milliseconds.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      sort: 'desc',
    },
  },
};

local coreSearchAndRetrievalLocalQueryLoadPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_5minRate{' + matcher + ', searchHandler=~"/select|/query|/get",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Core search and retrieval local query load',
  description: 'Indicates the average rate of local queries per second over a 5-minute period for core search and retrieval operations.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local coreSearchAndRetrievalLocal95pQueryLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p95_ms{' + matcher + ', searchHandler=~"/select|/query|/get",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Core search and retrieval local p95 query latency',
  description: 'Represents the 95th percentile latency for local core search and retrieval queries.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      sort: 'desc',
    },
  },
};

local coreSearchAndRetrievalLocal99pQueryLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p99_ms{' + matcher + ', searchHandler=~"/select|/query|/get",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Core search and retrieval 99p local query latency',
  description: 'Represents the 99th percentile latency for local core search and retrieval queries.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      sort: 'desc',
    },
  },
};

local localQueriesRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Local queries',
  collapsed: false,
};

local specializedQueryLoadPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_5minRate{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Specialized query load',
  description: 'Measures the average rate of specialized queries per second over a 5-minute period.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local specialized95pQueryLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p95_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Specialized 95p query latency',
  description: 'Displays the 993ith percentile latency for specialized query types.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      sort: 'desc',
    },
  },
};

local specialized99pQueryLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p99_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Specialized 99p query latency',
  description: 'Displays the 99th percentile latency for specialized query types.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      sort: 'desc',
    },
  },
};

local specializedLocalQueryLoadPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_5minRate{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Specialized local query load',
  description: 'Indicates the average rate of local specialized queries per second over a 5-minute period.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local specializedLocal95pQueryLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p95_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Specialized local 95p query latency',
  description: 'Shows the 95th percentile latency for specialized local queries.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      sort: 'desc',
    },
  },
};

local specializedLocal99pQueryLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p99_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Specialized local 99p query latency',
  description: 'Shows the 99th percentile latency for specialized local queries.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ms',
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
      sort: 'desc',
    },
  },
};

local cacheRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Cache metrics',
  collapsed: false,
};

local cacheEvictionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(type, job, base_url, collection, core) (increase(solr_metrics_core_searcher_cache{' + matcher + ', type=~"documentCache|filterCache|queryResultCache", item=~"evictions"}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{type}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Cache evictions / $__interval',
  description: 'Tracks the number of cache evictions.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local cacheHitRatioPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(type, job, base_url, collection, core) (100 * solr_metrics_core_searcher_cache_ratio{' + matcher + ', type=~"documentCache|filterCache|queryResultCache"}) > 0',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{type}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Cache hit ratio',
  description: 'The cache hit ratio for various cache activities.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      min: 0,
      max: 100,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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

local timeoutsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Timeouts',
  collapsed: false,
};

local coreTimeoutsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url, collection, core) (increase(solr_metrics_core_timeouts_total{' + matcher + '}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Core timeouts / $__interval',
  description: 'Tracks the increase in the number of query timeouts over the specified time interval.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local nodeTimeoutsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url) (increase(solr_metrics_node_timeouts_total{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{base_url}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Node timeouts / $__interval',
  description: 'Tracks the increase in node-level query timeouts over the specified interval.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local errorsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Errors',
  collapsed: false,
};

local queryErrorRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url, collection, core) (solr_metrics_core_query_errors_1minRate{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Query error rate',
  description: 'Measures the rate of query errors over a 1-minute period.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'errors / min',
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
      sort: 'desc',
    },
  },
};

local queryClientErrorsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url, collection, core) (solr_metrics_core_query_client_errors_1minRate{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Query client errors',
  description: 'This metric represents the rate of client errors over a 1-minute period.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'errors / min',
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
      sort: 'desc',
    },
  },
};

local getMatcher(cfg) = '%(solrSelector)s, solr_cluster=~"$solr_cluster", base_url=~"$base_url", collection=~"$solr_collection", core=~"$solr_core"' % cfg;

{
  grafanaDashboards+:: {
    'apache-solr-query-performance.json':
      dashboard.new(
        'Apache Solr query performance',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache Solr dashboards',
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
            'label_values(solr_metrics_core_errors_total,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(solr_metrics_core_errors_total{%(multiclusterSelector)s}, cluster)' % $._config,
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'base_url',
            promDatasource,
            'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, base_url)' % $._config,
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'solr_cluster',
            promDatasource,
            'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, solr_cluster)' % $._config,
            label='Solr cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'solr_collection',
            promDatasource,
            'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, collection)' % $._config,
            label='Collection',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'solr_core',
            promDatasource,
            'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, core)' % $._config,
            label='Core',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
        ]
      )
      .addPanels(
        [
          updateHandlersPanel(getMatcher($._config)) { gridPos: { h: 6, w: 24, x: 0, y: 0 } },
          coreSearchAndRetrievalQueryLoadPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          specializedQueryLoadPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          coreSearchAndRetrieval95pQueryLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
          specialized95pQueryLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
          coreSearchAndRetrieval99pQueryLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
          specialized99pQueryLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
          localQueriesRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
          coreSearchAndRetrievalLocalQueryLoadPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
          specializedLocalQueryLoadPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
          coreSearchAndRetrievalLocal95pQueryLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 31 } },
          specializedLocal95pQueryLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 31 } },
          coreSearchAndRetrievalLocal99pQueryLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 37 } },
          specializedLocal99pQueryLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 37 } },
          cacheRow { gridPos: { h: 1, w: 24, x: 0, y: 43 } },
          cacheEvictionsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 49 } },
          cacheHitRatioPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 49 } },
          timeoutsRow { gridPos: { h: 1, w: 24, x: 0, y: 55 } },
          coreTimeoutsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 61 } },
          nodeTimeoutsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 61 } },
          errorsRow { gridPos: { h: 1, w: 24, x: 0, y: 66 } },
          queryErrorRatePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 72 } },
          queryClientErrorsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 72 } },
        ]
      ),
  },
}
