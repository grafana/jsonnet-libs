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

local keyspacesCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count by (keyspace) (cassandra_keyspace_writelatency_seconds{' + matcher + '}))',
      datasource=promDatasource,
    ),
  ],
  type: 'stat',
  title: 'Keyspaces count',
  description: 'The total count of the amount of keyspaces being reported.',
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
            value: 80,
          },
        ],
      },
    },
    overrides: [],
  },
  options: {
    colorMode: 'value',
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
  pluginVersion: '9.3.6',
};

local keyspaceTotalDiskSpaceUsedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_totaldiskspaceused{' + matcher + '}) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{keyspace}}',
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

local keyspacePendingCompactionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_pendingcompactions{' + matcher + '}) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{keyspace}}',
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

local keyspaceMaxPartitionSizePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max(cassandra_table_maxpartitionsize{' + matcher + '}) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{keyspace}}',
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
      'increase(sum(cassandra_keyspace_writelatency_seconds_count{' + matcher + '}) by (keyspace)[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{keyspace}}',
      format='time_series',
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
      'increase(sum(cassandra_keyspace_readlatency_seconds_count{' + matcher + '}) by (keyspace)[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{keyspace}}',
      format='time_series',
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

local repairJobsStartedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(sum(cassandra_keyspace_repairjobsstarted_count{' + matcher + '} >= 0) by (keyspace)[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{keyspace}} ',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Repair jobs started',
  description: 'The number of repair jobs started per keyspace.',
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

local repairJobsCompletedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(sum(cassandra_keyspace_repairjobscompleted_count{' + matcher + '}) by (keyspace)[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{keyspace}} ',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Repair jobs completed',
  description: 'The number of repair jobs that were completed.',
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
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.95"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p95',
      format='time_series',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_writelatency_seconds{' + matcher + ', quantile="0.99"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p99',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Keyspace write latency',
  description: 'The 95th and 99th percentils of local write latency for keyspaces',
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
        ],
      },
      unit: 's',
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
      sort: 'none',
    },
  },
};

local keyspaceReadLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.95"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p95',
      format='heatmap',
    ),
    prometheus.target(
      'sum(cassandra_keyspace_readlatency_seconds{' + matcher + ', quantile="0.99"} >= 0) by (keyspace)',
      datasource=promDatasource,
      legendFormat='{{ keyspace }} - p99',
      format='heatmap',
    ),
  ],
  type: 'timeseries',
  title: 'Keyspace read latency',
  description: 'Average local read latency for keyspaces',
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
      unit: 's',
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
      sort: 'none',
    },
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
        std.flattenArrays([
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
          if $._config.enableDatacenterLabel then [
            template.new(
              'datacenter',
              promDatasource,
              'label_values(cassandra_cache_size, datacenter)',
              label='Datacenter',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
          ] else [],
          if $._config.enableRackLabel then [
            template.new(
              'rack',
              promDatasource,
              'label_values(cassandra_cache_size, rack)',
              label='Rack',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
          ] else [],
        ])
      )
      .addPanels(
        [
          keyspacesCountPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
          keyspaceTotalDiskSpaceUsedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
          keyspacePendingCompactionsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          keyspaceMaxPartitionSizePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          writesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
          readsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
          repairJobsStartedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
          repairJobsCompletedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
          keyspaceWriteLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 24 } },
          keyspaceReadLatencyPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 24 } },
        ]
      ),
  },
}
