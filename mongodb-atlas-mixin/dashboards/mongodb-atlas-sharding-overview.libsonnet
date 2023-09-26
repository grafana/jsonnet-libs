local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'mongodb-atlas-sharding-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local staleConfigsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_countStaleConfigErrors{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Stale configs / $__interval',
  description: 'Number of times that a thread hit a stale config exception and triggered a metadata refresh.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local chunkMigrationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_countRecipientMoveChunkStarted{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Chunk migrations / $__interval',
  description: 'Chunk migration frequency for this node.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local docsClonedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_countDocsClonedOnDonor{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - donor',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_shardingStatistics_countDocsClonedOnRecipient{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - recipient',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Docs cloned / $__interval',
  description: 'The number of documents cloned on this node when it acted as primary for the donor and acted as primary for the recipient.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local criticalSectionTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_totalCriticalSectionTimeMillis{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Critical section time / $__interval',
  description: 'The time taken by the catch-up and update metadata phases of a range migration, by this node.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local catalogCacheRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'row',
  title: 'Catalog cache',
  collapsed: false,
};

local refreshesStartedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_catalogCache_countIncrementalRefreshesStarted{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - incremental',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_shardingStatistics_catalogCache_countFullRefreshesStarted{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - full',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Refreshes started / $__interval',
  description: 'The number of incremental and full refreshes that have started.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local refreshesFailedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_catalogCache_countFailedRefreshes{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Refreshes failed / $__interval',
  description: 'The number of full and incremental refreshes that have failed.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local cacheStaleConfigsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_catalogCache_countStaleConfigErrors{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Cache stale configs / $__interval',
  description: 'The number of times that a thread hit a stale config exception for the catalog cache and triggered a metadata refresh.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local cacheEntriesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_catalogCache_numDatabaseEntries{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - database',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_shardingStatistics_catalogCache_numCollectionEntries{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - collection',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Cache entries / $__interval',
  description: 'The number of database and collection entries that are currently in the catalog cache.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local cacheRefreshTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_shardingStatistics_catalogCache_totalRefreshWaitTimeMicros{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Cache refresh time / $__interval',
  description: 'The amount of time that threads had to wait for a refresh of the metadata.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
          },
        ],
      },
      unit: 'µs',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local cacheOperationsBlockedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_shardingStatistics_catalogCache_operationsBlockedByRefresh_countAllOperations{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Cache operations blocked',
  description: 'The rate of operations that are blocked by a refresh of the catalog cache. Specific to mongos nodes found under replica set "none".',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local shardOperationsRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'row',
  title: 'Shard operations',
};

local allShardsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_find_allShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - find',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_insert_allShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - insert',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_update_allShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - update',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_delete_allShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - delete',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_aggregate_allShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - aggregate',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'All shards',
  description: 'The rate of CRUD operations and aggregation commands run that targeted all shards. Specific to mongos nodes found under replica set "none".',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local manyShardsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_find_manyShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - find',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_insert_manyShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - insert',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_update_manyShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - update',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_delete_manyShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - delete',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_aggregate_manyShards{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - aggregate',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Many shards',
  description: 'The rate of CRUD operations and aggregation commands run that targeted more than 1 shard. Specific to mongos nodes found under replica set "none".',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local oneShardPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_find_oneShard{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - find',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_insert_oneShard{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - insert',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_update_oneShard{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - update',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_delete_oneShard{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - delete',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_aggregate_oneShard{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - aggregate',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'One shard',
  description: 'The rate of CRUD operations and aggregation commands run that targeted 1 shard. Specific to mongos nodes found under replica set "none".',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local unshardedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_find_unsharded{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - find',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_insert_unsharded{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - insert',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_update_unsharded{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - update',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_delete_unsharded{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - delete',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_shardingStatistics_numHostsTargeted_aggregate_unsharded{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - aggregate',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Unsharded',
  description: 'The rate of CRUD operations and aggregation commands run on an unsharded collection. Specific to mongos nodes found under replica set "none".',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
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
  grafanaDashboards+::
    if $._config.enableShardingOverview then {
      'mongodb-atlas-sharding-overview.json':
        dashboard.new(
          'MongoDB Atlas sharding overview',
          time_from='%s' % $._config.dashboardPeriod,
          tags=($._config.dashboardTags),
          timezone='%s' % $._config.dashboardTimezone,
          refresh='%s' % $._config.dashboardRefresh,
          description='',
          uid=dashboardUid,
        )

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
              'label_values(mongodb_network_bytesIn,job)',
              label='Job',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'cl_name',
              promDatasource,
              'label_values(mongodb_network_bytesIn{job=~"$job"},cl_name)',
              label='Atlas cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'rs',
              promDatasource,
              'label_values(mongodb_network_bytesIn{cl_name=~"$cl_name"},rs_nm)',
              label='Replica set',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(mongodb_network_bytesIn{rs_nm=~"$rs"},instance)',
              label='Node',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
          ]
        )
        .addLink(grafana.link.dashboards(
          asDropdown=false,
          title='MongoDB Atlas dashboards',
          includeVars=true,
          keepTime=true,
          tags=($._config.dashboardTags),
        ))
        .addPanels(
          [
            staleConfigsPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
            chunkMigrationsPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
            docsClonedPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            criticalSectionTimePanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
            catalogCacheRow { gridPos: { h: 1, w: 24, x: 0, y: 16 } },
            refreshesStartedPanel { gridPos: { h: 8, w: 12, x: 0, y: 17 } },
            refreshesFailedPanel { gridPos: { h: 8, w: 12, x: 12, y: 17 } },
            cacheStaleConfigsPanel { gridPos: { h: 8, w: 6, x: 0, y: 25 } },
            cacheEntriesPanel { gridPos: { h: 8, w: 6, x: 6, y: 25 } },
            cacheRefreshTimePanel { gridPos: { h: 8, w: 6, x: 12, y: 25 } },
            cacheOperationsBlockedPanel { gridPos: { h: 8, w: 6, x: 18, y: 25 } },
            shardOperationsRow { gridPos: { h: 1, w: 24, x: 0, y: 33 } },
            allShardsPanel { gridPos: { h: 8, w: 12, x: 0, y: 34 } },
            manyShardsPanel { gridPos: { h: 8, w: 12, x: 12, y: 34 } },
            oneShardPanel { gridPos: { h: 8, w: 12, x: 0, y: 42 } },
            unshardedPanel { gridPos: { h: 8, w: 12, x: 12, y: 42 } },
          ]
        ),
    } else {},
}
