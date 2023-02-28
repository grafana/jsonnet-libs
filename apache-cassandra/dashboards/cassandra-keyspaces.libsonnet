local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'cassandra-keyspaces';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local keyspacePendingCompactionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_keyspace_pendingcompactions{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{keyspace}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Keyspace pending compactions',
  description: 'The number of compaction operations a keyspace is pending to perform.',
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
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local keyspaceTotalDiskSpaceUsedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cassandra_keyspace_totaldiskspaceused{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{keyspace}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Keyspace total disk space used',
  description: 'Total amount of disk space used by keyspaces.',
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
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      unit: 'bytes',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local keyspaceMaxPartitionSizePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max(cassandra_table_maxpartitionsize{' + matcher + '}) by (instance, keyspace)',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{keyspace}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Keyspace max partition size',
  description: 'Max partition size for keyspaces.',
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
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local writesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cassandra_keyspace_writelatency_seconds_count{' + matcher + '}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{keyspace}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Writes',
  description: 'The number of writes performed on the keyspace.',
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
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local readsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cassandra_keyspace_readlatency_seconds_count{' + matcher + '}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{keyspace}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Reads',
  description: 'The number of reads performed on the keyspace.',
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
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local keyspaceWriteLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster", quantile="0.50"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p50',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster", quantile="0.75"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p75',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster", quantile="0.95"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p95',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster", quantile="0.99"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p99',
      format='time_series',
    ),
  ],
  type: 'barchart',
  title: 'Keyspace write latency',
  description: 'Average local write latency for keyspaces',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineWidth: 1,
        scaleDistribution: {
          type: 'linear',
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
      unit: 's',
    },
    overrides: [
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'A',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'red',
              mode: 'fixed',
            },
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'B',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'blue',
              mode: 'fixed',
            },
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'C',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'green',
              mode: 'fixed',
            },
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'D',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'purple',
              mode: 'fixed',
            },
          },
        ],
      },
    ],
  },
  options: {
    barRadius: 0,
    barWidth: 0.2,
    groupWidth: 0.7,
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    orientation: 'auto',
    showValue: 'always',
    stacking: 'normal',
    tooltip: {
      mode: 'multi',
      sort: 'asc',
    },
    xTickLabelRotation: 0,
    xTickLabelSpacing: -100,
  },
};

local keyspaceReadLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster", quantile="0.50"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p50',
      format='heatmap',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster", quantile="0.75"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p75',
      format='heatmap',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster", quantile="0.95"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p95',
      format='heatmap',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster", quantile="0.99"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p99',
      format='heatmap',
    ),
  ],
  type: 'barchart',
  title: 'Keyspace read latency',
  description: 'Average local read latency for keyspaces',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineWidth: 1,
        scaleDistribution: {
          type: 'linear',
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
      unit: 's',
    },
    overrides: [
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'A',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'red',
              mode: 'fixed',
            },
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'B',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'blue',
              mode: 'fixed',
            },
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'C',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'green',
              mode: 'fixed',
            },
          },
        ],
      },
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'D',
        },
        properties: [
          {
            id: 'color',
            value: {
              fixedColor: 'purple',
              mode: 'fixed',
            },
          },
        ],
      },
    ],
  },
  options: {
    barRadius: 0,
    barWidth: 0.2,
    groupWidth: 0.7,
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    orientation: 'auto',
    showValue: 'always',
    stacking: 'normal',
    tooltip: {
      mode: 'multi',
      sort: 'asc',
    },
    xTickLabelRotation: 0,
    xTickLabelSpacing: -100,
  },
};

local getMatcher(cfg) = 'job=~"$job", instance=~"$instance", keyspace=~"$keyspace", cluster=~"$cluster"' +
                        if cfg.enableDatacenterLabel then ', datacenter=~"$datacenter"' else '' + if cfg.enableRackLabel then ', rack=~"$rack"' else '';

{
  grafanaDashboards+:: {
    'cassandra-keyspaces.json':
      dashboard.new(
        'Apache Cassandra keyspaces',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache Cassandra dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates(
        std.flattenArrays(
          [
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
                'label_values(cassandra_up_endpoint_count, job)',
                label='Job',
                refresh=1,
                includeAll=true,
                multi=true,
                allValues='',
                sort=0
              ),
              template.new(
                'instance',
                promDatasource,
                'label_values(cassandra_up_endpoint_count, instance)',
                label='Instance',
                refresh=1,
                includeAll=true,
                multi=true,
                allValues='',
                sort=0
              ),
              template.new(
                'cluster',
                promDatasource,
                'label_values(cassandra_up_endpoint_count, cluster)',
                label='Cluster',
                refresh=1,
                includeAll=true,
                multi=true,
                allValues='',
                sort=0
              ),
              template.new(
                'keyspace',
                promDatasource,
                'label_values(cassandra_keyspace_caspreparelatency_seconds, keyspace)',
                label='Keyspace',
                refresh=1,
                includeAll=true,
                multi=true,
                allValues='',
                sort=0
              ),
            ],
            if $._config.enableDatacenterLabel then template.new(
              'datacenter',
              promDatasource,
              'label_values(cassandra_up_endpoint_count, datacenter)',
              label='Datacenter',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ) else [],
            if $._config.enableRackLabel then template.new(
              'rack',
              promDatasource,
              'label_values(cassandra_up_endpoint_count, rack)',
              label='Rack',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ) else [],
          ],
        )
      )
      .addPanels(
        [
          keyspacePendingCompactionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 0 } },
          keyspaceTotalDiskSpaceUsedPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          keyspaceMaxPartitionSizePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          writesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          readsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          keyspaceWriteLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
          keyspaceReadLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
        ]
      ),

  },
}
