local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-hbase-cluster-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local deadRegionServersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_num_dead_region_servers{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Dead RegionServers',
  description: 'Number of RegionServers that are currently dead.',
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
    textMode: 'value',
  },
  pluginVersion: '10.2.0-61719',
};

local liveRegionServersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_num_region_servers{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Live RegionServers',
  description: 'Number of RegionServers that are currently live.',
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
  },
  pluginVersion: '10.2.0-61719',
};

local regionserversPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_num_region_servers{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}}',
      format='table',
    ),
    prometheus.target(
      'server_num_reference_files{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      format='table',
    ),
  ],
  type: 'table',
  title: 'RegionServers',
  description: 'RegionServers for a cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        inspect: false,
      },
      links: [],
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
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'Instance',
        },
        properties: [
          {
            id: 'links',
            value: [
              {
                title: '',
                url: '/d/apache-hbase-regionserver-overview',
              },
            ],
          },
          {
            id: 'mappings',
            value: [],
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Is master',
        },
        properties: [
          {
            id: 'noValue',
            value: 'false',
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'md',
    footer: {
      countRows: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
    sortBy: [],
  },
  pluginVersion: '10.2.0-61719',
  transformations: [
    {
      id: 'merge',
      options: {},
    },
    {
      id: 'organize',
      options: {
        excludeByName: {
          Time: true,
          'Time 1': true,
          'Time 2': true,
          Value: true,
          'Value #A': true,
          'Value #B': true,
          __name__: true,
          '__name__ 1': true,
          '__name__ 2': true,
          clusterid: true,
          'clusterid 1': true,
          'clusterid 2': true,
          context: true,
          'context 1': true,
          'context 2': true,
          hbase_cluster: true,
          'hbase_cluster 1': true,
          'hbase_cluster 2': true,
          instance: false,
          'instance 1': false,
          'instance 2': true,
          isactivemaster: false,
          'isactivemaster 1': false,
          'isactivemaster 2': true,
          job: true,
          'job 1': true,
          'job 2': true,
          liveregionservers: true,
          'liveregionservers 1': true,
          'liveregionservers 2': true,
          servername: false,
          'servername 1': false,
          'servername 2': true,
          zookeeperquorum: true,
          'zookeeperquorum 1': true,
          'zookeeperquorum 2': true,
        },
        indexByName: {
          Time: 4,
          'Value #A': 12,
          'Value #B': 13,
          __name__: 5,
          clusterid: 7,
          context: 8,
          hbase_cluster: 6,
          hostname: 1,
          instance: 2,
          isactivemaster: 3,
          job: 9,
          liveregionservers: 10,
          servername: 0,
          zookeeperquorum: 11,
        },
        renameByName: {
          Time: '',
          deadregionservers: 'Dead server name',
          hostname: 'Hostname',
          instance: 'Instance',
          'instance 1': '',
          isactivemaster: 'Is master',
          'isactivemaster 1': 'Master',
          servername: 'Servername',
          'servername 1': 'Servername',
        },
      },
    },
  ],
};

local alertsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'master_num_open_connections{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}}',
      format='time_series',
    ),
  ],
  type: 'alertlist',
  title: 'Alerts',
  description: 'Panel to report on the status of integration alerts.',
  options: {
    alertInstanceLabelFilter: '{job="integrations/apache-hbase"}',
    alertName: '',
    dashboardAlerts: false,
    folder: '',
    groupBy: [],
    groupMode: 'default',
    maxItems: 20,
    sortOrder: 1,
    stateFilter: {
      'error': true,
      firing: true,
      noData: true,
      normal: true,
      pending: true,
    },
    viewMode: 'list',
  },
};

local jvmMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_metrics_mem_non_heap_used_m{job=~"$job", hbase_cluster=~"$hbase_cluster", processname=~"Master"} / clamp_min(jvm_metrics_mem_non_heap_committed_m{job=~"$job", hbase_cluster=~"$hbase_cluster", processname=~"Master"}, 1)',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - non-heap',
      format='time_series',
    ),
    prometheus.target(
      'jvm_metrics_mem_heap_used_m{job=~"$job", hbase_cluster=~"$hbase_cluster", processname=~"Master"} / clamp_min(jvm_metrics_mem_heap_committed_m{job=~"$job", hbase_cluster=~"$hbase_cluster", processname=~"Master"}, 1)',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - heap',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'JVM memory usage',
  description: 'Memory usage for the JVM.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlYlRd',
      },
      custom: {
        axisBorderShow: false,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local connectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'master_num_open_connections{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - master',
      format='time_series',
    ),
    prometheus.target(
      'region_server_num_open_connections{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - RegionServers',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'Number of open connections to the cluster.',
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
        fillOpacity: 30,
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

local authenticationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(master_authentication_successes{job=~"$job", hbase_cluster=~"$hbase_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - master success',
      format='time_series',
    ),
    prometheus.target(
      'rate(master_authentication_failures{job=~"$job", hbase_cluster=~"$hbase_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - master failure',
      format='time_series',
    ),
    prometheus.target(
      'rate(region_server_authentication_successes{job=~"$job", hbase_cluster=~"$hbase_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - rs success',
      format='time_series',
    ),
    prometheus.target(
      'rate(region_server_authentication_failures{job=~"$job", hbase_cluster=~"$hbase_cluster"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - rs failure',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Authentications',
  description: 'Volume of successful and unsuccessful authentications.',
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
        fillOpacity: 30,
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
      calcs: [
        'min',
        'mean',
        'max',
      ],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local masterQueueSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'master_queue_size{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Master queue size',
  description: 'The size of the queue of requests, operations, and tasks to be processed by the master.',
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
        fillOpacity: 30,
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
          {
            color: 'red',
            value: 80,
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

local masterQueuedCallsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'master_num_calls_in_general_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - general',
      format='time_series',
    ),
    prometheus.target(
      'master_num_calls_in_replication_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - replication',
      format='time_series',
    ),
    prometheus.target(
      'master_num_calls_in_read_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - read',
      format='time_series',
    ),
    prometheus.target(
      'master_num_calls_in_write_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - write',
      format='time_series',
    ),
    prometheus.target(
      'master_num_calls_in_scan_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - scan',
      format='time_series',
    ),
    prometheus.target(
      'master_num_calls_in_priority_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - priority',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Master queued calls',
  description: 'The number of calls waiting to be processed by the master.',
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
        fillOpacity: 30,
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
      calcs: [
        'min',
        'mean',
        'max',
      ],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local regionsInTransitionPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'assignment_manager_rit_count{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}}',
      format='time_series',
    ),
    prometheus.target(
      'assignment_manager_rit_count_over_threshold{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - old',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Regions in transition',
  description: 'The number of regions in transition for the cluster.',
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
        fillOpacity: 30,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local oldestRegionInTransitionPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'assignment_manager_rit_oldest_age{job=~"$job", hbase_cluster=~"$hbase_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Oldest region in transition',
  description: 'The age of the longest region in transition for the master of the cluster.',
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
        fillOpacity: 30,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

{
  grafanaDashboards+:: {
    'apache-hbase-cluster-overview.json':
      dashboard.new(
        'Apache HBase cluster overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache HBase dashboards',
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
            'label_values(master_num_open_connections,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'hbase_cluster',
            promDatasource,
            'label_values(master_num_open_connections{job=~"$job"},hbase_cluster)',
            label='HBase cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          deadRegionServersPanel { gridPos: { h: 8, w: 3, x: 0, y: 0 } },
          liveRegionServersPanel { gridPos: { h: 8, w: 3, x: 3, y: 0 } },
          regionserversPanel { gridPos: { h: 8, w: 9, x: 6, y: 0 } },
          alertsPanel { gridPos: { h: 8, w: 9, x: 15, y: 0 } },
          jvmMemoryUsagePanel { gridPos: { h: 9, w: 24, x: 0, y: 8 } },
          connectionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 17 } },
          authenticationsPanel { gridPos: { h: 8, w: 12, x: 12, y: 17 } },
          masterQueueSizePanel { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
          masterQueuedCallsPanel { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
          regionsInTransitionPanel { gridPos: { h: 8, w: 12, x: 0, y: 33 } },
          oldestRegionInTransitionPanel { gridPos: { h: 8, w: 12, x: 12, y: 33 } },
        ]
      ),
  },
}
