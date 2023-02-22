local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'cassandra-nodes';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local diskUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_storage_load_count{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Disk usage',
  description: 'The number of bytes being used by this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local memoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_memory_usage_used_bytes{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{area}}',
    ),
  ],
  type: 'timeseries',
  title: 'Memory usage',
  description: 'The JVM memory usage of this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local cpuUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_process_cpu_load{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'CPU usage',
  description: 'The JVM CPU usage of this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local garbageCollectionDurationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_gc_duration_seconds{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection duration',
  description: 'The amount of time spent performing the most recent garbage collection on this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local garbageCollectionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_gc_collection_count{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{name}}',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collections',
  description: 'The number of times garbage collection was performed on this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local keycacheHitRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_cache_hitrate{' + matcher + ', cache="KeyCache"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Keycache hit rate',
  description: 'The keycache hit rate for this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local hintMessagesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_storage_totalhints_count{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Hint messages',
  description: 'The number of hint messages written to this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local pendingCompactionTasksPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_compaction_pendingtasks{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Pending compaction tasks',
  description: 'The number of currently pending compaction tasks on this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local blockedCompactionTasksPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_threadpools_currentlyblockedtasks_count{' + matcher + ', threadpools="CompactionExecutor", path="internal"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Blocked compaction tasks',
  description: 'The number of currently blocked compaction tasks on this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local writesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase((sum by (instance) (cassandra_keyspace_writelatency_seconds_count{' + matcher + '})[$__rate_interval:]))',
      datasource=promDatasource,
      legendFormat='{{ instance }}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Writes',
  description: 'The number of local writes across all keyspaces for this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local readsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase((sum by (instance) (cassandra_keyspace_readlatency_seconds_count{' + matcher + '})[$__rate_interval:]))',
      datasource=promDatasource,
      legendFormat='{{ instance }}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Reads',
  description: 'The number of local reads across all keyspaces for this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
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

local writeAverageLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg(cassandra_keyspace_writelatency_seconds_average{' + matcher + '} >= 0) by (instance)',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Write average latency',
  description: 'Average write latency for the node',
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
      'avg(cassandra_keyspace_readlatency_seconds_average{' + matcher + '} >= 0) by (instance)',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Read average latency',
  description: 'Average read latency for the node',
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

local writeLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    // multiple timeseries to distinguish color
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.50"}) by (instance, quantile)',
      datasource=promDatasource,
      legendFormat='{{instance}} - p50',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.75"}) by (instance, quantile)',
      datasource=promDatasource,
      legendFormat='{{instance}} - p75',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.95"}) by (instance, quantile)',
      datasource=promDatasource,
      legendFormat='{{instance}} - p{{quantile}}',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.99"}) by (instance, quantile)',
      datasource=promDatasource,
      legendFormat='{{instance}} - p{{quantile}}',
    ),
  ],
  type: 'histogram',
  title: 'Write latency',
  description: 'The average local write latency for this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        fillOpacity: 15,
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
    bucketSize: 0,
    combine: false,
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
  },
};

local readLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    // multiple timeseries to distinguish color
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.50"}) by (instance, quantile)',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{quantile}}',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.75"}) by (instance, quantile)',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{quantile}}',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.95"}) by (instance, quantile)',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{quantile}}',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.99"}) by (instance, quantile)',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{quantile}}',
    ),
  ],
  type: 'histogram',
  title: 'Read latency',
  description: 'The average local read latency for this node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        fillOpacity: 15,
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
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
  },
};

local crossnodeLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    // multiple timeseries to distinguish color
    prometheus.target(
      'cassandra_messaging_crossnodelatency_seconds{' + matcher + ', quantile="0.50"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - p50',
    ),
    prometheus.target(
      'cassandra_messaging_crossnodelatency_seconds{' + matcher + ', quantile="0.75"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - p75',
    ),
    prometheus.target(
      'cassandra_messaging_crossnodelatency_seconds{' + matcher + ', quantile="0.95"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - p95',
    ),
    prometheus.target(
      'cassandra_messaging_crossnodelatency_seconds{' + matcher + ', quantile="0.99"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - p99',
    ),
  ],
  type: 'histogram',
  title: 'Cross-node latency',
  description: 'The cross-node latency across the node',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        fillOpacity: 15,
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
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
  },
};

local systemLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename="/var/log/cassandra/system.log"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'System logs',
  description: 'Recent logs from the Cassandra system.logs file',
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

local getMatcher(cfg) = 'job=~"$job", cluster=~"$cluster", instance=~"$instance"' +
                        if cfg.enableDatacenterLabel then ', datacenter=~"$datacenter"' else '' + if cfg.enableRackLabel then ', rack=~"$rack"' else '';

{
  grafanaDashboards+:: {
    'cassandra-nodes.json':
      dashboard.new(
        'Apache Cassandra nodes',
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
              'label_values(cassandra_cache_size, job)',
              label='Job',
              refresh=1,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(cassandra_cache_size, instance)',
              label='Instance',
              refresh=1,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'cluster',
              promDatasource,
              'label_values(cassandra_cache_size, cluster)',
              label='Cluster',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
            template.new(
              'datacenter',
              promDatasource,
              'label_values(cassandra_cache_size, datacenter)',
              label='Datacenter',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
            template.new(
              'rack',
              promDatasource,
              'label_values(cassandra_cache_size, rack)',
              label='Rack',
              refresh=1,
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
            diskUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 0 } },
            memoryUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 0 } },
            cpuUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 0 } },
            garbageCollectionDurationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            garbageCollectionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
            keycacheHitRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 6, x: 0, y: 16 } },
            hintMessagesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 6, x: 6, y: 16 } },
            pendingCompactionTasksPanel(getMatcher($._config)) { gridPos: { h: 8, w: 6, x: 12, y: 16 } },
            blockedCompactionTasksPanel(getMatcher($._config)) { gridPos: { h: 8, w: 6, x: 18, y: 16 } },
            writesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
            readsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
            writeAverageLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 32 } },
            readAverageLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 32 } },
            writeLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 40 } },
            readLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 40 } },
            crossnodeLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 40 } },
          ],
          if $._config.enableLokiLogs then [
            systemLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 48 } },
          ] else [],
        ])
      ),

  },
}
