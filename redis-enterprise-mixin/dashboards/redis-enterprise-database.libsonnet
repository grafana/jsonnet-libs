local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'redis-enterprise-database-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local nodeMatcher = 'redis_cluster=~"$redis_cluster", job=~"$job"';
local matcher = nodeMatcher + ', bdb=~"$database"';

local databaseUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_up{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='node: {{ node }} - {{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database up',
  description: 'Displays up/down status for the selected database.',
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

local shardsUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'redis_up{redis_cluster=~"$redis_cluster", job=~"$job", node=~"$node"}',
      datasource=promDatasource,
      legendFormat='{{ bdb }} - redis: {{ redis }}',
    ),
  ],
  type: 'bargauge',
  title: 'Shards up',
  description: 'Displays up/down status for each shard related to the database.',
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
            color: 'green',
            value: null,
          },
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

local nodesUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_up{' + nodeMatcher + ', node=~"$node"}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Nodes up',
  description: 'Displays up/down status for each node related to the database.',
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

local databaseOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_read_req{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }} - read',
    ),
    prometheus.target(
      'bdb_write_req{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{bdb}} - write',
    ),
  ],
  type: 'timeseries',
  title: 'Database operations',
  description: 'Rate of read and write requests.',
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
      'bdb_avg_read_latency{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }} - read',
    ),
    prometheus.target(
      'bdb_avg_write_latency{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{bdb }} - write',
    ),
  ],
  type: 'timeseries',
  title: 'Database average latency',
  description: 'Average rate of read and write latency',
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
      unit: 'seconds',
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

local databaseKeyCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_no_of_keys{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database key count',
  description: 'Number of keys in the database.',
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

local databaseCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_read_hits{' + matcher + '} / clamp_min(bdb_read_misses{' + matcher + '} + bdb_read_hits{' + matcher + '}, 1) * 100',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database cache hit ratio',
  description: 'Percentage of read operations that result in a cache hit.',
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

local databaseEvictionsVsExpirationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_expired_objects{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }} - expired',
    ),
    prometheus.target(
      'bdb_evicted_objects{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }} - evicted',
    ),
  ],
  type: 'timeseries',
  title: 'Database evictions vs expirations',
  description: 'Rate of object expiration and eviction',
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

local databaseMemoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_used_memory{' + matcher + '} / bdb_memory_limit{' + matcher + '} * 100',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database memory utilization',
  description: 'Calculated memory utilization % of the database compared to the limit.',
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

local databaseMemoryFragmentationRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_mem_frag_ratio{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database memory fragmentation ratio',
  description: 'RAM fragmentation ratio between RSS and allocated RAM.',
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

local databaseLUAHeapSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_mem_size_lua{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database LUA heap size',
  description: 'LUA scripting heap size',
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

local databaseNetworkIngressPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_ingress_bytes{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database network ingress',
  description: 'Rate of incoming network traffic.',
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
      unit: 'binBps',
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

local databaseNetworkEgressPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_egress_bytes{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database network egress',
  description: 'Rate of outgoing network traffic.',
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
      unit: 'binBps',
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

local databaseConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_conns{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Database connections',
  description: 'Number of client connections',
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

local activeactiveRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Active-active',
  collapsed: false,
};

local syncStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_crdt_syncer_status{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }} - repl_id: {{ crdt_replica_id }}',
    ),
  ],
  type: 'timeseries',
  title: 'Sync status',
  description: 'Sync status for CRDB traffic.\n- 0=in-sync\n- 1=syncing\n- 2=out of sync',
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

local localLagPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_crdt_syncer_local_ingress_lag_time{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'Local lag',
  description: 'Lag between source and destination for CRDB traffic.',
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
      unit: 'ms',
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

local crdbIngressCompressedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_crdt_syncer_ingress_bytes{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'CRDB ingress compressed',
  description: 'Rate of compressed network traffic to the CRDB.',
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
      unit: 'binBps',
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

local crdbIngressDecompressedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_crdt_ingress_bytes_decompressed{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ bdb }}',
    ),
  ],
  type: 'timeseries',
  title: 'CRDB ingress decompressed',
  description: 'Rate of decompressed network traffic to the CRDB.',
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
      unit: 'binBps',
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
    'redis-enterprise-database-overview.json':
      dashboard.new(
        'Redis Enterprise database overview',
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
            'label_values(bdb_up, job)',
            label='Job',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'redis_cluster',
            promDatasource,
            'label_values(bdb_up, redis_cluster)',
            label='Redis Cluster',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'node',
            promDatasource,
            'label_values(redis_up, node)',
            label='Node',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'database',
            promDatasource,
            'label_values(bdb_up, bdb)',
            label='Database',
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
          databaseUpPanel { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
          shardsUpPanel { gridPos: { h: 6, w: 8, x: 8, y: 0 } },
          nodesUpPanel { gridPos: { h: 6, w: 8, x: 16, y: 0 } },
          databaseOperationsPanel { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          databaseAverageLatencyPanel { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          databaseKeyCountPanel { gridPos: { h: 6, w: 8, x: 0, y: 12 } },
          databaseCacheHitRatioPanel { gridPos: { h: 6, w: 8, x: 8, y: 12 } },
          databaseEvictionsVsExpirationsPanel { gridPos: { h: 6, w: 8, x: 16, y: 12 } },
          databaseMemoryUtilizationPanel { gridPos: { h: 6, w: 8, x: 0, y: 18 } },
          databaseMemoryFragmentationRatioPanel { gridPos: { h: 6, w: 8, x: 8, y: 18 } },
          databaseLUAHeapSizePanel { gridPos: { h: 6, w: 8, x: 16, y: 18 } },
          databaseNetworkIngressPanel { gridPos: { h: 6, w: 8, x: 0, y: 24 } },
          databaseNetworkEgressPanel { gridPos: { h: 6, w: 8, x: 8, y: 24 } },
          databaseConnectionsPanel { gridPos: { h: 6, w: 8, x: 16, y: 24 } },
          activeactiveRow { gridPos: { h: 1, w: 24, x: 0, y: 30 } },
          syncStatusPanel { gridPos: { h: 6, w: 6, x: 0, y: 31 } },
          localLagPanel { gridPos: { h: 6, w: 6, x: 6, y: 31 } },
          crdbIngressCompressedPanel { gridPos: { h: 6, w: 6, x: 12, y: 31 } },
          crdbIngressDecompressedPanel { gridPos: { h: 6, w: 6, x: 18, y: 31 } },
        ]
      ),
  },
}
