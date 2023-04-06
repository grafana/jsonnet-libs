local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'redis-enterprise-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local matcher = 'redis_cluster=~"$redis_cluster", job=~"$job"';

local nodesUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_up{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - {{ node }}',
    ),
  ],
  type: 'bargauge',
  title: 'Nodes up',
  description: 'Up/down status for each node in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      displayName: '${__series.name}',
      mappings: [],
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'red',
            value: 0,
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
    displayMode: 'basic',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'horizontal',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
  },
  pluginVersion: '9.4.7',
};

local databasesUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_up{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - bdb={{bdb}}',
    ),
  ],
  type: 'bargauge',
  title: 'Databases up',
  description: 'Up/down status for each database in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      displayName: '${__series.name}',
      mappings: [],
      max: 1,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'red',
            value: 0,
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
    displayMode: 'basic',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'horizontal',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
  },
  pluginVersion: '9.4.7',
};

local shardsUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'redis_up{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - redis: {{ redis }} ',
    ),
  ],
  type: 'bargauge',
  title: 'Shards up',
  description: 'Up/down status for each shard in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      displayName: '${__series.name}',
      mappings: [],
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'red',
            value: 0,
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
    displayMode: 'basic',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'horizontal',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
  },
  pluginVersion: '9.4.7',
};

local clusterTotalRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(node_total_req{redis_cluster=~"$redis_cluster", job=~"$job"}) by (redis_cluster, job)',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }}',
    ),
  ],
  type: 'timeseries',
  title: 'Cluster total requests',
  description: 'Total requests handled by endpoints aggregated across all nodes.',
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

local clusterTotalMemoryUsedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(bdb_used_memory{redis_cluster=~"$redis_cluster", job=~"$job"}) by (job, bdb, redis_cluster)',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Cluster total memory used',
  description: 'Total memory used by each across each database in the cluster',
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

local clusterTotalConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(bdb_conns{redis_cluster=~"$redis_cluster",  job=~"$job"}) by (bdb, redis_cluster, job)',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Cluster total connections',
  description: 'Total connections to each database in the cluster.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local clusterTotalKeysPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(bdb_no_of_keys{' + matcher + '}) by (redis_cluster, bdb, job)',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Cluster total keys',
  description: 'Total cluster key count for each database in the cluster.',
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

local clusterCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_read_hits{' + matcher + '} / (clamp_min(bdb_read_hits{' + matcher + '} + bdb_read_misses{' + matcher + '}, 1)) * 100',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Cluster cache hit ratio',
  description: 'Ratio of database cache key hits against hits and misses.',
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

local clusterEvictionsVsExpiredObjectsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_evicted_objects{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }} - evicted',
    ),
    prometheus.target(
      'bdb_expired_objects{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }} - expired',
    ),
  ],
  type: 'timeseries',
  title: 'Cluster evictions vs expired objects',
  description: 'Sum of key evictions and expirations in the cluster by database.',
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

local nodesKPIsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Nodes KPIs',
  collapsed: false,
};

local nodeRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(node_total_req{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - node: {{ node }} ',
    ),
  ],
  type: 'timeseries',
  title: 'Node requests',
  description: 'Endpoint request rate for each node in the cluster.',
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

local nodeAverageLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_avg_latency{' + matcher + ' }',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - node: {{ node }} ',
    ),
  ],
  type: 'timeseries',
  title: 'Node average latency',
  description: 'Average latency for each node in the cluster.',
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

local nodeMemoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '(sum(redis_used_memory{' + matcher + '}) by (redis_cluster, node, job) / clamp_min(sum(node_available_memory{' + matcher + '}) by (redis_cluster,node, job), 1)) * 100',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - node: {{ node }} ',
    ),
  ],
  type: 'timeseries',
  title: 'Node memory utilization',
  description: 'Memory utilization % for each node in the cluster.',
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

local nodeCPUUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_cpu_system{' + matcher + '} * 100',
      datasource=promDatasource,
      legendFormat='node: {{ node }} - system',
    ),
    prometheus.target(
      'node_cpu_user{' + matcher + '} * 100',
      datasource=promDatasource,
      legendFormat='node: {{ node }} - user',
    ),
  ],
  type: 'timeseries',
  title: 'Node CPU utilization',
  description: 'CPU utilization for each node in the cluster.',
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

local databaseKPIsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Database KPIs',
  collapsed: false,
};

local databaseOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(bdb_instantaneous_ops_per_sec{' + matcher + '}) by (redis_cluster, bdb, job)',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }} ',
    ),
  ],
  type: 'timeseries',
  title: 'Database operations',
  description: 'Rate of request handled by each database in the cluster.',
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
      unit: 'ops',
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

local databaseAverageLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(bdb_avg_latency{' + matcher + '}) by (redis_cluster, job, bdb)',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }} ',
    ),
  ],
  type: 'timeseries',
  title: 'Database average latency',
  description: 'Average latency for each database in the cluster.',
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

local databaseMemoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(bdb_used_memory{' + matcher + '}) by (job, redis_cluster, bdb) / clamp_min(sum(bdb_memory_limit{' + matcher + '}) by (job, redis_cluster, bdb), 1) * 100 ',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }} ',
    ),
  ],
  type: 'timeseries',
  title: 'Database memory utilization',
  description: 'Calculated memory utilization % for each database in the cluster.',
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

local databaseCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(bdb_read_hits{' + matcher + '}) by (job, redis_cluster, bdb) / clamp_min(sum(bdb_read_hits{' + matcher + '}) by (job, redis_cluster, bdb) + sum(bdb_read_misses{' + matcher + '}) by (job, redis_cluster, bdb),1) * 100',
      datasource=promDatasource,
      legendFormat='{{ redis_cluster }} - db: {{ bdb }} ',
    ),
  ],
  type: 'timeseries',
  title: 'Database cache hit ratio',
  description: 'Calculated cache hit rate for each database in the cluster',
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

{
  grafanaDashboards+:: {
    'redis-enterprise-overview.json':
      dashboard.new(
        'Redis Enterprise overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Redis Enterprise dashboards',
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
            'label_values(node_up, job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'redis_cluster',
            promDatasource,
            'label_values(node_up, redis_cluster)\n',
            label='Redis Cluster',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          nodesUpPanel { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
          databasesUpPanel { gridPos: { h: 6, w: 8, x: 8, y: 0 } },
          shardsUpPanel { gridPos: { h: 6, w: 8, x: 16, y: 0 } },
          clusterTotalRequestsPanel { gridPos: { h: 6, w: 8, x: 0, y: 6 } },
          clusterTotalMemoryUsedPanel { gridPos: { h: 6, w: 8, x: 8, y: 6 } },
          clusterTotalConnectionsPanel { gridPos: { h: 6, w: 8, x: 16, y: 6 } },
          clusterTotalKeysPanel { gridPos: { h: 6, w: 8, x: 0, y: 12 } },
          clusterCacheHitRatioPanel { gridPos: { h: 6, w: 8, x: 8, y: 12 } },
          clusterEvictionsVsExpiredObjectsPanel { gridPos: { h: 6, w: 8, x: 16, y: 12 } },
          nodesKPIsRow { gridPos: { h: 1, w: 24, x: 0, y: 18 } },
          nodeRequestsPanel { gridPos: { h: 6, w: 6, x: 0, y: 19 } },
          nodeAverageLatencyPanel { gridPos: { h: 6, w: 6, x: 6, y: 19 } },
          nodeMemoryUtilizationPanel { gridPos: { h: 6, w: 6, x: 12, y: 19 } },
          nodeCPUUtilizationPanel { gridPos: { h: 6, w: 6, x: 18, y: 19 } },
          databaseKPIsRow { gridPos: { h: 1, w: 24, x: 0, y: 25 } },
          databaseOperationsPanel { gridPos: { h: 6, w: 6, x: 0, y: 26 } },
          databaseAverageLatencyPanel { gridPos: { h: 6, w: 6, x: 6, y: 26 } },
          databaseMemoryUtilizationPanel { gridPos: { h: 6, w: 6, x: 12, y: 26 } },
          databaseCacheHitRatioPanel { gridPos: { h: 6, w: 6, x: 18, y: 26 } },
        ]
      ),
  },
}
