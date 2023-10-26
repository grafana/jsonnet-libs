local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'presto-overview';

local promDatasourceName = 'prometheus_datasource';
local getMatcher(cfg) = '%(prestoOverviewSelector)s' % cfg;
local getLegendMatcher(cfg) = '%(prestoOverviewLegendSelector)s' % cfg;
local getAlertMatcher(cfg) = '%(prestoAlertSelector)s' % cfg;
local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local activeResourceManagersPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_metadata_DiscoveryNodeManager_ActiveResourceManagerCount{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Active resource managers',
  description: 'The number of active resource managers.',
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
            color: 'text',
            value: 0,
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
    textMode: 'auto',
  },
  pluginVersion: '10.2.0-62263',
};

local activeCoordinatorsPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_metadata_DiscoveryNodeManager_ActiveCoordinatorCount{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Active coordinators',
  description: 'Number of broker instances across clusters.',
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
    textMode: 'auto',
  },
  pluginVersion: '10.2.0-62263',
};

local activeWorkersPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_metadata_DiscoveryNodeManager_ActiveNodeCount{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Active workers',
  description: 'The number of active workers.',
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
    textMode: 'auto',
  },
  pluginVersion: '10.2.0-62263',
};

local inactiveWorkersPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_metadata_DiscoveryNodeManager_InactiveNodeCount{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Inactive workers',
  description: 'The number of inactive workers.',
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
            value: 3,
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
    textMode: 'auto',
  },
  pluginVersion: '10.2.0-62263',
};

local completedQueriesOneMinuteCountPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_QueryManager_CompletedQueries_OneMinute_Count{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Completed queries - one minute count',
  description: 'The number of completed queries.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: '#C8F2C2',
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'stepBefore',
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
      placement: 'bottom',
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
      format='time_series',
    ),
  ],
  type: 'alertlist',
  title: 'Alerts',
  description: 'Reports firing alerts.',
  options: {
    alertInstanceLabelFilter: '{' + matcher + ', presto_cluster=~"${presto_cluster:regex}"}',
    alertName: '',
    dashboardAlerts: false,
    datasource: 'Prometheus',
    groupBy: [],
    groupMode: 'default',
    maxItems: 20,
    sortOrder: 1,
    stateFilter: {
      'error': true,
      firing: true,
      noData: false,
      normal: true,
      pending: true,
    },
    viewMode: 'list',
  },
};

local userErrorFailuresOneMinuteRatePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_QueryManager_UserErrorFailures_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'User error failures - one minute rate',
  description: 'The rate of user error failures occurring across the clusters.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'stepBefore',
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
      unit: 'err/s',
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

local queuedQueriesPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_QueryManager_QueuedQueries{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Queued queries',
  description: 'The number of queued queries.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'bars',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local blockedNodesPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_ClusterMemoryPool_general_BlockedNodes{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Blocked nodes',
  description: 'The number of nodes that are blocked due to memory restrictions.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'stepBefore',
        lineWidth: 2,
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

local internalErrorFailuresOneMinuteRatePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_QueryManager_InternalFailures_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Internal error failures - one minute rate',
  description: 'The rate of internal failures occurring across the clusters.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'stepBefore',
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
      unit: 'err/s',
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

local clusterMemoryDistributedBytesPanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (presto_cluster) (presto_ClusterMemoryPool_general_FreeDistributedBytes{' + matcher + ', presto_cluster=~"$presto_cluster"})',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - free',
      format='time_series',
    ),
    prometheus.target(
      'sum by (presto_cluster) (presto_ClusterMemoryPool_reserved_FreeDistributedBytes{' + matcher + ', presto_cluster=~"$presto_cluster"})',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - reserved',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Cluster memory distributed bytes',
  description: 'The amount of memory available across the clusters.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
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
      unit: 'decbytes',
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

local InsufficientResourceFailuresOneMinuteRatePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_QueryManager_InsufficientResourcesFailures_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + '',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: ' Insufficient resource failures - one minute rate',
  description: 'The rate that failures are occurring due to insufficient resources.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'stepBefore',
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
      unit: 'err/s',
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

local inputoutputDataSizeOneMinuteRatePanel(legendMatcher, matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'presto_TaskManager_InputDataSize_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - input',
      format='time_series',
    ),
    prometheus.target(
      'presto_TaskManager_OutputDataSize_OneMinute_Rate{' + matcher + ', presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='' + legendMatcher + ' - output',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Input/Output data size - one minute rate',
  description: 'The rate at which volumes of data are being processed',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'stepBefore',
        lineWidth: 2,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

{
  grafanaDashboards+:: {
    'presto-overview.json':
      dashboard.new(
        'Presto overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Presto dashboards',
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
            'label_values(presto_HeartbeatDetector_ActiveCount,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(presto_HeartbeatDetector_ActiveCount{job=~"$job"}, cluster)',
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'presto_cluster',
            promDatasource,
            'label_values(presto_HeartbeatDetector_ActiveCount{job=~"$job"},presto_cluster)',
            label='Presto cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          activeResourceManagersPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 0, y: 0 } },
          activeCoordinatorsPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 6, y: 0 } },
          activeWorkersPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 12, y: 0 } },
          inactiveWorkersPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 18, y: 0 } },
          completedQueriesOneMinuteCountPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 4 } },
          alertsPanel(getAlertMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 4 } },
          userErrorFailuresOneMinuteRatePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 12 } },
          queuedQueriesPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 12 } },
          blockedNodesPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 20 } },
          internalErrorFailuresOneMinuteRatePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 20 } },
          clusterMemoryDistributedBytesPanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 28 } },
          InsufficientResourceFailuresOneMinuteRatePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 28 } },
          inputoutputDataSizeOneMinuteRatePanel(getLegendMatcher($._config), getMatcher($._config)) { gridPos: { h: 9, w: 24, x: 0, y: 36 } },
        ]
      ),
  },
}
