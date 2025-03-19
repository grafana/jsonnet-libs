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
      'count(count by (cassandra_cluster) (cassandra_up_endpoint_count{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      legendFormat='{{ cassandra_cluster }}',
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
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(increase(cassandra_connection_timeouts_count{' + matcher + '}[$__interval:])) by (cassandra_cluster, instance)',
      datasource=promDatasource,
      legendFormat='{{ instance }}',
      format='time_series',
      interval='1m',
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
      'avg(cassandra_cache_hitrate{' + matcher + ', cache="KeyCache",} * 100) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }} ',
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
      'sum(cassandra_connection_largemessagedroppedtasks{' + matcher + '}) by (cassandra_cluster, instance)',
      datasource=promDatasource,
      legendFormat='{{ instance }} - large dropped',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_connection_largemessageactivetasks{' + matcher + '}) by (cassandra_cluster, instance)',
      datasource=promDatasource,
      legendFormat='{{ instance }} - large active',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_connection_largemessagependingtasks{' + matcher + '}) by (cassandra_cluster, instance)',
      datasource=promDatasource,
      legendFormat='{{ instance }} - large pending',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_connection_smallmessagedroppedtasks{' + matcher + '}) by (cassandra_cluster, instance)',
      datasource=promDatasource,
      legendFormat='{{ instance }} - small dropped',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_connection_smallmessageactivetasks{' + matcher + '}) by (cassandra_cluster, instance)',
      datasource=promDatasource,
      legendFormat='{{ instance }} - small active',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_connection_smallmessagependingtasks{' + matcher + '}) by (cassandra_cluster, instance)',
      datasource=promDatasource,
      legendFormat='{{ instance }} - small pending',
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
      'sum(cassandra_storage_load_count{' + matcher + '}) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{cassandra_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Total disk usage',
  description: 'The total number of bytes being used by Apache Cassandra for storage.',
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
      unit: 'bytes',
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
  pluginVersion: '9.4.1-30f3f63',
};

local diskUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_storage_load_count{' + matcher + '}) by (cassandra_cluster, instance)',
      datasource=promDatasource,
      legendFormat='{{ instance }}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Disk usage',
  description: 'The number of bytes used by each node of the cluster',
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
      'increase((sum by (cassandra_cluster) (cassandra_keyspace_writelatency_seconds_count{' + matcher + '})[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'increase((sum by (cassandra_cluster) (cassandra_keyspace_readlatency_seconds_count{' + matcher + '})[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(cassandra_keyspace_writelatency_seconds_average{' + matcher + '} >= 0) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(cassandra_keyspace_readlatency_seconds_average{' + matcher + '} >= 0) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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

local writeLatencyHeatmapPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + '}) by (quantile)',
      datasource=promDatasource,
      format='time_series',
    ),
  ],
  type: 'heatmap',
  title: 'Write latency heatmap',
  description: 'Local write latency heatmap for this cluster',
  fieldConfig: {
    defaults: {
      custom: {
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        scaleDistribution: {
          type: 'linear',
        },
      },
    },
    overrides: [],
  },
  options: {
    calculate: true,
    cellGap: 1,
    cellValues: {
      unit: 'short',
    },
    color: {
      exponent: 0.5,
      fill: 'dark-orange',
      mode: 'scheme',
      reverse: false,
      scale: 'exponential',
      scheme: 'Oranges',
      steps: 64,
    },
    exemplars: {
      color: 'rgba(255,0,255,0.7)',
    },
    filterValues: {
      le: 1e-9,
    },
    legend: {
      show: true,
    },
    rowsFrame: {
      layout: 'auto',
    },
    tooltip: {
      show: true,
      yHistogram: false,
    },
    yAxis: {
      axisPlacement: 'left',
      reverse: false,
      unit: 's',
    },
  },
  pluginVersion: '9.4.1',
};

local readLatencyHeatmapPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + '}) by (quantile)',
      datasource=promDatasource,
      format='time_series',
    ),
  ],
  type: 'heatmap',
  title: 'Read latency heatmap',
  description: 'Local read latency heatmap for this cluster',
  fieldConfig: {
    defaults: {
      custom: {
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        scaleDistribution: {
          type: 'linear',
        },
      },
    },
    overrides: [],
  },
  options: {
    calculate: true,
    calculation: {
      xBuckets: {
        mode: 'size',
      },
      yBuckets: {
        mode: 'size',
      },
    },
    cellGap: 1,
    color: {
      exponent: 0.5,
      fill: 'dark-orange',
      mode: 'scheme',
      reverse: false,
      scale: 'exponential',
      scheme: 'Oranges',
      steps: 64,
    },
    exemplars: {
      color: 'rgba(255,0,255,0.7)',
    },
    filterValues: {
      le: 1e-9,
    },
    legend: {
      show: true,
    },
    rowsFrame: {
      layout: 'auto',
    },
    tooltip: {
      show: true,
      yHistogram: false,
    },
    yAxis: {
      axisPlacement: 'left',
      reverse: false,
      unit: 's',
    },
  },
  pluginVersion: '9.4.1',
};

local writeLatencyQuartilesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.95"} >= 0) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }} - p95',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.99"} >= 0) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }} - p99',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Write latency quartiles',
  description: 'Local write latency quartiles for this cluster',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'left',
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
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
  pluginVersion: '9.4.1',
};

local readLatencyQuartilesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.95"} >= 0) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }} - p95',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.99"} >= 0) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }} - p99',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Read latency quartiles',
  description: 'Local read latency quartiles for this cluster',
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

local clientRequestsRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(increase(cassandra_clientrequest_latency_seconds_count{' + matcher + ', clientrequest="Write"}[$__interval:])) by (cassandra_cluster)',
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
      'sum(increase(cassandra_clientrequest_timeouts_count{' + matcher + ', clientrequest="Write"}[$__interval:])) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(increase(cassandra_clientrequest_timeouts_count{' + matcher + ', clientrequest="Write"}[$__interval:])) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(increase(cassandra_clientrequest_unavailables_count{' + matcher + ', clientrequest="Write"}[$__interval:])) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(increase(cassandra_clientrequest_latency_seconds_count{' + matcher + ', clientrequest="Read"}[$__interval:])) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(increase(cassandra_clientrequest_timeouts_count{' + matcher + ', clientrequest="Read"}[$__interval:])) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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
      'sum(increase(cassandra_clientrequest_unavailables_count{' + matcher + ', clientrequest="Read"}[$__interval:])) by (cassandra_cluster)',
      datasource=promDatasource,
      legendFormat='{{ cassandra_cluster }}',
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

local getMatcher(cfg) = '%(cassandraSelector)s, cassandra_cluster=~"$cassandra_cluster"' % cfg +
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
                'label_values(cassandra_up_endpoint_count{%(multiclusterSelector)s}, cluster)' % $._config,
                label='Cluster',
                refresh=1,
                includeAll=true,
                multi=true,
                allValues='',
                hide=if $._config.enableMultiCluster then '' else 'variable',
                sort=0
              ),
              template.new(
                'cassandra_cluster',
                promDatasource,
                'label_values(cassandra_up_endpoint_count{%(cassandraSelector)s}, cassandra_cluster)' % $._config,
                label='Cassandra cluster',
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
              'label_values(cassandra_up_endpoint_count{%(cassandraSelector)s}, datacenter)' % $._config,
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
              'label_values(cassandra_up_endpoint_count{%(cassandraSelector)s' % $._config +
              if $._config.enableDatacenterLabel then ', datacenter=~"$datacenter"' else '' + '}, rack)',
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
          totalDiskUsagePanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 12, y: 12 } },
          diskUsagePanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 18, y: 12 } },
          writesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
          readsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
          writeAverageLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 24 } },
          readAverageLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 24 } },
          writeLatencyHeatmapPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 30 } },
          readLatencyHeatmapPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 30 } },
          writeLatencyQuartilesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 36 } },
          readLatencyQuartilesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 36 } },
          clientRequestsRow { gridPos: { h: 1, w: 24, x: 0, y: 42 } },
          writeRequestsPanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 0, y: 43 } },
          writeRequestsTimedOutPanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 8, y: 43 } },
          writeRequestsUnavailablePanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 16, y: 43 } },
          readRequestsPanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 0, y: 48 } },
          readRequestsTimedOutPanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 8, y: 48 } },
          readRequestsUnavailablePanel(getMatcher($._config)) { gridPos: { h: 5, w: 8, x: 16, y: 48 } },
        ]
      ),
  },
}
