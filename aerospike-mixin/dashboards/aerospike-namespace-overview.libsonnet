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

local unavailablePartitionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'aerospike_namespace_unavailable_partitions{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{ns}}',
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

local diskUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 - aerospike_namespace_device_free_pct{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{ns}}',
    ),
  ],
  type: 'timeseries',
  title: 'Disk usage',
  description: 'Disk utilization in an Aerospike namespace.',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local deadPartitionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'aerospike_namespace_dead_partitions{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{ns}}',
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

local memoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 - aerospike_namespace_memory_free_pct{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{ns}}',
    ),
  ],
  type: 'timeseries',
  title: 'Memory usage',
  description: 'Memory utilization in an Aerospike namespace.',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local clientReadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_read_success{aerospike_cluster=~"$aerospike_cluster", job=~"$job", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - success',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_read_error{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_read_filtered_out{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_read_timeout{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - timeout',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_read_not_found{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - not found',
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
      unit: 'rps',
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
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_write_success{aerospike_cluster=~"$aerospike_cluster", job=~"$job", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - success',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_write_error{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_write_filtered_out{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_write_timeout{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - timeout',
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
      unit: 'wps',
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
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_udf_complete{aerospike_cluster=~"$aerospike_cluster", job=~"$job", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - complete',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_udf_error{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - error',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_udf_filtered_out{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - filtered',
    ),
    prometheus.target(
      'sum by(aerospike_cluster, job, instance, ns) (rate(aerospike_namespace_client_udf_timeout{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{ns}} - timeout',
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

local cacheReadUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'aerospike_namespace_cache_read_pct{job=~"$job", aerospike_cluster=~"$aerospike_cluster", instance=~"$instance", ns=~"$ns"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{ns}}',
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
            'label_values(aerospike_namespace_dead_partitions{%(multiclusterSelector)s}, cluster)' % $._config,
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
            'label_values(aerospike_namespace_ns_cluster_size{%(aerospikeSelector)s}, aerospike_cluster)' % $._config,
            label='Aerospike cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(aerospike_namespace_ns_cluster_size{%(aerospikeSelector)s, aerospike_cluster=~"$aerospike_cluster"}, instance)' % $._config,
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'ns',
            promDatasource,
            'label_values(aerospike_namespace_xmem_id{%(aerospikeSelector)s, instance=~"$instance"}, ns)' % $._config,
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
          unavailablePartitionsPanel { gridPos: { h: 8, w: 8, x: 0, y: 0 } },
          diskUsagePanel { gridPos: { h: 8, w: 16, x: 8, y: 0 } },
          deadPartitionsPanel { gridPos: { h: 8, w: 8, x: 0, y: 8 } },
          memoryUsagePanel { gridPos: { h: 8, w: 16, x: 8, y: 8 } },
          clientReadsPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          clientWritesPanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          clientUDFTransactionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
          cacheReadUtilizationPanel { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
        ]
      ),
  },
}
