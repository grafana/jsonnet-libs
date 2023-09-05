local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'mongodb-atlas-cluster-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local shardRow = {
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
  title: 'Shard',
  collapsed: false,
};

local shardNodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mongodb_network_bytesIn{job=~"$job",cl_name=~"$cl_name"}',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'table',
  title: 'Shard nodes',
  description: 'An inventory table for shard nodes in the environment.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'center',
        cellOptions: {
          type: 'auto',
        },
        filterable: false,
        inspect: false,
      },
      mappings: [
        {
          options: {
            '1': {
              index: 0,
              text: 'Primary',
            },
            '2': {
              index: 1,
              text: 'Secondary',
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
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'cl_role',
        },
        properties: [
          {
            id: 'custom.width',
            value: 150,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'rs_state',
        },
        properties: [
          {
            id: 'custom.width',
            value: 100,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'rs_nm',
        },
        properties: [
          {
            id: 'custom.width',
            value: 250,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'cl_name',
        },
        properties: [
          {
            id: 'custom.width',
            value: 300,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'group_id',
        },
        properties: [
          {
            id: 'custom.width',
            value: 300,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'State',
        },
        properties: [
          {
            id: 'custom.cellOptions',
            value: {
              type: 'color-text',
            },
          },
          {
            id: 'mappings',
            value: [
              {
                options: {
                  '1': {
                    color: 'green',
                    index: 0,
                    text: 'Primary',
                  },
                  '2': {
                    color: 'yellow',
                    index: 1,
                    text: 'Secondary',
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
      enablePagination: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '10.2.0-59981',
  transformations: [
    {
      id: 'reduce',
      options: {
        labelsToFields: true,
        reducers: [
          'lastNotNull',
        ],
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {
          Field: true,
          'Last *': true,
          __name__: true,
          job: true,
          org_id: true,
          process_port: true,
        },
        indexByName: {
          Field: 6,
          'Last *': 11,
          __name__: 7,
          cl_name: 1,
          cl_role: 2,
          group_id: 0,
          instance: 3,
          job: 8,
          org_id: 9,
          process_port: 10,
          rs_nm: 4,
          rs_state: 5,
        },
        renameByName: {
          cl_name: 'Cluster',
          cl_role: 'Role',
          group_id: 'Group',
          instance: 'Node',
          rs_nm: 'Replica set',
          rs_state: 'State',
        },
      },
    },
    {
      id: 'filterByValue',
      options: {
        filters: [
          {
            config: {
              id: 'equal',
              options: {
                value: 'shardsvr',
              },
            },
            fieldName: 'Role',
          },
        ],
        match: 'all',
        type: 'include',
      },
    },
  ],
};

local configRow = {
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
  title: 'Config',
  collapsed: false,
};

local configNodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mongodb_network_bytesIn{job=~"$job",cl_name=~"$cl_name"}',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'table',
  title: 'Config nodes',
  description: 'An inventory table for config nodes in the environment.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'center',
        cellOptions: {
          type: 'auto',
        },
        filterable: false,
        inspect: false,
      },
      mappings: [
        {
          options: {
            '1': {
              index: 0,
              text: 'Primary',
            },
            '2': {
              index: 1,
              text: 'Secondary',
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
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'cl_role',
        },
        properties: [
          {
            id: 'custom.width',
            value: 150,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'rs_state',
        },
        properties: [
          {
            id: 'custom.width',
            value: 100,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'rs_nm',
        },
        properties: [
          {
            id: 'custom.width',
            value: 250,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'cl_name',
        },
        properties: [
          {
            id: 'custom.width',
            value: 300,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'group_id',
        },
        properties: [
          {
            id: 'custom.width',
            value: 300,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'State',
        },
        properties: [
          {
            id: 'custom.cellOptions',
            value: {
              type: 'color-text',
            },
          },
          {
            id: 'mappings',
            value: [
              {
                options: {
                  '1': {
                    color: 'green',
                    index: 0,
                    text: 'Primary',
                  },
                  '2': {
                    color: 'yellow',
                    index: 1,
                    text: 'Secondary',
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
      enablePagination: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '10.2.0-59981',
  transformations: [
    {
      id: 'reduce',
      options: {
        labelsToFields: true,
        reducers: [
          'lastNotNull',
        ],
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {
          Field: true,
          'Last *': true,
          __name__: true,
          job: true,
          org_id: true,
          process_port: true,
        },
        indexByName: {
          Field: 6,
          'Last *': 11,
          __name__: 7,
          cl_name: 1,
          cl_role: 2,
          group_id: 0,
          instance: 3,
          job: 8,
          org_id: 9,
          process_port: 10,
          rs_nm: 4,
          rs_state: 5,
        },
        renameByName: {
          cl_name: 'Cluster',
          cl_role: 'Role',
          group_id: 'Group',
          instance: 'Node',
          rs_nm: 'Replica set',
          rs_state: 'State',
        },
      },
    },
    {
      id: 'filterByValue',
      options: {
        filters: [
          {
            config: {
              id: 'equal',
              options: {
                value: 'configsvr',
              },
            },
            fieldName: 'Role',
          },
        ],
        match: 'all',
        type: 'include',
      },
    },
  ],
};

local mongosRow = {
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
  title: 'mongos',
  collapsed: false,
};

local mongosNodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mongodb_network_bytesIn{job=~"$job",cl_name=~"$cl_name"}',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'table',
  title: 'mongos nodes',
  description: 'An inventory table for mongos nodes in the environment.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'center',
        cellOptions: {
          type: 'auto',
        },
        filterable: false,
        inspect: false,
      },
      mappings: [
        {
          options: {
            '1': {
              index: 0,
              text: 'Primary',
            },
            '2': {
              index: 1,
              text: 'Secondary',
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
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'cl_role',
        },
        properties: [
          {
            id: 'custom.width',
            value: 150,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'rs_state',
        },
        properties: [
          {
            id: 'custom.width',
            value: 100,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'rs_nm',
        },
        properties: [
          {
            id: 'custom.width',
            value: 250,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'cl_name',
        },
        properties: [
          {
            id: 'custom.width',
            value: 300,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'group_id',
        },
        properties: [
          {
            id: 'custom.width',
            value: 300,
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'md',
    footer: {
      countRows: false,
      enablePagination: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '10.2.0-59981',
  transformations: [
    {
      id: 'reduce',
      options: {
        labelsToFields: true,
        reducers: [
          'lastNotNull',
        ],
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {
          Field: true,
          'Last *': true,
          __name__: true,
          job: true,
          org_id: true,
          process_port: true,
          rs_state: true,
        },
        indexByName: {
          Field: 6,
          'Last *': 11,
          __name__: 7,
          cl_name: 1,
          cl_role: 2,
          group_id: 0,
          instance: 3,
          job: 8,
          org_id: 9,
          process_port: 10,
          rs_nm: 4,
          rs_state: 5,
        },
        renameByName: {
          cl_name: 'Cluster',
          cl_role: 'Role',
          group_id: 'Group',
          instance: 'Node',
          rs_nm: 'Replica set',
        },
      },
    },
    {
      id: 'filterByValue',
      options: {
        filters: [
          {
            config: {
              id: 'equal',
              options: {
                value: 'mongos',
              },
            },
            fieldName: 'Role',
          },
        ],
        match: 'all',
        type: 'include',
      },
    },
  ],
};

local performanceRow = {
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
  title: 'Performance',
  collapsed: false,
};

local hardwareIOPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (rate(hardware_disk_metrics_read_count{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - reads',
      format='time_series',
    ),
    prometheus.target(
      'sum (rate(hardware_disk_metrics_write_count{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - writes',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Hardware I/O',
  description: "The number of read and write I/O's processed.",
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
          },
        ],
      },
      unit: 'iops',
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

local hardwareIOWaitTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (increase(hardware_disk_metrics_read_time_milliseconds{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - read',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(hardware_disk_metrics_write_time_milliseconds{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - write',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Hardware I/O wait time / $__interval',
  description: 'The amount of time spent waiting for I/O requests.',
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

local hardwareCPUInterruptServiceTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (increase(hardware_system_cpu_irq_milliseconds{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Hardware CPU interrupt service time / $__interval',
  description: 'The amount of time spent servicing CPU interrupts.',
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

local memoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (mongodb_mem_resident{job=~"$job",cl_name=~"$cl_name"}) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - RAM',
      format='time_series',
    ),
    prometheus.target(
      'sum (mongodb_mem_virtual{job=~"$job",cl_name=~"$cl_name"}) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - virtual',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory',
  description: 'The amount of RAM and virtual memory being used.',
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

local diskSpaceUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '(sum (hardware_disk_metrics_disk_space_used_bytes{job=~"$job",cl_name=~"$cl_name"}) by(cl_name)) / (clamp_min(sum (hardware_disk_metrics_disk_space_free_bytes{job=~"$job",cl_name=~"$cl_name"}) by(cl_name) + sum (hardware_disk_metrics_disk_space_used_bytes{job=~"$job",cl_name=~"$cl_name"}) by(cl_name),0.1))',
      datasource=promDatasource,
      legendFormat='{{cl_name}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Disk space usage',
  description: 'The percentage of hardware space used.',
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
      max: 1,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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

local networkRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (rate(mongodb_network_numRequests{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Network requests',
  description: 'The number of distinct requests that the server has received.',
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

local networkBytesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (rate(mongodb_network_bytesIn{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - received',
      format='time_series',
    ),
    prometheus.target(
      'sum (rate(mongodb_network_bytesOut{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - sent',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Network bytes',
  description: 'The number of bytes sent and received over network connections.',
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
  transformations: [],
};

local slowRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (rate(mongodb_network_numSlowDNSOperations{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - DNS',
      format='time_series',
    ),
    prometheus.target(
      'sum (rate(mongodb_network_numSlowSSLOperations{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - SSL',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Slow requests',
  description: 'The rate of DNS and SSL operations that took longer than 1 second.',
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

local operationsRow = {
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
  title: 'Operations',
  collapsed: false,
};

local connectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (rate(mongodb_connections_totalCreated{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'The rate of incoming connections to the cluster created.',
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
      unit: 'conns/sec',
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

local readwriteOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (rate(mongodb_opLatencies_reads_ops{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - reads',
      format='time_series',
    ),
    prometheus.target(
      'sum (rate(mongodb_opLatencies_writes_ops{job=~"$job",cl_name=~"$cl_name"}[$__rate_interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - writes',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Read/Write operations',
  description: 'The number of read and write operations.',
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

local operationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (increase(mongodb_opcounters_insert{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - insert',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_opcounters_query{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - query',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_opcounters_update{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - update',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_opcounters_delete{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - delete',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'piechart',
  title: 'Operations',
  description: 'The number of insert, query, update, and delete operations.',
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    displayLabels: [],
    legend: {
      displayMode: 'table',
      placement: 'bottom',
      showLegend: false,
      values: [
        'value',
      ],
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

local readwriteLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (increase(mongodb_opLatencies_reads_latency{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - reads',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_opLatencies_writes_latency{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - writes',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Read/Write latency / $__interval',
  description: 'The latency for read and write operations.',
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

local locksRow = {
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
  title: 'Locks',
  collapsed: false,
};

local currentQueuePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (mongodb_globalLock_currentQueue_readers{job=~"$job",cl_name=~"$cl_name"}) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - reads',
      format='time_series',
    ),
    prometheus.target(
      'sum (mongodb_globalLock_currentQueue_writers{job=~"$job",cl_name=~"$cl_name"}) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - writes',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Current queue',
  description: 'The number of reads and writes queued because of a lock.',
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

local activeClientOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (mongodb_globalLock_activeClients_readers{job=~"$job",cl_name=~"$cl_name"}) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - reads',
      format='time_series',
    ),
    prometheus.target(
      'sum (mongodb_globalLock_activeClients_writers{job=~"$job",cl_name=~"$cl_name"}) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - writes',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Active client operations',
  description: 'The number of reads and writes being actively performed by connected clients.',
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

local databaseDeadlocksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (increase(mongodb_locks_Database_deadlockCount_W{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_locks_Database_deadlockCount_w{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - intent exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_locks_Database_deadlockCount_R{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - shared',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_locks_Database_deadlockCount_r{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - intent shared',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Database deadlocks / $__interval',
  description: 'The number of deadlocks for database level locks.',
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

local databaseWaitsAcquiringLockPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum (increase(mongodb_locks_Database_acquireWaitCount_W{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_locks_Database_acquireWaitCount_w{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - intent exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_locks_Database_acquireWaitCount_R{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - shared',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'sum (increase(mongodb_locks_Database_acquireWaitCount_r{job=~"$job",cl_name=~"$cl_name"}[$__interval:])) by (cl_name)',
      datasource=promDatasource,
      legendFormat='{{cl_name}} - intent shared',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Database waits acquiring lock / $__interval',
  description: 'The number of times lock acquisitions encounter waits for database level locks.',
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

{
  grafanaDashboards+:: {
    'mongodb-atlas-cluster-overview.json':
      dashboard.new(
        'MongoDB Atlas cluster overview',
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
            allValues='',
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
            allValues='',
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
          shardRow { gridPos: { h: 1, w: 24, x: 0, y: 0 } },
          shardNodesPanel { gridPos: { h: 6, w: 24, x: 0, y: 1 } },
          configRow { gridPos: { h: 1, w: 24, x: 0, y: 7 } },
          configNodesPanel { gridPos: { h: 6, w: 24, x: 0, y: 8 } },
          mongosRow { gridPos: { h: 1, w: 24, x: 0, y: 14 } },
          mongosNodesPanel { gridPos: { h: 6, w: 24, x: 0, y: 15 } },
          performanceRow { gridPos: { h: 1, w: 24, x: 0, y: 21 } },
          hardwareIOPanel { gridPos: { h: 6, w: 6, x: 0, y: 22 } },
          hardwareIOWaitTimePanel { gridPos: { h: 6, w: 6, x: 6, y: 22 } },
          hardwareCPUInterruptServiceTimePanel { gridPos: { h: 6, w: 6, x: 12, y: 22 } },
          memoryPanel { gridPos: { h: 6, w: 6, x: 18, y: 22 } },
          diskSpaceUsagePanel { gridPos: { h: 6, w: 6, x: 0, y: 28 } },
          networkRequestsPanel { gridPos: { h: 6, w: 6, x: 6, y: 28 } },
          networkBytesPanel { gridPos: { h: 6, w: 6, x: 12, y: 28 } },
          slowRequestsPanel { gridPos: { h: 6, w: 6, x: 18, y: 28 } },
          operationsRow { gridPos: { h: 1, w: 24, x: 0, y: 34 } },
          connectionsPanel { gridPos: { h: 6, w: 12, x: 0, y: 35 } },
          readwriteOperationsPanel { gridPos: { h: 12, w: 6, x: 12, y: 35 } },
          operationsPanel { gridPos: { h: 12, w: 6, x: 18, y: 35 } },
          readwriteLatencyPanel { gridPos: { h: 6, w: 12, x: 0, y: 41 } },
          locksRow { gridPos: { h: 1, w: 24, x: 0, y: 47 } },
          currentQueuePanel { gridPos: { h: 6, w: 12, x: 0, y: 48 } },
          activeClientOperationsPanel { gridPos: { h: 6, w: 12, x: 12, y: 48 } },
          databaseDeadlocksPanel { gridPos: { h: 6, w: 12, x: 0, y: 54 } },
          databaseWaitsAcquiringLockPanel { gridPos: { h: 6, w: 12, x: 12, y: 54 } },
        ]
      ),
  },
}
