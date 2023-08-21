local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'aerospike-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local nodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, instance) (aerospike_namespace_ns_cluster_size{job=~"$job", aerospike_cluster=~"$aerospike_cluster"})',
      datasource=promDatasource,
      format='table',
    ),
  ],
  type: 'table',
  title: 'Nodes',
  description: 'Number of nodes in an Aerospike cluster.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'green',
        mode: 'fixed',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        filterable: false,
        inspect: false,
        minWidth: 50,
      },
      links: [],
      mappings: [],
      max: 256,
      min: 0,
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
          options: 'Value',
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
          options: 'instance',
        },
        properties: [
          {
            id: 'custom.filterable',
            value: true,
          },
          {
            id: 'links',
            value: [
              {
                title: 'Instance overview',
                url: '/d/aerospike-instance-overview',
              },
            ],
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'aerospike_cluster',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Aerospike cluster',
          },
        ],
      },
    ],
  },
  links: [
    {
      title: 'Instance overview',
      url: '/d/aerospike-instance-overview',
    },
  ],
  options: {
    cellHeight: 'md',
    footer: {
      countRows: false,
      enablePagination: false,
      fields: [],
      reducer: [
        'sum',
      ],
      show: false,
    },
    frameIndex: 0,
    showHeader: true,
  },
  pluginVersion: '10.2.0-59542pre',
  transformations: [
    {
      id: 'sortBy',
      options: {
        fields: {},
        sort: [
          {
            desc: true,
            field: 'Time',
          },
        ],
      },
    },
  ],
};

local namespacesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, instance, ns) (aerospike_namespace_ns_cluster_size{job=~"$job", aerospike_cluster=~"$aerospike_cluster"})',
      datasource=promDatasource,
      legendFormat='{{label_name}}',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Namespaces',
  description: 'Number of namespaces in an Aerospike cluster.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'green',
        mode: 'fixed',
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
      max: 32,
      min: 0,
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
          options: 'Value',
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
          options: 'instance',
        },
        properties: [
          {
            id: 'custom.filterable',
            value: true,
          },
          {
            id: 'links',
            value: [
              {
                title: 'Instance overview',
                url: '/d/aerospike-instance-overview',
              },
            ],
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'aerospike_cluster',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Aerospike cluster',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'ns',
        },
        properties: [
          {
            id: 'displayName',
            value: 'namespace',
          },
        ],
      },
    ],
  },
  links: [
    {
      title: 'Namespace overview',
      url: '/d/aerospike-namespace-overview',
    },
  ],
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
  pluginVersion: '10.2.0-59542pre',
  transformations: [
    {
      id: 'sortBy',
      options: {
        fields: {},
        sort: [
          {
            desc: true,
            field: 'Time',
          },
        ],
      },
    },
  ],
};

local unavailablePartitionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, aerospike_cluster) (aerospike_namespace_unavailable_partitions{job=~"$job", aerospike_cluster=~"$aerospike_cluster"})',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}}',
      format='time_series',
    ),
  ],
  type: 'bargauge',
  title: 'Unavailable partitions',
  description: 'Number of unavailable data partitions in an Aerospike cluster.',
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
        ],
      },
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    displayMode: 'gradient',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
    text: {
      valueSize: 100,
    },
    valueMode: 'color',
  },
  pluginVersion: '10.2.0-59542pre',
  transformations: [
    {
      id: 'sortBy',
      options: {
        fields: {},
        sort: [
          {
            desc: true,
            field: 'Time',
          },
        ],
      },
    },
  ],
};

local deadPartitionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, aerospike_cluster) (aerospike_namespace_dead_partitions{job=~"$job", aerospike_cluster=~"$aerospike_cluster"})',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}}',
    ),
  ],
  type: 'bargauge',
  title: 'Dead partitions',
  description: 'Number of dead data partitions in an Aerospike cluster.',
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
    displayMode: 'gradient',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
    text: {
      valueSize: 100,
    },
    valueMode: 'color',
  },
  pluginVersion: '10.2.0-59542pre',
  transformations: [
    {
      id: 'sortBy',
      options: {
        fields: {},
        sort: [
          {
            desc: true,
            field: 'Time',
          },
        ],
      },
    },
  ],
};

local topNodesByMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 - topk($k, sum by(aerospike_cluster, instance) (aerospike_node_stats_system_free_mem_pct{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}))',
      datasource=promDatasource,
      format='table',
    ),
  ],
  type: 'table',
  title: 'Top nodes by memory usage',
  description: 'Memory utilization for the top percentile of nodes in an Aerospike cluster.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'green',
        mode: 'fixed',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        inspect: false,
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
        ],
      },
      unit: 'percent',
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
          options: 'instance',
        },
        properties: [
          {
            id: 'custom.filterable',
            value: true,
          },
          {
            id: 'links',
            value: [
              {
                title: 'Instance overview',
                url: '/d/aerospike-instance-overview',
              },
            ],
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'aerospike_cluster',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Aerospike cluster',
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
            value: 'usage',
          },
        ],
      },
    ],
  },
  links: [
    {
      title: 'Instance overview',
      url: '/d/aerospike-instance-overview',
    },
  ],
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
  },
  pluginVersion: '10.2.0-59542pre',
  transformations: [
    {
      id: 'sortBy',
      options: {
        fields: {},
        sort: [
          {
            desc: true,
            field: 'Time',
          },
        ],
      },
    },
  ],
};

local topNodesByDiskUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 - topk($k, sum by(aerospike_cluster, instance) (aerospike_namespace_device_free_pct{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}))',
      datasource=promDatasource,
      format='table',
    ),
  ],
  type: 'table',
  title: 'Top nodes by disk usage',
  description: 'Disk utilization for the top percentile of nodes in an Aerospike cluster.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'green',
        mode: 'fixed',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        filterable: false,
        inspect: false,
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
        ],
      },
      unit: 'percent',
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
          options: 'instance',
        },
        properties: [
          {
            id: 'custom.filterable',
            value: true,
          },
          {
            id: 'links',
            value: [
              {
                title: 'Instance overview',
                url: '/d/aerospike-instance-overview',
              },
            ],
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'aerospike_cluster',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Aerospike cluster',
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
            value: 'usage',
          },
        ],
      },
    ],
  },
  links: [
    {
      title: 'Instance overview',
      url: '/d/aerospike-instance-overview',
    },
  ],
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
  },
  pluginVersion: '10.2.0-59542pre',
  transformations: [
    {
      id: 'sortBy',
      options: {
        fields: {},
        sort: [
          {
            desc: true,
            field: 'Time',
          },
        ],
      },
    },
  ],
};

local clientReadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_success{aerospike_cluster=~"$aerospike_cluster", job=~"$job"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - success',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_error{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_filtered_out{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_timeout{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - timeout',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_read_not_found{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - not found',
    ),
  ],
  type: 'timeseries',
  title: 'Client reads',
  description: 'Rate of client read transactions in an Aerospike cluster organized by result.',
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
        fillOpacity: 20,
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

local clientWritesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_write_success{aerospike_cluster=~"$aerospike_cluster", job=~"$job"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - success',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_write_error{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_write_filtered_out{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_write_timeout{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - timeout',
    ),
  ],
  type: 'timeseries',
  title: 'Client writes',
  description: 'Rate of client write transactions in an Aerospike cluster organized by result.',
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
        fillOpacity: 20,
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

local clientUDFTransactionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_udf_complete{aerospike_cluster=~"$aerospike_cluster", job=~"$job"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - complete',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_udf_error{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_udf_filtered_out{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (rate(aerospike_namespace_client_udf_timeout{job=~"$job", aerospike_cluster=~"$aerospike_cluster"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - timeout',
    ),
  ],
  type: 'timeseries',
  title: 'Client UDF transactions',
  description: 'Rate of client UDF transactions in an Aerospike cluster organized by result.',
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
        fillOpacity: 20,
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

local connectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, job) (aerospike_node_stats_client_connections{aerospike_cluster=~"$aerospike_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - client',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (aerospike_node_stats_fabric_connections{job=~"$job", aerospike_cluster=~"$aerospike_cluster"})',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - fabric',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job) (aerospike_node_stats_heartbeat_connections{job=~"$job", aerospike_cluster=~"$aerospike_cluster"})',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - heartbeat',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'Number of active connections to an Aerospike cluster.',
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
        fillOpacity: 20,
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
    'aerospike-overview.json':
      dashboard.new(
        'Aerospike overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Aerospike Dashboards',
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
            'label_values(aerospike_namespace_ns_cluster_size,job)',
            label='Job',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(aerospike_node_stats_system_free_mem_pct{%(multiclusterSelector)s}, cluster)' % $._config,
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'aerospike_cluster',
            promDatasource,
            'label_values(aerospike_namespace_ns_cluster_size{%(aerospikeSelector)s},aerospike_cluster)' % $._config,
            label='Aerospike cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'k',
            promDatasource,
            '5, 10, 20, 50',
            label='K',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          nodesPanel { gridPos: { h: 7, w: 7, x: 0, y: 0 } },
          namespacesPanel { gridPos: { h: 7, w: 7, x: 7, y: 0 } },
          unavailablePartitionsPanel { gridPos: { h: 7, w: 5, x: 14, y: 0 } },
          deadPartitionsPanel { gridPos: { h: 7, w: 5, x: 19, y: 0 } },
          topNodesByMemoryUsagePanel { gridPos: { h: 8, w: 12, x: 0, y: 7 } },
          topNodesByDiskUsagePanel { gridPos: { h: 8, w: 12, x: 12, y: 7 } },
          clientReadsPanel { gridPos: { h: 8, w: 12, x: 0, y: 15 } },
          clientWritesPanel { gridPos: { h: 8, w: 12, x: 12, y: 15 } },
          clientUDFTransactionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 23 } },
          connectionsPanel { gridPos: { h: 8, w: 12, x: 12, y: 23 } },
        ]
      ),
  },
}
