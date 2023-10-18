local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'presto-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local activeResourceManagersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_metadata_DiscoveryNodeManager_ActiveResourceManagerCount{job=~"$job", presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Active resource managers',
  description: 'The number of active resource managers.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
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
    colorMode: 'none',
    graphMode: 'area',
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

local activeCoordinatorsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_metadata_DiscoveryNodeManager_ActiveCoordinatorCount{job=~"$job", presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Active coordinators',
  description: 'Number of broker instances across clusters.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
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
    colorMode: 'none',
    graphMode: 'area',
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

local activeWorkersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_metadata_DiscoveryNodeManager_ActiveNodeCount{job=~"$job", presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Active workers',
  description: 'The number of active workers.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
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
    colorMode: 'none',
    graphMode: 'area',
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

local inactiveWorkersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_metadata_DiscoveryNodeManager_InactiveNodeCount{job=~"$job", presto_cluster=~"$presto_cluster"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Inactive workers',
  description: 'The number of inactive workers.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
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
    colorMode: 'none',
    graphMode: 'area',
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

local completedQueries = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(com_facebook_presto_execution_QueryManager_CompletedQueries_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Completed queries / $__interval',
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
        drawStyle: 'bars',
        fillOpacity: 20,
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

local queuedQueries = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(com_facebook_presto_execution_QueryManager_QueuedQueries{job=~"$job", presto_cluster=~"$presto_cluster"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Queued queries / $__interval',
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
        fillOpacity: 20,
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

local userErrorFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_UserErrorFailures_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'User error failures',
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
        fillOpacity: 25,
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

local internalErrorFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_InternalFailures_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Internal error failures',
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
        fillOpacity: 25,
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

local alertsPanel = {
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
  description: 'Reports firing alerts.',
  options: {
    alertInstanceLabelFilter: '{job=~"${job:regex}", presto_cluster=~"${presto_cluster:regex}", instance=~"${instance:regex}"}',
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
      normal: false,
      pending: true,
    },
    viewMode: 'list',
  },
};

local InsufficientResourceFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_QueryManager_InsufficientResourcesFailures_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: ' Insufficient resource failures',
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
        fillOpacity: 25,
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
      unit: 'cps',
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

local blockedNodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'com_facebook_presto_memory_ClusterMemoryPool_BlockedNodes{job=~"$job", presto_cluster=~"$presto_cluster", name="general"}',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}}',
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
        fillOpacity: 25,
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

local distributedBytesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (presto_cluster) (com_facebook_presto_memory_ClusterMemoryPool_FreeDistributedBytes{job=~"$job", presto_cluster=~"$presto_cluster"})',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - free',
      format='time_series',
    ),
    prometheus.target(
      'sum by (presto_cluster) (com_facebook_presto_memory_ClusterMemoryPool_ReservedDistributedBytes{job=~"$job", presto_cluster=~"$presto_cluster"})',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - reserved',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Distributed bytes',
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
        fillOpacity: 25,
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

local dataThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(com_facebook_presto_execution_TaskManager_InputDataSize_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - input',
      format='time_series',
    ),
    prometheus.target(
      'rate(com_facebook_presto_execution_TaskManager_OutputDataSize_TotalCount{job=~"$job", presto_cluster=~"$presto_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{presto_cluster}} - output',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Data throughput',
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
        fillOpacity: 25,
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
            'label_values(com_facebook_presto_failureDetector_HeartbeatFailureDetector_ActiveCount,job)',
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
            'label_values(com_facebook_presto_failureDetector_HeartbeatFailureDetector_ActiveCount{job=~"$job", cluster=~"$cluster"},cluster)',
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            sort=0
          ),
          template.new(
            'presto_cluster',
            promDatasource,
            'label_values(com_facebook_presto_failureDetector_HeartbeatFailureDetector_ActiveCount{job=~"$job"},presto_cluster)',
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
          activeResourceManagersPanel { gridPos: { h: 4, w: 6, x: 0, y: 0 } },
          activeCoordinatorsPanel { gridPos: { h: 4, w: 6, x: 6, y: 0 } },
          activeWorkersPanel { gridPos: { h: 4, w: 6, x: 12, y: 0 } },
          inactiveWorkersPanel { gridPos: { h: 4, w: 6, x: 18, y: 0 } },
          completedQueries { gridPos: { h: 8, w: 12, x: 0, y: 4 } },
          queuedQueries { gridPos: { h: 8, w: 12, x: 12, y: 4 } },
          userErrorFailuresPanel { gridPos: { h: 8, w: 12, x: 0, y: 12 } },
          internalErrorFailuresPanel { gridPos: { h: 8, w: 12, x: 12, y: 12 } },
          alertsPanel { gridPos: { h: 8, w: 12, x: 0, y: 20 } },
          InsufficientResourceFailuresPanel { gridPos: { h: 8, w: 12, x: 12, y: 20 } },
          blockedNodesPanel { gridPos: { h: 8, w: 12, x: 0, y: 28 } },
          distributedBytesPanel { gridPos: { h: 8, w: 12, x: 12, y: 28 } },
          dataThroughputPanel { gridPos: { h: 9, w: 24, x: 0, y: 36 } },
        ]
      ),
  },
}
