local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-solr-cluster-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local liveNodesPanel(matcher) = {
  datasource: {
    type: 'prometheus',
    uid: '${prometheus_datasource}',
  },
  description: 'Number of live nodes in the Solr cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
      min: 0,
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
      unit: 'none',
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
    textMode: 'value',
    wideLayout: true,
  },
  pluginVersion: '9.4.3',
  targets: [
    {
      disableTextWrap: false,
      expr: 'min by (job, solr_cluster) (solr_collections_live_nodes{' + matcher + '})',
      fullMetaSearch: false,
      includeNullMetadata: true,
      instant: false,
      legendFormat: '__auto',
      range: true,
      useBackend: false,
    },
  ],
  title: 'Live nodes',
  type: 'stat',
};

local zookeeperStatusPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'solr_zookeeper_status{' + matcher + '}',
      datasource=promDatasource,
      intervalFactor=2,
      instant=true,
      legendFormat='{{zk_host}}',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Zookeeper status',
  description: 'Status of ZooKeeper, integral for cluster coordination.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'color-text',
        },
        inspect: false,
      },
      mappings: [
        {
          options: {
            '0': {
              color: 'red',
              index: 1,
              text: 'Unavailable',
            },
            '1': {
              color: 'green',
              index: 0,
              text: 'Available',
            },
          },
          type: 'value',
        },
      ],
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
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'Time',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'job',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: '__name__',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'status',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'solr_cluster',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Solr cluster',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'zk_host',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Zookeeper host',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Value',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Status',
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: [],
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '9.4.3',
};

local zookeeperEnsembleSizePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'solr_zookeeper_ensemble_size{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{zk_host}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Zookeeper ensemble size',
  description: 'Size of the ZooKeeper ensemble.',
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
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local alertsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'alertlist',
  title: 'Alerts',
  description: 'Panel to report on the status of firing alerts.',
  options: {
    alertInstanceLabelFilter: '{' + matcher + '}',
    alertName: '',
    dashboardAlerts: false,
    groupBy: [],
    groupMode: 'default',
    maxItems: 20,
    sortOrder: 1,
    stateFilter: {
      'error': true,
      firing: true,
      noData: false,
      normal: false,
      pending: true,
    },
    viewMode: 'list',
  },
};

local shardStatePanel(matcher) = {
  datasource: {
    type: 'prometheus',
    uid: '${prometheus_datasource}',
  },
  description: 'Percent of running shards in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
      max: 100,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'red',
            value: null,
          },
          {
            color: 'yellow',
            value: 80,
          },
          {
            color: 'green',
            value: 95,
          },
        ],
      },
      unit: 'percent',
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
    textMode: 'value',
    wideLayout: true,
  },
  pluginVersion: '9.4.3',
  targets: [
    {
      disableTextWrap: false,
      expr: '100 * sum(solr_collections_shard_state{' + matcher + '})  / count(solr_collections_shard_state{' + matcher + '})',
      fullMetaSearch: false,
      includeNullMetadata: true,
      instant: false,
      legendFormat: '__auto',
      range: true,
      useBackend: false,
    },
  ],
  title: 'Running shards',
  type: 'stat',
};

local shardStatusPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'solr_collections_shard_state{' + matcher + '}',
      datasource=promDatasource,
      intervalFactor=2,
      instant=true,
      legendFormat='{{auto}}',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Shard status',
  description: 'Shows the state of various shards in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'color-text',
        },
        inspect: false,
      },
      mappings: [
        {
          options: {
            '0': {
              color: 'red',
              index: 1,
              text: 'Unavailable',
            },
            '1': {
              color: 'green',
              index: 0,
              text: 'Available',
            },
          },
          type: 'value',
        },
      ],
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
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'Time',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'job',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: '__name__',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'solr_cluster',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'zk_host',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Value',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Status',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'instance',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Instance',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'shard',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Shard',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'collection',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Collection',
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: [],
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '9.4.3',
};

local replicaStatePanel(matcher) = {
  datasource: {
    type: 'prometheus',
    uid: '${prometheus_datasource}',
  },
  description: 'Shows the total percent of running shards in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
      max: 100,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'red',
            value: null,
          },
          {
            color: 'yellow',
            value: 80,
          },
          {
            color: 'green',
            value: 95,
          },
        ],
      },
      unit: 'percent',
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
    textMode: 'value',
    wideLayout: true,
  },
  pluginVersion: '9.4.3',
  targets: [
    {
      disableTextWrap: false,
      expr: '100 * sum(solr_collections_replica_state{' + matcher + '})  / count(solr_collections_replica_state{' + matcher + '})',
      fullMetaSearch: false,
      includeNullMetadata: true,
      instant: false,
      legendFormat: '__auto',
      range: true,
      useBackend: false,
    },
  ],
  title: 'Running replicas',
  type: 'stat',
};

local replicaStatusPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'solr_collections_replica_state{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{auto}}',
      instant=true,
      intervalFactor=2,
      format='table',
    ),
  ],
  type: 'table',
  title: 'Replica status',
  description: 'State of replicas within a Solr collection.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'color-text',
        },
        inspect: false,
      },
      mappings: [
        {
          options: {
            '0': {
              color: 'red',
              index: 1,
              text: 'Unavailable',
            },
            '1': {
              color: 'green',
              index: 0,
              text: 'Available',
            },
          },
          type: 'value',
        },
      ],
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
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'Time',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'job',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: '__name__',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'solr_cluster',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'collection',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'shard',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'replica',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'base_url',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'node_name',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'type',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'state',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'zk_host',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Value',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Status',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'core',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Core',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'instance',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Instance',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'replica_name',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Replica name',
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: [],
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '9.4.3',
};

local topNodeMetricsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Top metrics',
  collapsed: false,
};

local topCPULoadByNodePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, 100 * avg by (job, base_url, solr_cluster) (solr_metrics_jvm_os_cpu_load{' + matcher + ', item="systemCpuLoad"}))',
      datasource=promDatasource,
      legendFormat='{{base_url}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Top nodes by CPU load',
  description: 'Top nodes by CPU load caused by the JVM.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlYlRd',
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
            color: 'blue',
          },
          {
            color: 'yellow',
            value: 90,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topHeapMemoryUsageByNodePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, 100 * avg by (job, base_url, solr_cluster) (sum without(item)(solr_metrics_jvm_memory_heap_bytes{' + matcher + ', item="used"}) / clamp_min(sum without(item)(solr_metrics_jvm_memory_heap_bytes{' + matcher + ', item="max"}), 1)))',
      datasource=promDatasource,
      legendFormat='{{base_url}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Top nodes by heap memory usage',
  description: 'Top nodes by the JVM heap memory usage.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlYlRd',
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
            color: 'blue',
          },
          {
            color: 'yellow',
            value: 90,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topMeanQueriesByNodePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, avg by(job, base_url, solr_cluster, collection, core, searchHandler) (solr_metrics_core_query_mean_rate{' + matcher + ', category="QUERY", collection=~"$solr_collection", core=~"$solr_core"}))',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{searchHandler}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Top cores by mean queries',
  description: 'Top cores by the average rate of query processing in the cluster.',
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
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topUpdateHandlersByNodePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, avg by (job, base_url, solr_cluster, collection, core) (increase(solr_metrics_core_update_handler_adds_total{' + matcher + ', collection=~"$solr_collection", core=~"$solr_core"}[$__interval:])))',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Top cores by update handlers / $__interval',
  description: 'Top cores by the number of total document additions in the cluster.',
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
      unit: 'documents',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topIndexSizeByNodePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, avg by (job, base_url, solr_cluster, collection, core) (solr_metrics_core_index_size_bytes{' + matcher + ', collection=~"$solr_collection", core=~"$solr_core"}))',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Top cores by index size',
  description: 'Top cores by the Solr index size.',
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
      unit: 'bytes',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topCacheHitRatioByNodePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bottomk($k, 100 * avg by (job, base_url, solr_cluster, collection, core, type) (solr_metrics_core_searcher_cache_ratio{' + matcher + ', collection=~"$solr_collection", core=~"$solr_core", type=~"documentCache|filterCache|queryResultCache"}))',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}} - {{type}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Top cores by cache hit ratio',
  description: 'Top cores by the cache hit ratio in Solr searchers.',
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
            color: 'yellow',
            value: 90,
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

local topCoreErrorsByNodePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, avg by (job, solr_cluster, collection, core, baseurl) (increase(solr_metrics_core_errors_total{' + matcher + ', collection=~"$solr_collection", core=~"$solr_core"}[$__interval:])))',
      datasource=promDatasource,
      legendFormat='{{collection}} - {{core}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Top cores by core errors / $__interval',
  description: 'Top cores by Solr core errors.',
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
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topNodeErrorsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, avg by (job, base_url, solr_cluster, collection) (increase(solr_metrics_node_errors_total{' + matcher + '}[$__interval:])))',
      datasource=promDatasource,
      legendFormat='{{base_url}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Top nodes by node errors / $__interval',
  description: 'Top nodes by Solr node errors.',
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
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local getMatcher(cfg) = '%(solrSelector)s, solr_cluster=~"$solr_cluster"' % cfg;

{
  grafanaDashboards+:: {
    'apache-solr-cluster-overview.json':
      dashboard.new(
        'Apache Solr cluster overview',
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
          template.custom(
            'k',
            query='5,10,20,50',
            current='5',
            label='Top node count',
            refresh='never',
            includeAll=false,
            multi=false,
            allValues='',
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
          liveNodesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 0, y: 0 } },
          zookeeperStatusPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 6, y: 0 } },
          zookeeperEnsembleSizePanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 12, y: 0 } },
          alertsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 18, y: 0 } },
          shardStatePanel(getMatcher($._config)) { gridPos: { h: 6, w: 4, x: 0, y: 6 } },
          shardStatusPanel(getMatcher($._config)) { gridPos: { h: 6, w: 8, x: 4, y: 6 } },
          replicaStatePanel(getMatcher($._config)) { gridPos: { h: 6, w: 4, x: 12, y: 6 } },
          replicaStatusPanel(getMatcher($._config)) { gridPos: { h: 6, w: 8, x: 16, y: 6 } },
          topNodeMetricsRow { gridPos: { h: 1, w: 24, x: 0, y: 12 } },
          topCPULoadByNodePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 13 } },
          topHeapMemoryUsageByNodePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 13 } },
          topMeanQueriesByNodePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 19 } },
          topUpdateHandlersByNodePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 19 } },
          topIndexSizeByNodePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
          topCacheHitRatioByNodePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
          errorsRow { gridPos: { h: 1, w: 24, x: 0, y: 31 } },
          topCoreErrorsByNodePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 32 } },
          topNodeErrorsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 32 } },
        ]
      ),
  },
}
