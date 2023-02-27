local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'cassandra-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local numberOfClustersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count by (job) (cassandra_up_endpoint_count{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Number of clusters',
  description: 'The number of unique jobs being reported',
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
            color: 'red',
            value: null,
          },
          {
            color: 'green',
            value: 1,
          },
        ],
      },
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
  pluginVersion: '9.3.6',
};

local numberOfNodesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max(cassandra_up_endpoint_count{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Number of nodes',
  description: 'The sum of unique instances being reported.',
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
            color: 'red',
            value: null,
          },
          {
            color: 'green',
            value: 1,
          },
        ],
      },
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
  pluginVersion: '9.3.6',
};

local numberOfDownNodesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max(cassandra_down_endpoint_count{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Number of down nodes',
  description: 'Number of down nodes in the cluster',
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
            value: 1,
          },
        ],
      },
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
  pluginVersion: '9.3.6',
};

local connectionTimeoutsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_connection_timeouts_count{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ connection }} - {{ cluster }}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Connection timeouts',
  description: 'The number of timeouts experienced from each node',
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

local averageKeyCacheHitRatioPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg(cassandra_cache_hitrate{' + matcher + ', cache="KeyCache",} * 100) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} ',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Average key cache hit ratio',
  description: 'The number of medium tasks that a connection has either completed, dropped, or is pending',
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
      max: 100,
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

local tasksPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_connection_largemessagedroppedtasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{connection}} -  {{ cluster }}  -  large dropped',
      format='time_series',
    ),
    prometheus.target(
      'cassandra_connection_largemessageactivetasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{connection}} - {{ cluster }} -  large active',
      format='time_series',
    ),
    prometheus.target(
      'cassandra_connection_largemessagependingtasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{connection}} - {{ cluster }} - large pending',
      format='time_series',
    ),
    prometheus.target(
      'cassandra_connection_smallmessagedroppedtasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{connection}} - {{ cluster }} - small dropped',
      format='time_series',
    ),
    prometheus.target(
      'cassandra_connection_smallmessageactivetasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{connection}} - {{ cluster }} - small active',
      format='time_series',
    ),
    prometheus.target(
      'cassandra_connection_smallmessagependingtasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{connection}} - {{ cluster }} - small pending',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Tasks',
  description: 'The number of tasks that a connection has either completed, dropped, or is pending',
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
        fillOpacity: 15,
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

local totalDiskUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_storage_load_count{' + matcher + '}) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Total disk usage',
  description: 'The total number of bytes being used by Apache Cassandra for storage.',
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

local writesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase((sum by (cluster) (cassandra_keyspace_writelatency_seconds_count{' + matcher + '})[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Writes',
  description: 'The number of local writes aggregated across all nodes.',
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
        fillOpacity: 5,
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

local readsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase((sum by (cluster) (cassandra_keyspace_readlatency_seconds_count{' + matcher + '})[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Reads',
  description: 'The number of local writes aggregated across all nodes.',
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
        fillOpacity: 5,
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

local writeAverageLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds_average{' + matcher + '} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
    ),
  ],
  type: 'timeseries',
  title: 'Write average latency',
  description: 'Average write latency for the cluster',
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
        fillOpacity: 5,
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

local readAverageLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds_average{' + matcher + '} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
    ),
  ],
  type: 'timeseries',
  title: 'Read average latency',
  description: 'Average read latency for the cluster',
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
        fillOpacity: 5,
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

local readLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.50"} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} - p50',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.75"} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} - p75',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.95"} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} - p95',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.95"} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} - p99',
    ),
  ],
  type: 'histogram',
  title: 'Read latency',
  description: 'Average local read latency for this cluster',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        fillOpacity: 5,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineWidth: 1,
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
    overrides: [
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'A',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'red',
              mode: 'fixed',
            },
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
            id: 'color',
            value: {
              fixedColor: 'blue',
              mode: 'fixed',
            },
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
            id: 'color',
            value: {
              fixedColor: 'green',
              mode: 'fixed',
            },
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'D',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'purple',
              mode: 'fixed',
            },
          },
        ],
      },
    ],
  },
  options: {
    bucketOffset: 0,
    combine: false,
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
  },
};

local writeLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.50"} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} - p50',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.75"} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} - p75',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.95"} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} - p95',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.95"} >= 0) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }} - p99',
    ),
  ],
  type: 'histogram',
  title: 'Write latency',
  description: 'Average local write latency for this cluster',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        fillOpacity: 5,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineWidth: 1,
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
    overrides: [
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'A',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'red',
              mode: 'fixed',
            },
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
            id: 'color',
            value: {
              fixedColor: 'blue',
              mode: 'fixed',
            },
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
            id: 'color',
            value: {
              fixedColor: 'green',
              mode: 'fixed',
            },
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'D',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'purple',
              mode: 'fixed',
            },
          },
        ],
      },
    ],
  },
  options: {
    bucketOffset: 0,
    combine: false,
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
  },
};

local clientRequestsRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
    ),
  ],
  type: 'row',
  title: 'Client requests',
  collapsed: false,
};

local writeRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(cassandra_clientrequest_latency_seconds_count{' + matcher + ', clientrequest="Write"}[$__interval:])) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{label_name}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Write requests',
  description: 'Rate of standard client write requests.',
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

local writeRequestsUnavailablePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(cassandra_clientrequest_timeouts_count{' + matcher + ', clientrequest="Write"}[$__rate_interval:])) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Write requests timed out',
  description: 'Standard client write requests returning timed out exceptions.',
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

local writeRequestsTimedOutPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(cassandra_clientrequest_timeouts_count{' + matcher + ', clientrequest="Write"}[$__rate_interval:])) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Write requests timed out',
  description: 'Standard client write requests returning timed out exceptions.',
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

local writeRequestsUnavailablePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(cassandra_clientrequest_unavailables_count{' + matcher + ', clientrequest="Write"}[$__rate_interval:])) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Write requests unavailable',
  description: 'Standard client write requests returning timed out exceptions.',
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

local readRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(cassandra_clientrequest_latency_seconds_count{' + matcher + ', clientrequest="Read"}[$__interval:])) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Read requests',
  description: 'Rate of standard client read requests.',
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

local readRequestsTimedOutPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(cassandra_clientrequest_timeouts_count{' + matcher + ', clientrequest="Read"}[$__rate_interval:])) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Read requests timed out',
  description: 'Standard client read requests returning timed out exceptions.',
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

local readRequestsUnavailablePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(cassandra_clientrequest_unavailables_count{' + matcher + ', clientrequest="Read"}[$__rate_interval:])) by (cluster)',
      datasource=promDatasource,
      legendFormat='{{ cluster }}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Read requests unavailable',
  description: 'Standard client write requests returning timed out exceptions.',
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

local getMatcher(cfg) = 'job=~"$job", cluster=~"$cluster"' +
                        if cfg.enableDatacenterLabel then ', datacenter=~"$datacenter"' else '' + if cfg.enableRackLabel then ', rack=~"$rack"' else '';

{
  grafanaDashboards+:: {
    'cassandra-overview.json':
      dashboard.new(
        'Apache Cassandra overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache Cassandra dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates(
        std.flattenArrays(
          [
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
                'label_values(cassandra_up_endpoint_count, job)',
                label='Job',
                refresh=1,
                includeAll=true,
                multi=true,
                allValues='',
                sort=0
              ),
              template.new(
                'cluster',
                promDatasource,
                'label_values(cassandra_up_endpoint_count, cluster)',
                label='Cluster',
                refresh=1,
                includeAll=true,
                multi=true,
                allValues='',
                sort=0
              ),
            ],
            if $._config.enableDatacenterLabel then [template.new(
              'datacenter',
              promDatasource,
              'label_values(cassandra_up_endpoint_count, datacenter)',
              label='Datacenter',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            )] else [],
            if $._config.enableRackLabel then [template.new(
              'rack',
              promDatasource,
              'label_values(cassandra_up_endpoint_count, rack)',
              label='Rack',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            )] else [],
          ]
        )
      )
      .addPanels(
        [
          numberOfClustersPanel(getMatcher($._config)) { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
          numberOfNodesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 8, x: 8, y: 0 } },
          numberOfDownNodesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 8, x: 16, y: 0 } },
          connectionTimeoutsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          averageKeyCacheHitRatioPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          tasksPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
          totalDiskUsagePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
          writesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
          readsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
          writeAverageLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 24 } },
          readAverageLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 24 } },
          writeLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 30 } },
          readLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 30 } },
          clientRequestsRow { gridPos: { h: 1, w: 24, x: 0, y: 36 } },
          writeRequestsPanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 0, y: 37 } },
          writeRequestsTimedOutPanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 8, y: 37 } },
          writeRequestsUnavailablePanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 16, y: 37 } },
          readRequestsPanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 0, y: 42 } },
          readRequestsTimedOutPanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 8, y: 42 } },
          readRequestsUnavailablePanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 16, y: 42 } },
        ]
      ),
  },
}
