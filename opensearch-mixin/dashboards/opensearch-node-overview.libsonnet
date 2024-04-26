local g = (import '../g.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
local prometheus = grafana.prometheus;

local dashboardUidSuffix = '-node-overview';

{

  // variables
  local variables = (import '../variables.libsonnet').new(
    filteringSelector=$._config.filteringSelector,
    groupLabels=$._config.groupLabels,
    instanceLabels=$._config.instanceLabels,
    varMetric='opensearch_os_cpu_percent',
    enableLokiLogs=$._config.enableLokiLogs,
  ),

  local panels = (import '../panels.libsonnet').new(
    $._config.groupLabels,
    $._config.instanceLabels,
    variables,
  ),

  local promDatasource = {
    uid: '${%s}' % variables.datasources.prometheus.name,
  },

  local lokiDatasource = {
    uid: '${%s}' % variables.datasources.loki.name,
  },

  local nodeHealthRow = {
    datasource: promDatasource,
    targets: [],
    type: 'row',
    title: 'Node health',
    collapsed: false,
  },

  local nodeCPUUsagePanel =
    commonlib.panels.cpu.timeSeries.utilization.new(
      'Node CPU usage',
      targets=[
        g.query.prometheus.new(
          promDatasource.uid,
          'opensearch_os_cpu_percent{%(queriesSelector)s}'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          },
        )
        + g.query.prometheus.withLegendFormat(utils.labelsToPanelLegend($._config.instanceLabels)),

      ],
      description="CPU usage percentage of the node's Operating System.",
    )
    + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

  local nodeMemoryUsagePanel =
    commonlib.panels.memory.timeSeries.usagePercent.new(
      'Node memory usage',
      targets=[
        g.query.prometheus.new(
          promDatasource.uid,
          'opensearch_os_mem_used_percent{%(queriesSelector)s}'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          },
        )
        + g.query.prometheus.withLegendFormat(utils.labelsToPanelLegend($._config.instanceLabels)),
      ],
      description='Memory usage percentage of the node for the Operating System and OpenSearch',
    )
    + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

  local nodeIOPanel =
    commonlib.panels.disk.timeSeries.ioBytesPerSec.new(
      'Node I/O',
      targets=[
        g.query.prometheus.new(
          promDatasource.uid,
          'sum by(%(agg)s) (rate(opensearch_fs_io_total_read_bytes{%(queriesSelector)s}[$__rate_interval]))'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          },
        )
        + g.query.prometheus.withLegendFormat('%s - read' % utils.labelsToPanelLegend($._config.instanceLabels)),
        g.query.prometheus.new(
          promDatasource.uid,
          'sum by(%(agg)s) (rate(opensearch_fs_io_total_write_bytes{%(queriesSelector)s}[$__rate_interval]))'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          },
        )
        + g.query.prometheus.withLegendFormat('%s - write' % utils.labelsToPanelLegend($._config.instanceLabels)),
      ],
      description='Node file system read and write data.',
    )
    + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking(value='normal'),

  local nodeOpenConnectionsPanel =
    commonlib.panels.generic.timeSeries.base.new(
      'Node open connections',
      targets=[
        g.query.prometheus.new(
          promDatasource.uid,
          'sum by (%(agg)s) (opensearch_transport_server_open_number{%(queriesSelector)s})'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          },
        )
        + g.query.prometheus.withLegendFormat(utils.labelsToPanelLegend($._config.instanceLabels)),
      ],
      description='Number of open connections for the selected node.',
    )
    + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking(value='normal')
    + g.panel.timeSeries.standardOptions.withUnit(''),

  local nodeDiskUsagePanel =
    commonlib.panels.disk.timeSeries.usagePercent.new(
      'Node disk usage',
      targets=[
        g.query.prometheus.new(
          promDatasource.uid,
          '100 - (100 * opensearch_fs_path_free_bytes{%(queriesSelector)s} / clamp_min(opensearch_fs_path_total_bytes{%(queriesSelector)s}, 1))'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          },
        )
        + g.query.prometheus.withLegendFormat(utils.labelsToPanelLegend($._config.instanceLabels)),
      ],
      description='Disk usage percentage of the selected node.',
    ),

  local nodeMemorySwapPanel =
    commonlib.panels.memory.timeSeries.usagePercent.new(
      'Node memory swap',
      targets=[
        g.query.prometheus.new(
          promDatasource.uid,
          '100 * opensearch_os_swap_used_bytes{%(queriesSelector)s} / clamp_min((opensearch_os_swap_used_bytes{%(queriesSelector)s} + opensearch_os_swap_free_bytes{%(queriesSelector)s}), 1)'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          },
        )
        + g.query.prometheus.withLegendFormat(utils.labelsToPanelLegend($._config.instanceLabels)),
      ],
      description='Percentage of swap space used by OpenSearch and the Operating System on the selected node.',
    )
    + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

  local nodeNetworkTrafficPanel =
    commonlib.panels.network.timeSeries.traffic.new(
      'Node network traffic',
      targets=[
        g.query.prometheus.new(
          promDatasource.uid,
          'sum by (%(agg)s) (rate(opensearch_transport_tx_bytes_count{%(queriesSelector)s}[$__rate_interval])) * 8'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          },
        )
        + g.query.prometheus.withLegendFormat('%s - sent' % utils.labelsToPanelLegend($._config.instanceLabels)),
        g.query.prometheus.new(
          promDatasource.uid,
          'sum by (%(agg)s) (rate(opensearch_transport_rx_bytes_count{%(queriesSelector)s}[$__rate_interval])) * 8'
          %
          {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
          }

        ) + g.query.prometheus.withLegendFormat('%s - received' % utils.labelsToPanelLegend($._config.instanceLabels)),
      ],
      description='Node network traffic sent and received.',
    )
    + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets('/sent/')
    + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

  local circuitBreakersPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by(name, %(agg)s) (increase(opensearch_circuitbreaker_tripped_count{%(queriesSelector)s}[$__interval:]))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s - {{ name }}' % utils.labelsToPanelLegend($._config.instanceLabels),
        interval='1m',
      ),
    ],
    type: 'timeseries',
    title: 'Circuit breakers',
    description: 'Circuit breakers tripped on the selected node by type',
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
        unit: 'trips',
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
  },

  local nodeJVMRow = {
    datasource: promDatasource,
    targets: [],
    type: 'row',
    title: 'Node JVM',
    collapsed: false,
  },

  local jvmHeapUsedVsCommittedPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by (%(agg)s) (opensearch_jvm_mem_heap_used_bytes{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s - used' % utils.labelsToPanelLegend($._config.instanceLabels),
      ),
      prometheus.target(
        'sum by (%(agg)s) (opensearch_jvm_mem_heap_committed_bytes{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s - commited' % utils.labelsToPanelLegend($._config.instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'JVM heap used vs. committed',
    description: 'The amount of heap memory used vs committed on the selected node.',
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
        mode: 'multi',
        sort: 'none',
      },
    },
  },

  local jvmNonheapUsedVsCommittedPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by (%(agg)s) (opensearch_jvm_mem_nonheap_used_bytes{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s - used' % utils.labelsToPanelLegend($._config.instanceLabels),
      ),
      prometheus.target(
        'sum by (%(agg)s) (opensearch_jvm_mem_nonheap_committed_bytes{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s - commited' % utils.labelsToPanelLegend($._config.instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'JVM non-heap used vs. committed',
    description: 'The amount of non-heap memory used vs committed on the selected node.',
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
        mode: 'multi',
        sort: 'none',
      },
    },
  },

  local jvmThreadsPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by (%(agg)s) (opensearch_jvm_threads_number{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'JVM threads',
    description: 'The number of threads running in the JVM on the selected node.',
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
        unit: 'threads',
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
  },

  local jvmBufferPoolsPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by( %(agg)s, bufferpool) (opensearch_jvm_bufferpool_number{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s - {{bufferpool}}' % utils.labelsToPanelLegend($._config.instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'JVM buffer pools',
    description: 'The number of buffer pools available on the selected node.',
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
        unit: 'buffer pools',
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
        sort: 'none',
      },
    },
  },

  local jvmUptimePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by(%(agg)s) (opensearch_jvm_uptime_seconds{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'JVM uptime',
    description: 'The uptime of the JVM in seconds on the selected node.',
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
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    pluginVersion: '9.4.3',
  },

  local jvmGarbageCollectionsPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by (%(agg)s) (increase(opensearch_jvm_gc_collection_count{%(queriesSelector)s}[$__interval:]))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.instanceLabels),
        interval='1m',
      ),
    ],
    type: 'timeseries',
    title: 'JVM garbage collections',
    description: 'The number of garbage collection operations on the selected node.',
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
        unit: 'operations',
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
  },

  local jvmGarbageCollectionTimePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by (%(agg)s) (increase(opensearch_jvm_gc_collection_time_seconds{%(queriesSelector)s}[$__interval:]))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.instanceLabels),
        interval='1m',
      ),
    ],
    type: 'timeseries',
    title: 'JVM garbage collection time',
    description: 'The amount of time spent on garbage collection on the selected node.',
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
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
  },

  local jvmBufferPoolUsagePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        '100 * (sum by (%(agg)s, bufferpool) (opensearch_jvm_bufferpool_used_bytes{%(queriesSelector)s})) / clamp_min((sum by (job, bufferpool, cluster) (opensearch_jvm_bufferpool_total_capacity_bytes{%(queriesSelector)s})),1)'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s - {{bufferpool}}' % utils.labelsToPanelLegend($._config.instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'JVM buffer pool usage',
    description: 'The percent used of JVM buffer pool memory.',
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
        mode: 'single',
        sort: 'none',
      },
    },
  },

  local threadPoolsRow = {
    datasource: promDatasource,
    targets: [],
    type: 'row',
    title: 'Thread pools',
    collapsed: false,
  },

  local threadPoolThreadsPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by(%(agg)s) ((opensearch_threadpool_threads_number{%(queriesSelector)s}))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'Thread pool threads',
    description: 'The number of threads in the thread pool for the selected node',
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
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
        unit: 'threads',
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
  },

  local threadPoolTasksPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'sum by (%(agg)s) (opensearch_threadpool_tasks_number{%(queriesSelector)s})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        },
        datasource=promDatasource,
        legendFormat=utils.labelsToPanelLegend($._config.instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'Thread pool tasks',
    description: 'The number of tasks in the thread pool for the selected node.',
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
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
        unit: 'tasks',
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
  },

  local errorLogsPanelPanel = {
    datasource: lokiDatasource,
    targets: [
      {
        datasource: lokiDatasource,
        editorMode: 'code',
        expr: '{%(queriesSelector)s} |~ ""' % { queriesSelector: variables.queriesSelector },
        queryType: 'range',
        refId: 'A',
      },
    ],
    type: 'logs',
    title: 'Error logs panel',
    description: 'The recent error logs being reported by OpenSearch.',
    options: {
      dedupStrategy: 'none',
      enableLogDetails: true,
      prettifyLogMessage: false,
      showCommonLabels: false,
      showLabels: false,
      showTime: false,
      sortOrder: 'Descending',
      wrapLogMessage: false,
    },
  },

  grafanaDashboards+:: {
    'node-overview.json':
      g.dashboard.new($._config.dashboardNamePrefix + 'OpenSearch node overview')
      + g.dashboard.withTags($._config.dashboardTags)
      + g.dashboard.time.withFrom($._config.dashboardPeriod)
      + g.dashboard.withTimezone($._config.dashboardTimezone)
      + g.dashboard.withRefresh($._config.dashboardRefresh)
      + g.dashboard.withUid($._config.uid + dashboardUidSuffix)
      + g.dashboard.withLinks(
        g.dashboard.link.dashboards.new(
          'Other Opensearch dashboards',
          $._config.dashboardTags
        )
        + g.dashboard.link.dashboards.options.withIncludeVars(true)
        + g.dashboard.link.dashboards.options.withKeepTime(true)
        + g.dashboard.link.dashboards.options.withAsDropdown(false)
      )
      + g.dashboard.withPanels(
        std.flattenArrays([
          [
            panels.osRolesTimeline { gridPos: { h: 5, w: 24, x: 0, y: 0 } },
            nodeHealthRow { gridPos: { h: 1, w: 24, x: 0, y: 1 } },
            nodeCPUUsagePanel { gridPos: { h: 7, w: 6, x: 0, y: 2 } },
            nodeMemoryUsagePanel { gridPos: { h: 7, w: 6, x: 6, y: 2 } },
            nodeIOPanel { gridPos: { h: 7, w: 6, x: 12, y: 2 } },
            nodeOpenConnectionsPanel { gridPos: { h: 7, w: 6, x: 18, y: 2 } },
            nodeDiskUsagePanel { gridPos: { h: 7, w: 6, x: 0, y: 8 } },
            nodeMemorySwapPanel { gridPos: { h: 7, w: 6, x: 6, y: 8 } },
            nodeNetworkTrafficPanel { gridPos: { h: 7, w: 6, x: 12, y: 8 } },
            circuitBreakersPanel { gridPos: { h: 7, w: 6, x: 18, y: 8 } },
            nodeJVMRow { gridPos: { h: 1, w: 24, x: 0, y: 15 } },
            jvmHeapUsedVsCommittedPanel { gridPos: { h: 6, w: 6, x: 0, y: 16 } },
            jvmNonheapUsedVsCommittedPanel { gridPos: { h: 6, w: 6, x: 6, y: 16 } },
            jvmThreadsPanel { gridPos: { h: 6, w: 6, x: 12, y: 16 } },
            jvmBufferPoolsPanel { gridPos: { h: 6, w: 6, x: 18, y: 16 } },
            jvmUptimePanel { gridPos: { h: 6, w: 6, x: 0, y: 22 } },
            jvmGarbageCollectionsPanel { gridPos: { h: 6, w: 6, x: 6, y: 22 } },
            jvmGarbageCollectionTimePanel { gridPos: { h: 6, w: 6, x: 12, y: 22 } },
            jvmBufferPoolUsagePanel { gridPos: { h: 6, w: 6, x: 18, y: 22 } },
            threadPoolsRow { gridPos: { h: 1, w: 24, x: 0, y: 28 } },
            threadPoolThreadsPanel { gridPos: { h: 8, w: 12, x: 0, y: 29 } },
            threadPoolTasksPanel { gridPos: { h: 8, w: 12, x: 12, y: 29 } },
          ],
          if $._config.enableLokiLogs then [
            errorLogsPanelPanel { gridPos: { h: 7, w: 24, x: 0, y: 37 } },
          ] else [],
          [],
        ])
      )
      + g.dashboard.withVariables(variables.multiInstance),
  },
}
