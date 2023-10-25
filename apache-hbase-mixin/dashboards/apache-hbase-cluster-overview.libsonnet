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

local masterStatusHistoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max without (clusterid,deadregionservers,liveregionservers,servername,zookeeperquorum,isactivemaster) (server_num_region_servers{job=~"$job", hbase_cluster=~"$hbase_cluster", isactivemaster="true"} * 0  + 1 )',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
    prometheus.target(
      '(max without (clusterid,deadregionservers,liveregionservers,servername,zookeeperquorum,isactivemaster) (server_num_region_servers{job=~"$job", hbase_cluster=~"$hbase_cluster", isactivemaster="false"}) * 0)',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'status-history',
  title: 'Master status history',
  description: 'Displays the current active and backup masters.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        fillOpacity: 70,
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineWidth: 1,
      },
      mappings: [
        {
          options: {
            '0': {
              color: 'yellow',
              index: 1,
              text: 'Backup',
            },
            '1': {
              color: 'blue',
              index: 0,
              text: 'Active',
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
          },
        ],
      },
    },
    overrides: [],
  },
  maxDataPoints: 100,
  options: {
    colWidth: 0.9,
    legend: {
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    rowHeight: 0.9,
    showValue: 'never',
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
  transformations: [],
};

local deadRegionServersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_num_dead_region_servers{job=~"$job", hbase_cluster=~"$hbase_cluster", isactivemaster="true"}',
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
  pluginVersion: '10.3.0-62488',
};

local liveRegionServersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_num_region_servers{job=~"$job", hbase_cluster=~"$hbase_cluster", isactivemaster="true"}',
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
  pluginVersion: '10.3.0-62488',
};

local serversPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'label_replace(server_num_region_servers{job=~"$job", hbase_cluster=~"$hbase_cluster"}, "master_instance", "$1", "instance", "(.+)")',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}}',
      format='table',
    ),
    prometheus.target(
      'label_replace(server_num_reference_files{job=~"$job", hbase_cluster=~"$hbase_cluster"}, "region_server_instance", "$1", "instance", "(.+)")',
      datasource=promDatasource,
      legendFormat='',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Servers',
  description: 'Servers for a cluster.',
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
          },
        ],
      },
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'RegionServer',
        },
        properties: [
          {
            id: 'links',
            value: [
              {
                title: '',
                url: '/d/apache-hbase-regionserver-overview?from=${__from}&to=${__to}&var-instance=${__data.fields["RegionServer"]}',
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
          options: 'Role',
        },
        properties: [
          {
            id: 'noValue',
            value: 'RegionServer',
          },
          {
            id: 'mappings',
            value: [
              {
                options: {
                  'false': {
                    index: 1,
                    text: 'backup master',
                  },
                  'true': {
                    color: 'text',
                    index: 0,
                    text: 'active master',
                  },
                },
                type: 'value',
              },
            ],
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
  pluginVersion: '10.3.0-62488',
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
          hbase_cluster: false,
          'hbase_cluster 1': true,
          'hbase_cluster 2': true,
          instance: true,
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
          Time: 5,
          'Value #A': 12,
          'Value #B': 13,
          __name__: 6,
          clusterid: 7,
          context: 8,
          hbase_cluster: 4,
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
          deadregionservers: 'Dead server',
          hbase_cluster: 'Cluster',
          hostname: 'Hostname',
          instance: 'Instance',
          'instance 1': '',
          isactivemaster: 'Role',
          'isactivemaster 1': 'Master',
          master_instance: 'Master',
          region_server_instance: 'RegionServer',
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
    alertInstanceLabelFilter: '',
    alertName: 'HighNonHeapMemUsage',
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
      'jvm_metrics_mem_heap_used_m{job=~"$job", hbase_cluster=~"$hbase_cluster", processname=~"Master"} / clamp_min(jvm_metrics_mem_heap_committed_m{job=~"$job", hbase_cluster=~"$hbase_cluster", processname=~"Master"}, 1)',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - {{instance}}',
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
      'sum by(job, hbase_cluster) (master_num_open_connections{job=~"$job", hbase_cluster=~"$hbase_cluster"})',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - masters',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (region_server_num_open_connections{job=~"$job", hbase_cluster=~"$hbase_cluster"})',
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
      decimals: 0,
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

local authenticationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, hbase_cluster) (rate(master_authentication_successes{job=~"$job", hbase_cluster=~"$hbase_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - masters success',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (rate(master_authentication_failures{job=~"$job", hbase_cluster=~"$hbase_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - masters failure',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (rate(region_server_authentication_successes{job=~"$job", hbase_cluster=~"$hbase_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - rs success',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (rate(region_server_authentication_failures{job=~"$job", hbase_cluster=~"$hbase_cluster"}[$__rate_interval]))',
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
      legendFormat='{{hbase_cluster}} - {{instance}}',
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
      'sum by(job, hbase_cluster) (master_num_calls_in_general_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"})',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - general',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (master_num_calls_in_replication_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"})',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - replication',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (master_num_calls_in_read_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"})',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - read',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (master_num_calls_in_write_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"})',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - write',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (master_num_calls_in_scan_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"})',
      datasource=promDatasource,
      legendFormat='{{hbase_cluster}} - scan',
      format='time_series',
    ),
    prometheus.target(
      'sum by(job, hbase_cluster) (master_num_calls_in_priority_queue{job=~"$job", hbase_cluster=~"$hbase_cluster"})',
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
      decimals: 0,
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
        title='Other Apache HBase Dashboards',
        includeVars=false,
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
          masterStatusHistoryPanel { gridPos: { h: 6, w: 24, x: 0, y: 0 } },
          deadRegionServersPanel { gridPos: { h: 8, w: 5, x: 0, y: 6 } },
          liveRegionServersPanel { gridPos: { h: 8, w: 5, x: 5, y: 6 } },
          serversPanel { gridPos: { h: 8, w: 14, x: 10, y: 6 } },
          alertsPanel { gridPos: { h: 8, w: 12, x: 0, y: 14 } },
          jvmMemoryUsagePanel { gridPos: { h: 8, w: 12, x: 12, y: 14 } },
          connectionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 22 } },
          authenticationsPanel { gridPos: { h: 8, w: 12, x: 12, y: 22 } },
          masterQueueSizePanel { gridPos: { h: 8, w: 12, x: 0, y: 30 } },
          masterQueuedCallsPanel { gridPos: { h: 8, w: 12, x: 12, y: 30 } },
          regionsInTransitionPanel { gridPos: { h: 8, w: 12, x: 0, y: 38 } },
          oldestRegionInTransitionPanel { gridPos: { h: 8, w: 12, x: 12, y: 38 } },
        ]
      ),
  },
}
