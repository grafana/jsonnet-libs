local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-hbase-regionserver-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local regionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_region_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Regions',
  description: 'The number of regions hosted by the Region Server.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      decimals: 0,
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

local storeFilesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_store_file_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Store files',
  description: 'The number of store files on disk currently managed by the Region Server.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      decimals: 0,
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

local storeFileSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_store_file_size{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'bargauge',
  title: 'Store file size',
  description: 'The total size of the store files on disk managed by the Region Server.',
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
      unit: 'decbytes',
    },
    overrides: [],
  },
  options: {
    displayMode: 'gradient',
    minVizHeight: 10,
    minVizWidth: 0,
    namePlacement: 'auto',
    orientation: 'horizontal',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
    valueMode: 'color',
  },
  pluginVersion: '10.2.0-62263',
};

local rpcConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'region_server_num_open_connections{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'RPC connections',
  description: 'The number of open connections to the Region Server.',
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

local jvmHeapMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_metrics_mem_heap_used_m{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance", processname="RegionServer"} / clamp_min(jvm_metrics_mem_heap_committed_m{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance", processname="RegionServer"}, 1)',
      datasource=promDatasource,
      legendFormat='{{instance}} - heap',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'JVM heap memory usage',
  description: 'Heap memory usage for the JVM.',
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

local requestsReceivedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(server_total_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Requests received',
  description: 'The rate of requests received by the Region Server.',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local requestsOverviewPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(server_read_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - read',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_write_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - write',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_cp_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - cp',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_filtered_read_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - filtered read',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_rpc_get_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - rpc get',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_rpc_scan_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - rpc scan',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_rpc_full_scan_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - rpc full scan',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_rpc_mutate_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - rpc mutate',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_rpc_multi_request_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - rpc multi',
      format='time_series',
    ),
  ],
  type: 'piechart',
  title: 'Requests overview',
  description: 'Requests received by the Region Server, broken down by type.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
      },
      mappings: [],
      unit: 'reqps',
    },
    overrides: [],
  },
  options: {
    legend: {
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    pieType: 'pie',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local regionCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_region_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Region count',
  description: 'The number of regions hosted by the Region Server.',
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

local rpcConnectionCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'region_server_num_open_connections{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'RPC connection count',
  description: 'The number of open connections to the Region Server.',
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

local storeFileCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_store_file_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Store file count',
  description: 'The number of store files on disk currently managed by the Region Server.',
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

local storeFileSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_store_file_size{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Store file size',
  description: 'The total size of the store files on disk managed by the Region Server.',
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

local queuedCallsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'region_server_num_calls_in_general_queue{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - general',
      format='time_series',
    ),
    prometheus.target(
      'region_server_num_calls_in_replication_queue{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - replication',
      format='time_series',
    ),
    prometheus.target(
      'region_server_num_calls_in_read_queue{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - read',
      format='time_series',
    ),
    prometheus.target(
      'region_server_num_calls_in_write_queue{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - write',
      format='time_series',
    ),
    prometheus.target(
      'region_server_num_calls_in_scan_queue{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - scan',
      format='time_series',
    ),
    prometheus.target(
      'region_server_num_calls_in_priority_queue{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - priority',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Queued calls',
  description: 'The number of calls waiting to be processed by the Region Server.',
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

local slowOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(server_slow_append_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - append',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_slow_put_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - put',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_slow_delete_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - delete',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_slow_get_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - get',
      format='time_series',
    ),
    prometheus.target(
      'rate(server_slow_increment_count{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - increment',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Slow operations',
  description: 'The rate of operations that are slow, as determined by HBase.',
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
      unit: 'ops',
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

local cacheHitPercentagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'server_block_cache_express_hit_percent{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Cache hit percentage',
  description: 'The percent of time that requests hit the cache.',
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
      'rate(region_server_authentication_successes{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - success',
      format='time_series',
    ),
    prometheus.target(
      'rate(region_server_authentication_failures{job=~"$job", hbase_cluster=~"$hbase_cluster", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - failure',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Authentications',
  description: 'The rate of successful and unsuccessful authentications.',
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
      unit: 'reqps',
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

{
  grafanaDashboards+:: {
    'apache-hbase-regionserver-overview.json':
      dashboard.new(
        'Apache HBase RegionServer overview',
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
            allValues='.+',
            sort=0
          ),
          template.new(
            'hbase_cluster',
            promDatasource,
            'label_values(master_num_open_connections{job=~"$job"},hbase_cluster)',
            label='Apache HBase cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(server_region_count{job=~"$job", hbase_cluster=~"$hbase_cluster"},instance)',
            label='Instance',
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
          regionsPanel { gridPos: { h: 8, w: 6, x: 0, y: 0 } },
          storeFilesPanel { gridPos: { h: 8, w: 6, x: 6, y: 0 } },
          storeFileSizePanel { gridPos: { h: 8, w: 6, x: 12, y: 0 } },
          rpcConnectionsPanel { gridPos: { h: 8, w: 6, x: 18, y: 0 } },
          jvmHeapMemoryUsagePanel { gridPos: { h: 9, w: 24, x: 0, y: 8 } },
          requestsReceivedPanel { gridPos: { h: 8, w: 16, x: 0, y: 17 } },
          requestsOverviewPanel { gridPos: { h: 8, w: 8, x: 16, y: 17 } },
          regionCountPanel { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
          rpcConnectionCountPanel { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
          storeFileCountPanel { gridPos: { h: 8, w: 12, x: 0, y: 33 } },
          storeFileSizePanel { gridPos: { h: 8, w: 12, x: 12, y: 33 } },
          queuedCallsPanel { gridPos: { h: 8, w: 12, x: 0, y: 41 } },
          slowOperationsPanel { gridPos: { h: 8, w: 12, x: 12, y: 41 } },
          cacheHitPercentagePanel { gridPos: { h: 8, w: 12, x: 0, y: 49 } },
          authenticationsPanel { gridPos: { h: 8, w: 12, x: 12, y: 49 } },
        ]
      ),
  },
}
