local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'aerospike-namespace-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local unavailablePartitionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'aerospike_namespace_unavailable_partitions{' + matcher + ', ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}}',
    ),
  ],
  type: 'bargauge',
  title: 'Unavailable partitions',
  description: 'Number of unavailable data partitions in an Aerospike namespace.',
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    displayMode: 'gradient',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'vertical',
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
};

local diskUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 - aerospike_namespace_device_free_pct{' + matcher + ', ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}}',
    ),
  ],
  type: 'timeseries',
  title: 'Disk usage',
  description: 'Disk utilization in an Aerospike namespace.',
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
        fillOpacity: 20,
        gradientMode: 'scheme',
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
      min: 0,
      max: 100,
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

local deadPartitionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'aerospike_namespace_dead_partitions{' + matcher + ', ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}}',
    ),
  ],
  type: 'bargauge',
  title: 'Dead partitions',
  description: 'Number of dead data partitions in an Aerospike namespace.',
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
};

local memoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 - aerospike_namespace_memory_free_pct{' + matcher + ', ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}}',
    ),
  ],
  type: 'timeseries',
  title: 'Memory usage',
  description: 'Memory utilization in an Aerospike namespace.',
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
        fillOpacity: 20,
        gradientMode: 'scheme',
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
      min: 0,
      max: 100,
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

local clientReadsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_read_success{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - success',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_read_error{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_read_filtered_out{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_read_timeout{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - timeout',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_read_not_found{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - not found',
    ),
  ],
  type: 'timeseries',
  title: 'Client reads',
  description: 'Rate of client read transactions in an Aerospike namespace organized by result.',
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
      unit: 'rps',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local clientWritesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_write_success{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - success',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_write_error{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_write_filtered_out{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_write_timeout{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - timeout',
    ),
  ],
  type: 'timeseries',
  title: 'Client writes',
  description: 'Rate of client write transactions in an Aerospike namespace organized by result.',
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
      unit: 'wps',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local clientUDFTransactionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_udf_complete{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - complete',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_udf_error{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_udf_filtered_out{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, ns) (rate(aerospike_namespace_client_udf_timeout{' + matcher + ', ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}} - timeout',
    ),
  ],
  type: 'timeseries',
  title: 'Client UDF transactions',
  description: 'Rate of client UDF transactions in an Aerospike namespace organized by result.',
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
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local cacheReadUtilizationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'aerospike_namespace_cache_read_pct{' + matcher + ', ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{aerospike_cluster}} - {{ns}}',
    ),
  ],
  type: 'timeseries',
  title: 'Cache read utilization',
  description: 'Percentage of read transactions that are resolved by a cache hit in an Aerospike namespace.',
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

local getMatcher(cfg) = '%(aerospikeSelector)s, aerospike_cluster=~"$aerospike_cluster"' % cfg;

{
  grafanaDashboards+:: {
    'aerospike-namespace-overview.json':
      dashboard.new(
        'Aerospike namespace overview',
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
            label='Data source',
            refresh='load'
          ),
          template.new(
            'job',
            promDatasource,
            'label_values(aerospike_namespace_ns_cluster_size,job)',
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
            'label_values(aerospike_namespace_dead_partitions{%(multiclusterSelector)s}, cluster)' % $._config,
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'aerospike_cluster',
            promDatasource,
            'label_values(aerospike_namespace_ns_cluster_size{%(aerospikeSelector)s}, aerospike_cluster)' % $._config,
            label='Aerospike cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'ns',
            promDatasource,
            'label_values(aerospike_namespace_xmem_id{%(aerospikeSelector)s}, ns)' % $._config,
            label='Namespace',
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
          unavailablePartitionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 0 } },
          diskUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 16, x: 8, y: 0 } },
          deadPartitionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 8 } },
          memoryUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 16, x: 8, y: 8 } },
          clientReadsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          clientWritesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          clientUDFTransactionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
          cacheReadUtilizationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
        ]
      ),
  },
}
