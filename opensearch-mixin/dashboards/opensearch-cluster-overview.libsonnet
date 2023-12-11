local g = (import '../g.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local prometheus = grafana.prometheus;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

local dashboardUidSuffix = '-cluster-overview';


{
  // variables
  local variables = (import '../variables.libsonnet').new(
    filteringSelector=$._config.filteringSelector,
    groupLabels=$._config.groupLabels,
    instanceLabels=[],
    varMetric='opensearch_cluster_status'
  ),

  local promDatasource = {
    uid: '${%s}' % variables.datasources.prometheus.name,
  },
  // panels
  local clusterStatusPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'min by(%(agg)s) (opensearch_cluster_status{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels)
      ),
    ],
    type: 'stat',
    title: 'Cluster status',
    description: 'The overall health and availability of the OpenSearch cluster.',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'thresholds',
        },
        mappings: [
          {
            options: {
              '0': {
                index: 0,
                text: 'Green',
              },
              '1': {
                index: 1,
                text: 'Yellow',
              },
              '2': {
                index: 2,
                text: 'Red',
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
            {
              color: 'green',
              value: 0,
            },
            {
              color: 'yellow',
              value: 1,
            },
            {
              color: 'red',
              value: 2,
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
    pluginVersion: '9.4.3',
  },

  local nodeCountPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'min by(%(agg)s) (opensearch_cluster_nodes_number{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels)
      ),
    ],
    type: 'stat',
    title: 'Node count',
    description: 'The number of running nodes across the OpenSearch cluster.',
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
    pluginVersion: '9.4.3',
  },

  local dataNodeCountPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'min by(%(agg)s) (opensearch_cluster_datanodes_number{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels)
      ),
    ],
    type: 'stat',
    title: 'Data node count',
    description: 'The number of data nodes in the OpenSearch cluster.',
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
    pluginVersion: '9.4.3',
  },

  local shardCountPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum(max by (type) (opensearch_cluster_shards_number{%(queriesSelector)s}))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels)
      ),
    ],
    type: 'stat',
    title: 'Shard count',
    description: 'The number of shards in the OpenSearch cluster across all indices.',
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
    pluginVersion: '9.4.3',
  },

  local activeShardsPercentagePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'min by(%(agg)s) (opensearch_cluster_shards_active_percent{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels)
      ),

    ],
    type: 'stat',
    title: 'Active shards %',
    description: 'Percent of active shards across the OpenSearch cluster.',
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
              value: 0,
            },
            {
              color: 'yellow',
              value: 1,
            },
            {
              color: 'green',
              value: 100,
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
      textMode: 'auto',
    },
    pluginVersion: '9.4.3',
  },

  local topNodesByCPUUsagePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'topk(10, sort_desc(sum by(node, %(agg)s) (opensearch_os_cpu_percent{%(queriesSelector)s})))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{node}}',
      ),
    ],
    type: 'bargauge',
    title: 'Top nodes by CPU usage',
    description: 'Top nodes by OS CPU usage across the OpenSearch cluster.',
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
      displayMode: 'gradient',
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
    pluginVersion: '9.4.3',
  },

  local breakersTrippedPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by(%(agg)s, node) (increase(opensearch_circuitbreaker_tripped_count{%(queriesSelector)s}[$__interval:]))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{node}}',
        interval='1m',
      ),
    ],
    type: 'bargauge',
    title: 'Breakers tripped',
    description: 'The total count of circuit breakers tripped across the OpenSearch cluster.',
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
              value: 80,
            },
          ],
        },
        unit: 'trips',
      },
      overrides: [],
    },
    options: {
      displayMode: 'gradient',
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
    pluginVersion: '9.4.3',
  },

  local shardStatusPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'min by(type, %(agg)s) (opensearch_cluster_shards_number{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{type}}',
      ),
    ],
    type: 'bargauge',
    title: 'Shard status',
    description: 'Shard status counts across the Opensearch cluster.',
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
              value: 80,
            },
          ],
        },
        unit: 'shards',
      },
      overrides: [],
    },
    options: {
      displayMode: 'gradient',
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
    pluginVersion: '9.4.3',
  },

  local topNodesByDiskUsagePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'topk(10, sort_desc((100 * (sum by(node, %(agg)s) (opensearch_fs_path_total_bytes{%(queriesSelector)s})- sum by(node, %(agg)s) (opensearch_fs_path_free_bytes{%(queriesSelector)s})) / sum by(node, %(agg)s) (opensearch_fs_path_total_bytes{%(queriesSelector)s}))))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{node}}',
      ),
    ],
    type: 'bargauge',
    title: 'Top nodes by disk usage',
    description: 'Top nodes by disk usage across the OpenSearch cluster.',
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
      displayMode: 'gradient',
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
    pluginVersion: '9.4.3',
  },

  local totalDocumentsPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'avg by(%(agg)s) (opensearch_indices_indexing_index_count{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels),
      ),
    ],
    type: 'timeseries',
    title: 'Total documents',
    description: 'The total count of documents indexed across the OpenSearch cluster.',
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
  },

  local pendingTasksPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'avg by(%(agg)s) (opensearch_cluster_pending_tasks_number{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels),
      ),
    ],
    type: 'timeseries',
    title: 'Pending tasks',
    description: 'The number of tasks waiting to be executed across the OpenSearch cluster.',
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
          ],
        },
        unit: 'tasks',
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
  },

  local storeSizePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'avg by(%(agg)s) (opensearch_indices_store_size_bytes{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels),
      ),
    ],
    type: 'timeseries',
    title: 'Store size',
    description: 'The total size of the store across the OpenSearch cluster.',
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
  },

  local maxTaskWaitTimePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'max by(%(agg)s) (opensearch_cluster_task_max_waiting_time_seconds{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.groupLabels),
      ),
    ],
    type: 'timeseries',
    title: 'Max task wait time',
    description: 'The max wait time for tasks to be executed across the OpenSearch cluster.',
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
  },

  local clusterSearchAndIndexSummaryRow = {
    datasource: promDatasource,
    targets: [],
    type: 'row',
    title: 'Cluster search and index summary',
    collapsed: false,
  },

  local topIndicesByRequestRatePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        |||
          topk(10, sort_desc(avg by(index, %(agg)s) (
            opensearch_index_search_fetch_current_number{%(queriesSelector)s, context="total"} + 
            opensearch_index_search_query_current_number{%(queriesSelector)s, context="total"} + 
            opensearch_index_search_scroll_current_number{%(queriesSelector)s, context="total"}
          )))
        |||
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{index}}',
      ),
    ],
    type: 'timeseries',
    title: 'Top indices by request rate',
    description: 'Top indices by combined fetch, query, and scroll request rate across the OpenSearch cluster.',
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
  },

  local topIndicesByRequestLatencyPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        |||
          topk(10, sort_desc(sum by(index, %(agg)s) ((increase(opensearch_index_search_fetch_time_seconds{%(queriesSelector)s, context="total"}[$__interval:])
          +increase(opensearch_index_search_query_time_seconds{%(queriesSelector)s, context="total"}[$__interval:])
          +increase(opensearch_index_search_scroll_time_seconds{%(queriesSelector)s, context="total"}[$__interval:]))
          / clamp_min(increase(opensearch_index_search_fetch_count{%(queriesSelector)s, context="total"}[$__interval:])
          +increase(opensearch_index_search_query_count{%(queriesSelector)s, context="total"}[$__interval:])
          +increase(opensearch_index_search_scroll_count{%(queriesSelector)s, context="total"}[$__interval:]), 1))))
        |||
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{index}}',
        interval='1m',
      ),
    ],
    type: 'timeseries',
    title: 'Top indices by request latency',
    description: 'Top indices by combined fetch, query, and scroll latency across the OpenSearch cluster.',
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
  },

  local topIndicesByCombinedCacheHitRatioPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        |||
          topk(10, sort_desc(avg by(index, %(agg)s) (
            100 * (opensearch_index_requestcache_hit_count{%(queriesSelector)s, context="total"} + 
            opensearch_index_querycache_hit_count{%(queriesSelector)s, context="total"}) / 
            clamp_min((opensearch_index_requestcache_hit_count{%(queriesSelector)s, context="total"} + 
            opensearch_index_querycache_hit_count{%(queriesSelector)s, context="total"} + 
            opensearch_index_requestcache_miss_count{%(queriesSelector)s, context="total"} + 
            opensearch_index_querycache_miss_number{%(queriesSelector)s, context="total"}), 1
            ))))
        |||
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{index}}',
      ),
    ],
    type: 'timeseries',
    title: 'Top indices by combined cache hit ratio',
    description: 'Top indices by cache hit ratio for the combined request and query cache across the OpenSearch cluster.',
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
  },

  local topNodesByIngestRatePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'topk(10, sum by(node, %(agg)s) (rate(opensearch_ingest_total_count{%(queriesSelector)s}[$__rate_interval])))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{node}}',
      ),
    ],
    type: 'timeseries',
    title: 'Top nodes by ingest rate',
    description: 'Top nodes by rate of ingest across the OpenSearch cluster.',
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
        unit: 'Bps',
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
  },

  local topNodesByIngestLatencyPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        |||
          topk(10, sum by(%(agg)s, node) (
            increase(opensearch_ingest_total_time_seconds{%(queriesSelector)s}[$__interval:]) / 
            clamp_min(increase(opensearch_ingest_total_count{%(queriesSelector)s}[$__interval:]), 1)))
        |||
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{node}}',
        interval='1m',
      ),
    ],
    type: 'timeseries',
    title: 'Top nodes by ingest latency',
    description: 'Top nodes by ingestion latency across the OpenSearch cluster.',
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
  },

  local topNodesByIngestErrorsPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'topk(10, sum by(%(agg)s, node) (increase(opensearch_ingest_total_failed_count{%(queriesSelector)s}[$__interval:])))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{node}}',
        interval='1m',
      ),
    ],
    type: 'timeseries',
    title: 'Top nodes by ingest errors',
    description: 'Top nodes by ingestion failures across the OpenSearch cluster.',
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
          ],
        },
        unit: 'errors',
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
  },

  local topIndicesByIndexRatePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'topk(10, avg by(%(agg)s, index) (opensearch_index_indexing_index_current_number{%(queriesSelector)s}))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{index}}',
      ),
    ],
    type: 'timeseries',
    title: 'Top indices by index rate',
    description: 'Top indices by rate of document indexing across the OpenSearch cluster.',
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
  },

  local topIndicesByIndexLatencyPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        |||
          topk(10, avg by(%(agg)s, index) 
          (increase(opensearch_index_indexing_index_time_seconds{%(queriesSelector)s, context="total"}[$__interval:]) / 
          clamp_min(increase(opensearch_index_indexing_index_count{%(queriesSelector)s, context="total"}[$__interval:]), 1)))
        |||
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{index}}',
        interval='1m',
      ),
    ],
    type: 'timeseries',
    title: 'Top indices by index latency',
    description: 'Top indices by indexing latency across the OpenSearch cluster.',
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
  },

  local topIndicesByIndexFailuresPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'topk(10, avg by(%(agg)s, index) (increase(opensearch_index_indexing_index_failed_count{%(queriesSelector)s}[$__interval:])))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels),
        },
        datasource=promDatasource,
        legendFormat='{{index}}',
        interval='1m',
      ),
    ],
    type: 'timeseries',
    title: 'Top indices by index failures',
    description: 'Top indices by index document failures across the OpenSearch cluster.',
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
  },

  grafanaDashboards+:: {
    'opensearch-cluster-overview.json':
      g.dashboard.new('OpenSearch cluster overview')
      + g.dashboard.withTags($._config.dashboardTags)
      + g.dashboard.time.withFrom($._config.dashboardPeriod)
      + g.dashboard.withTimezone($._config.dashboardTimezone)
      + g.dashboard.withRefresh($._config.dashboardRefresh)
      + g.dashboard.withUid($._config.uid + dashboardUidSuffix)
      + g.dashboard.link.dashboards.new(
        'Other Opensearch dashboards',
        $._config.dashboardTags
      )
      + g.dashboard.link.dashboards.options.withIncludeVars(true)
      + g.dashboard.link.dashboards.options.withKeepTime(true)
      + g.dashboard.link.dashboards.options.withAsDropdown(false)
      + g.dashboard.withPanels(
        [
          clusterStatusPanel { gridPos: { h: 4, w: 4, x: 0, y: 0 } },
          nodeCountPanel { gridPos: { h: 4, w: 5, x: 4, y: 0 } },
          dataNodeCountPanel { gridPos: { h: 4, w: 5, x: 9, y: 0 } },
          shardCountPanel { gridPos: { h: 4, w: 5, x: 14, y: 0 } },
          activeShardsPercentagePanel { gridPos: { h: 4, w: 5, x: 19, y: 0 } },
          topNodesByCPUUsagePanel { gridPos: { h: 9, w: 8, x: 0, y: 4 } },
          breakersTrippedPanel { gridPos: { h: 9, w: 8, x: 8, y: 4 } },
          shardStatusPanel { gridPos: { h: 9, w: 8, x: 16, y: 4 } },
          topNodesByDiskUsagePanel { gridPos: { h: 10, w: 8, x: 0, y: 13 } },
          totalDocumentsPanel { gridPos: { h: 5, w: 8, x: 8, y: 13 } },
          pendingTasksPanel { gridPos: { h: 5, w: 8, x: 16, y: 13 } },
          storeSizePanel { gridPos: { h: 5, w: 8, x: 8, y: 18 } },
          maxTaskWaitTimePanel { gridPos: { h: 5, w: 8, x: 16, y: 18 } },
          clusterSearchAndIndexSummaryRow { gridPos: { h: 1, w: 24, x: 0, y: 23 } },
          topIndicesByRequestRatePanel { gridPos: { h: 8, w: 8, x: 0, y: 24 } },
          topIndicesByRequestLatencyPanel { gridPos: { h: 8, w: 8, x: 8, y: 24 } },
          topIndicesByCombinedCacheHitRatioPanel { gridPos: { h: 8, w: 8, x: 16, y: 24 } },
          topNodesByIngestRatePanel { gridPos: { h: 8, w: 8, x: 0, y: 32 } },
          topNodesByIngestLatencyPanel { gridPos: { h: 8, w: 8, x: 8, y: 32 } },
          topNodesByIngestErrorsPanel { gridPos: { h: 8, w: 8, x: 16, y: 32 } },
          topIndicesByIndexRatePanel { gridPos: { h: 8, w: 8, x: 0, y: 40 } },
          topIndicesByIndexLatencyPanel { gridPos: { h: 8, w: 8, x: 8, y: 40 } },
          topIndicesByIndexFailuresPanel { gridPos: { h: 8, w: 8, x: 16, y: 40 } },
        ]
      )
      + g.dashboard.withVariables(variables.singleInstance),
  },
}
