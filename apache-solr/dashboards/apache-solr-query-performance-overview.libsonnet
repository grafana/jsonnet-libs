local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-solr-query-performance-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local updateHandlersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url, collection, core) (increase(solr_metrics_core_update_handler_adds_total{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", collection=~"$solr_collection", core=~"$solr_core"}[$__interval:]))',
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

local coreSearchAndRetrievalQueryLoadPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_5minRate{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/select|/query|/get", collection=~"$solr_collection", core=~"$solr_core",})',
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

local coreSearchAndRetrieval95pQueryLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p95_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/select|/query|/get", collection=~"$solr_collection", core=~"$solr_core",})',
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
local coreSearchAndRetrieval99pQueryLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p99_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/select|/query|/get", collection=~"$solr_collection", core=~"$solr_core",})',
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

local coreSearchAndRetrievalLocalQueryLoadPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_5minRate{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/select|/query|/get", collection=~"$solr_collection", core=~"$solr_core",})',
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

local coreSearchAndRetrievalLocal95pQueryLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p95_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/select|/query|/get", collection=~"$solr_collection", core=~"$solr_core",})',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Core search and retrieval local p95 query latency',
  description: 'Represents the 95th percentile latency for local core search and retrieval queries',
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

local coreSearchAndRetrievalLocal99pQueryLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p99_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/select|/query|/get", collection=~"$solr_collection", core=~"$solr_core",})',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Core search and retrieval 99p local query latency',
  description: 'Represents the 99th percentile latency for local core search and retrieval queries',
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

local specializedQueryLoadPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_5minRate{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",})',
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

local specialized95pQueryLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p95_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",})',
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

local specialized99pQueryLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p99_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",})',
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

local specializedLocalQueryLoadPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_5minRate{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",})',
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

local specializedLocal95pQueryLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p95_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",})',
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

local specializedLocal99pQueryLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p99_ms{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", searchHandler=~"/sql|/export|/stream", collection=~"$solr_collection", core=~"$solr_core",})',
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

local cacheEvictionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(type, job, base_url, collection, core) (increase(solr_metrics_core_searcher_cache{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", collection=~"$solr_collection", core=~"$solr_core", type=~"documentCache|filterCache|queryResultCache", item=~"evictions"}[$__interval:]))',
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

local cacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(type, job, base_url, collection, core) (100 * solr_metrics_core_searcher_cache_ratio{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", collection=~"$solr_collection", core=~"$solr_core", type=~"documentCache|filterCache|queryResultCache"})',
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

local coreTimeoutsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url, collection, core) (increase(solr_metrics_core_timeouts_total{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", collection=~"$solr_collection", core=~"$solr_core"}[$__interval:]))',
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

local nodeTimeoutsPanel = {
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

local queryErrorRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url, collection, core) (solr_metrics_core_query_errors_1minRate{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", collection=~"$solr_collection", core=~"$solr_core"})',
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

local queryClientErrorsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by(job, base_url, collection, core) (solr_metrics_core_query_client_errors_1minRate{job=~"$job", base_url=~"$base_url", solr_cluster=~"$solr_cluster", collection=~"$solr_collection", core=~"$solr_core"})',
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

{
  grafanaDashboards+:: {
    'apache-solr-query-performance-overview.json':
      dashboard.new(
        'Apache Solr query performance overview',
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
            'base_url',
            promDatasource,
            'label_values(solr_metrics_core_errors_total{job=~"$job"}, base_url)',
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
            'label_values(solr_metrics_core_errors_total{job=~"$job"}, solr_cluster)',
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
            'label_values(solr_metrics_core_errors_total{job=~"$job"}, collection)',
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
            'label_values(solr_metrics_core_errors_total{job=~"$job"}, core)',
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
          updateHandlersPanel { gridPos: { h: 6, w: 24, x: 0, y: 0 } },
          coreSearchAndRetrievalQueryLoadPanel { gridPos: { h: 6, w: 8, x: 0, y: 6 } },
          coreSearchAndRetrieval95pQueryLatencyPanel { gridPos: { h: 6, w: 8, x: 8, y: 6 } },
          coreSearchAndRetrieval99pQueryLatencyPanel { gridPos: { h: 6, w: 8, x: 16, y: 6 } },
          specializedQueryLoadPanel { gridPos: { h: 6, w: 8, x: 0, y: 12 } },
          specialized95pQueryLatencyPanel { gridPos: { h: 6, w: 8, x: 8, y: 12 } },
          specialized99pQueryLatencyPanel { gridPos: { h: 6, w: 8, x: 16, y: 12 } },
          localQueriesRow { gridPos: { h: 1, w: 24, x: 0, y: 18 } },
          coreSearchAndRetrievalLocalQueryLoadPanel { gridPos: { h: 6, w: 8, x: 0, y: 19 } },
          coreSearchAndRetrievalLocal95pQueryLatencyPanel { gridPos: { h: 6, w: 8, x: 8, y: 19 } },
          coreSearchAndRetrievalLocal99pQueryLatencyPanel { gridPos: { h: 6, w: 8, x: 16, y: 19 } },
          specializedLocalQueryLoadPanel { gridPos: { h: 6, w: 8, x: 0, y: 25 } },
          specializedLocal95pQueryLatencyPanel { gridPos: { h: 6, w: 8, x: 8, y: 25 } },
          specializedLocal99pQueryLatencyPanel { gridPos: { h: 6, w: 8, x: 16, y: 25 } },
          cacheRow { gridPos: { h: 1, w: 24, x: 0, y: 31 } },
          cacheEvictionsPanel { gridPos: { h: 6, w: 12, x: 0, y: 32 } },
          cacheHitRatioPanel { gridPos: { h: 6, w: 12, x: 12, y: 32 } },
          timeoutsRow { gridPos: { h: 1, w: 24, x: 0, y: 38 } },
          coreTimeoutsPanel { gridPos: { h: 6, w: 12, x: 0, y: 44 } },
          nodeTimeoutsPanel { gridPos: { h: 6, w: 12, x: 12, y: 44 } },
          errorsRow { gridPos: { h: 1, w: 24, x: 0, y: 50 } },
          queryErrorRatePanel { gridPos: { h: 6, w: 12, x: 0, y: 51 } },
          queryClientErrorsPanel { gridPos: { h: 6, w: 12, x: 12, y: 51 } },
        ]
      ),
  },
}
