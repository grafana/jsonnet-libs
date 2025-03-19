local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'redis-enterprise-node-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local matcher = 'redis_cluster=~"$redis_cluster", job=~"$job", node=~"$node"';

local nodesUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_up{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Nodes up',
  description: 'Displays up/down status for the selected node',
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

local databaseUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bdb_up{redis_cluster=~"$redis_cluster", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='db: {{ bdb }}',
    ),
  ],
  type: 'bargauge',
  title: 'Database up',
  description: 'Displays up/down status for the databases of the selected node(s).',
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
            color: 'transparent',
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

local shardsUpPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'redis_up{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='redis: {{redis}}',
    ),
  ],
  type: 'bargauge',
  title: 'Shards up',
  description: 'Displays up/down status for the shards on the selected node.',
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
            color: 'transparent',
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

local nodeRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_total_req{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Node requests',
  description: 'Total endpoint request rate for the selected node.',
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
      'node_avg_latency{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Node average latency',
  description: 'Average request latency for the selected node.',
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

local nodeCPUUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_cpu_system{' + matcher + '} * 100',
      datasource=promDatasource,
      legendFormat='{{ node }} - system',
    ),
    prometheus.target(
      'node_cpu_user{' + matcher + '} * 100',
      datasource=promDatasource,
      legendFormat='{{node}} - user',
    ),
  ],
  type: 'timeseries',
  title: 'Node CPU utilization',
  description: 'CPU utilization for idle, main, and user threads.',
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

local nodeMemoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '(sum(redis_used_memory{' + matcher + '}) by (redis_cluster, job, node) / clamp_min(sum(node_available_memory{' + matcher + '}) by (redis_cluster, job, node) + sum(redis_used_memory{' + matcher + '}) by (redis_cluster, job, node), 1)) * 100',
      datasource=promDatasource,
      legendFormat='{{node}}',
    ),
  ],
  type: 'timeseries',
  title: 'Node memory utilization',
  description: 'Node memory utilization %.',
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

local nodeEphemeralFreeStoragePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_ephemeral_storage_free{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Node ephemeral free storage',
  description: 'Ephemeral storage available for the selected node.\n',
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

local nodePersistentFreeStoragePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_persistent_storage_free{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Node persistent free storage',
  description: 'Persistent storage available for the selected node',
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

local nodeNetworkIngressPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_ingress_bytes{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Node network ingress',
  description: 'Rate of incoming network traffic to the selected node',
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

local nodeNetworkEgressPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_egress_bytes{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Node network egress',
  description: 'Rate of outgoing network traffic to the selected node.',
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

local nodeClientConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'node_conns{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{ node }}',
    ),
  ],
  type: 'timeseries',
  title: 'Node client connections',
  description: 'Number of client connections to each node.',
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

local redisLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename=~"/var/opt/redislabs/log/redis-.*.log", job=~"$job", redis_cluster=~"$redis_cluster"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Redis logs',
  description: 'Recent logs outputted from the Redis server.',
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
    'redis-enterprise-node-overview.json':
      dashboard.new(
        'Redis Enterprise node overview',
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
              'label_values(node_up, job)',
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
              'label_values(node_up, redis_cluster)',
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
              'label_values(node_up, node)\n',
              label='Node',
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
            nodesUpPanel { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
            databaseUpPanel { gridPos: { h: 6, w: 8, x: 8, y: 0 } },
            shardsUpPanel { gridPos: { h: 6, w: 8, x: 16, y: 0 } },
            nodeRequestsPanel { gridPos: { h: 6, w: 8, x: 0, y: 6 } },
            nodeAverageLatencyPanel { gridPos: { h: 6, w: 8, x: 8, y: 6 } },
            nodeCPUUtilizationPanel { gridPos: { h: 6, w: 8, x: 16, y: 6 } },
            nodeMemoryUtilizationPanel { gridPos: { h: 6, w: 8, x: 0, y: 12 } },
            nodeEphemeralFreeStoragePanel { gridPos: { h: 6, w: 8, x: 8, y: 12 } },
            nodePersistentFreeStoragePanel { gridPos: { h: 6, w: 8, x: 16, y: 12 } },
            nodeNetworkIngressPanel { gridPos: { h: 6, w: 8, x: 0, y: 18 } },
            nodeNetworkEgressPanel { gridPos: { h: 6, w: 8, x: 8, y: 18 } },
            nodeClientConnectionsPanel { gridPos: { h: 6, w: 8, x: 16, y: 18 } },
          ],
          if $._config.enableLokiLogs then [
            redisLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 24 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
