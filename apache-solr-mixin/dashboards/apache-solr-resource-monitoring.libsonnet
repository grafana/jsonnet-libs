local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-solr-resource-monitoring';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local connectionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url, item) (solr_metrics_node_connections{' + matcher + '}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - {{item}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'Number of connections to the Solr node.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
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

local threadsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (increase(solr_metrics_node_thread_pool_submitted_total{' + matcher + ', executor="updateOnlyExecutor"}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - submitted',
      format='time_series',
    ),
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (increase(solr_metrics_node_thread_pool_completed_total{' + matcher + ', executor="updateOnlyExecutor"}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - completed',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Threads / $__interval',
  description: 'Total number of tasks submitted and completed in the thread pool.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
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

local nodeCoreFSUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url, item) (solr_metrics_node_core_root_fs_bytes{' + matcher + '}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - {{item}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Node core FS usage',
  description: "Disk space used by Solr node's root file system.",
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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

local garbageCollectionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url, item) (increase(solr_metrics_jvm_gc_total{' + matcher + '}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - {{item}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collections / $__interval',
  description: 'Counts the total number of garbage collection events.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
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

local garbageCollectionTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url, item) (increase(solr_metrics_jvm_gc_seconds_total{' + matcher + '}[$__interval:]) / clamp_min(increase(solr_metrics_jvm_gc_total{' + matcher + '}[$__interval:]), 1)) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - {{item}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection time / $__interval',
  description: 'Total time spent in garbage collection.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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

local jvmMetricsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'JVM metrics',
  collapsed: false,
};

local cpuAverageLoadPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (100 * solr_metrics_jvm_os_cpu_load{' + matcher + ', item="systemCpuLoad"}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'CPU load',
  description: 'CPU load caused by the JVM.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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
            color: 'yellow',
            value: 90,
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

local osMemoryPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_os_memory_bytes{' + matcher + ', item="freePhysicalMemorySize"}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - free physical',
      format='time_series',
    ),
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_os_memory_bytes{' + matcher + ', item="totalPhysicalMemorySize"}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - total physical',
      format='time_series',
    ),
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_os_memory_bytes{' + matcher + ', item="committedVirtualMemorySize"}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - committed virtual',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'OS memory',
  description: "The operating system's virtual committed memory, free physical memory and total physical memory usage.",
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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

local numberOfFileDescriptorsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url, item) (solr_metrics_jvm_os_file_descriptors{' + matcher + '}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - {{item}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'File descriptors',
  description: 'Number of open file descriptors.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
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

local memoryUsedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_heap_bytes{' + matcher + ', item="used"}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_non_heap_bytes{' + matcher + ', item="used"}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - non-heap',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory used',
  description: 'The heap and non-heap memory used by the JVM.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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

local memoryCommittedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_heap_bytes{' + matcher + ', item="committed"}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_non_heap_bytes{' + matcher + ', item="committed"}) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - non-heap',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory committed',
  description: 'The heap and non-heap memory committed by the JVM.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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

local jettyMetricsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Jetty metrics',
  collapsed: false,
};

local requestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url, method) (increase(solr_metrics_jetty_requests_total{' + matcher + '}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - {{method}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Requests  / $__interval',
  description: 'Total number of requests received by Jetty.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
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

local responsesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url, status) (increase(solr_metrics_jetty_response_total{' + matcher + '}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}} - {{status}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Responses  / $__interval',
  description: 'Total number of responses generated by Jetty.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
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

local dispatchesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, solr_cluster, base_url) (increase(solr_metrics_jetty_dispatches_total{' + matcher + '}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{base_url}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Dispatches  / $__interval',
  description: 'Total count of dispatches handled by Jetty.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: true,
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
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

local getMatcher(cfg) = '%(solrSelector)s, solr_cluster="$solr_cluster", base_url=~"$base_url"' % cfg;

{
  grafanaDashboards+:: {
    'apache-solr-resource-monitoring.json':
      dashboard.new(
        'Apache Solr resource monitoring',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache Solr dashboards',
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
            'label_values(solr_metrics_core_errors_total,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(cassandra_cache_size{%(multiclusterSelector)s}, cluster)' % $._config,
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'base_url',
            promDatasource,
            'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, base_url)' % $._config,
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'solr_cluster',
            promDatasource,
            'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, solr_cluster)' % $._config,
            label='Solr cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
        ]
      )
      .addPanels(
        [
          connectionsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
          threadsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
          nodeCoreFSUsagePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          numberOfFileDescriptorsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          jvmMetricsRow { gridPos: { h: 1, w: 24, x: 0, y: 12 } },
          garbageCollectionsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 13 } },
          garbageCollectionTimePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 13 } },
          cpuAverageLoadPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 19 } },
          osMemoryPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 19 } },
          memoryUsedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
          memoryCommittedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
          jettyMetricsRow { gridPos: { h: 1, w: 24, x: 0, y: 31 } },
          requestsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 37 } },
          responsesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 37 } },
          dispatchesPanel(getMatcher($._config)) { gridPos: { h: 6, w: 24, x: 0, y: 43 } },
        ]
      ),
  },
}
