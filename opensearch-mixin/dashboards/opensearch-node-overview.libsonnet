local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'node-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local nodeHealthRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Node health',
  collapsed: true,
};

local nodeCPUUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'opensearch_os_cpu_percent{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}',
      datasource=promDatasource,
      legendFormat='{{node}}',
    ),
  ],
  type: 'timeseries',
  title: 'Node CPU usage',
  description: "CPU usage percentage of the node's Operating System.",
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
};

local nodeMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'opensearch_os_mem_used_percent{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}',
      datasource=promDatasource,
      legendFormat='{{node}}',
    ),
  ],
  type: 'timeseries',
  title: 'Node memory usage',
  description: 'Memory usage percentage of the node for the Operating System and OpenSearch',
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

local nodeIOPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(node, job, cluster) (opensearch_fs_io_total_read_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}} - read',
    ),
    prometheus.target(
      'sum by(node, job, cluster) (opensearch_fs_io_total_write_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}} - write',
    ),
  ],
  type: 'timeseries',
  title: 'Node I/O',
  description: 'Node file system read and write data.',
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

local nodeOpenConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (node, job, cluster) (opensearch_transport_server_open_number{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}}',
    ),
  ],
  type: 'timeseries',
  title: 'Node open connections',
  description: 'Number of open connections for the selected node.',
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
      unit: 'connections',
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

local nodeDiskUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 - (100 * opensearch_fs_path_free_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"} / clamp_min(opensearch_fs_path_total_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}, 1))\n',
      datasource=promDatasource,
      legendFormat='{{node}}',
    ),
  ],
  type: 'timeseries',
  title: 'Node disk usage',
  description: 'Disk usage percentage of the selected node.',
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
};

local nodeMemorySwapPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * opensearch_os_swap_used_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"} / clamp_min((opensearch_os_swap_used_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"} + opensearch_os_swap_free_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}), 1)',
      datasource=promDatasource,
      legendFormat='{{node}}',
    ),
  ],
  type: 'timeseries',
  title: 'Node memory swap',
  description: 'Percentage of swap space used by OpenSearch and the Operating System on the selected node.',
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
};

local nodeNetworkTrafficPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (node, job, cluster) (rate(opensearch_transport_tx_bytes_count{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{node}} - sent',
    ),
    prometheus.target(
      'sum by (node, job, cluster) (rate(opensearch_transport_rx_bytes_count{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{node}} - received',
    ),
  ],
  type: 'timeseries',
  title: 'Node network traffic',
  description: 'Node network traffic sent and received.',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local circuitBreakersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(name, job, cluster) (increase(opensearch_circuitbreaker_tripped_count{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{name}}',
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
};

local nodeJVMRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Node JVM',
  collapsed: true,
};

local jvmHeapUsedVsCommittedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (node, job, cluster) (opensearch_jvm_mem_heap_used_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}} - used',
    ),
    prometheus.target(
      'sum by (node, job, cluster) (opensearch_jvm_mem_heap_committed_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}} - committed',
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
};

local jvmNonheapUsedVsCommittedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (node, job, cluster) (opensearch_jvm_mem_nonheap_used_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}} - used',
    ),
    prometheus.target(
      'sum by (node, job, cluster) (opensearch_jvm_mem_nonheap_committed_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}} - committed',
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
};

local jvmThreadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (node, job, cluster) (opensearch_jvm_threads_number{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}}',
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
};

local jvmBufferPoolsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, bufferpool) (opensearch_jvm_bufferpool_number{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{bufferpool}}',
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
};

local jvmUptimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, cluster, node) (opensearch_jvm_uptime_seconds{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}}',
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
};

local jvmGarbageCollectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (node, cluster, job) (increase(opensearch_jvm_gc_collection_count{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{node}}',
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
};

local jvmGarbageCollectionTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (node, cluster, job) (increase(opensearch_jvm_gc_collection_time_seconds{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{node}}',
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
};

local jvmBufferPoolUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * (sum by (job, bufferpool, cluster) (opensearch_jvm_bufferpool_used_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})) / clamp_min((sum by (job, bufferpool, cluster) (opensearch_jvm_bufferpool_total_capacity_bytes{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})),1)',
      datasource=promDatasource,
      legendFormat='{{bufferpool}}',
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
};

local threadPoolsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Thread pools',
  collapsed: false,
};

local threadPoolThreadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(node, job, cluster) ((opensearch_threadpool_threads_number{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"}))',
      datasource=promDatasource,
      legendFormat='{{node}}',
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
};

local threadPoolTasksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (node, job, cluster) (opensearch_threadpool_tasks_number{cluster=~"$opensearch_cluster", job=~"$job", node=~"$node"})',
      datasource=promDatasource,
      legendFormat='{{node}}',
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
};

local errorLogsPanelPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", node=~"$node", filename="/var/log/opensearch/opensearch.log"} |~ ""',
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
};

{
  grafanaDashboards+:: {
    'node-overview.json':
      dashboard.new(
        'OpenSearch node overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other OpenSearch dashboards',
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
          ],
          if $._config.enableLokiLogs then [
            template.datasource(
              lokiDatasourceName,
              'loki',
              null,
              label='Loki Datasource',
              refresh='load'
            ),
          ] else [],
          [
            template.new(
              'job',
              promDatasource,
              'label_values(opensearch_cluster_status,job)',
              label='Job',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=1
            ),
            template.new(
              'opensearch_cluster',
              promDatasource,
              'label_values(opensearch_cluster_status{job=~"$job"}, cluster)',
              label='OpenSearch Cluster',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=1
            ),
            template.new(
              'node',
              promDatasource,
              'label_values(opensearch_os_cpu_percent{job=~"$job", cluster=~"$opensearch_cluster"}, node)',
              label='Node',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            nodeHealthRow { gridPos: { h: 1, w: 24, x: 0, y: 0 } },
            nodeCPUUsagePanel { gridPos: { h: 7, w: 6, x: 0, y: 1 } },
            nodeMemoryUsagePanel { gridPos: { h: 7, w: 6, x: 6, y: 1 } },
            nodeIOPanel { gridPos: { h: 7, w: 6, x: 12, y: 1 } },
            nodeOpenConnectionsPanel { gridPos: { h: 7, w: 6, x: 18, y: 1 } },
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
          [
          ],
        ])
      ),
  },
}
