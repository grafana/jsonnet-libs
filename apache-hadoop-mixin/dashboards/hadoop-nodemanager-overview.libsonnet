local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-hadoop-nodemanager-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local getMatcher(cfg) = '%(hadoopSelector)s, instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local applicationsRunningPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_applicationsrunning{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Applications running',
  description: 'Number of applications currently running for the NodeManager.',
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
          },
        ],
      },
      unit: '',
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
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local allocatedContainersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_allocatedcontainers{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Allocated containers',
  description: 'Number of containers currently allocated for the NodeManager.',
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
          },
        ],
      },
      unit: '',
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
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local containersLocalizationDurationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_localizationdurationmillisavgtime{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Containers localization duration',
  description: 'Average time taken for the NodeManager to localize necessary resources for a container.',
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
          },
        ],
      },
      unit: 'ms',
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
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local containersLaunchDurationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_containerlaunchdurationavgtime{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Containers launch duration',
  description: 'Average time taken to launch a container on the NodeManager after the necessary resources have been localized.',
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
          },
        ],
      },
      unit: 'ms',
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
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local jvmRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'JVM',
  collapsed: false,
};

local memoryUsedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_memheapusedm{name="JvmMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_memnonheapusedm{name="JvmMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - nonheap',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory used',
  description: 'The Heap and non-heap memory used for the NodeManager.',
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
      unit: 'decmbytes',
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

local memoryCommittedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_memheapcommittedm{name="JvmMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_memnonheapcommittedm{name="JvmMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - nonheap',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory committed',
  description: 'The Heap and non-heap memory committed for the NodeManager.',
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
      unit: 'decmbytes',
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

local garbageCollectionCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_nodemanager_gccount{' + matcher + '}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection count',
  description: 'The recent increase in the number of garbage collection events for the NodeManager JVM.',
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
        ],
      },
      unit: '',
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

local averageGarbageCollectionTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_nodemanager_gctimemillis{' + matcher + '}[$__interval:]) / clamp_min(increase(hadoop_nodemanager_gccount{' + matcher + '}[$__interval:]), 1)',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Average garbage collection time',
  description: 'The average duration for each garbage collection operation in the NodeManager JVM.',
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

local nodeRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Node',
  collapsed: false,
};

local nodeMemoryUsedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_memheapusedm{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_memnonheapusedm{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - nonheap',
    ),
  ],
  type: 'timeseries',
  title: 'Node memory used',
  description: 'The Heap and non-heap memory used for the NodeManager.',
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
      unit: 'decmbytes',
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

local nodeMemoryCommittedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_memheapcommittedm{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_memnonheapcommittedm{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - nonheap',
    ),
  ],
  type: 'timeseries',
  title: 'Node memory committed',
  description: 'The Heap and non-heap memory committed for the NodeManager.',
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
      unit: 'decmbytes',
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

local nodeCPUUtilizationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * hadoop_nodemanager_nodecpuutilization{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Node CPU utilization',
  description: 'CPU utilization of the Node.',
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

local nodeGPUUtilizationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * hadoop_nodemanager_nodegpuutilization{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Node GPU utilization',
  description: 'GPU utilization of the Node.',
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

local containersRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Containers',
  collapsed: false,
};

local containersStatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_containerspaused{' + matcher + '} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - paused',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containerslaunched{' + matcher + '} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - launched',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containerscompleted{' + matcher + '} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - completed',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containersfailed{' + matcher + '} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - failed',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containerskilled{' + matcher + '} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - killed',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containersiniting{' + matcher + '} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - initing',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containersreiniting{' + matcher + '} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - reiniting',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Containers state',
  description: 'Number of containers with a given state for the NodeManager.',
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
        ],
      },
      unit: '',
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

local containersUsedMemoryPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_containerusedmemgb{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Containers used memory',
  description: 'Total memory used by containers for the NodeManager.',
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
        ],
      },
      unit: 'decmbytes',
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

local containersUsedVirtualMemoryPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_containerusedvmemgb{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Containers used virtual memory',
  description: 'Total virtual memory used by containers for the NodeManager.',
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
        ],
      },
      unit: 'decmbytes',
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

local containersAvailableMemoryPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_availablegb{name="NodeManagerMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - available',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_allocatedgb{name="NodeManagerMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - allocated',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Containers available memory',
  description: 'The memory available and currently allocated for containers by the NodeManager.',
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
        ],
      },
      unit: 'decgbytes',
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

local containersAvailableVirtualCoresPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_availablevcores{name="NodeManagerMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - available',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_allocatedvcores{name="NodeManagerMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - allocated',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Containers available virtual cores',
  description: 'The virtual available and currently allocated for containers by the NodeManager.',
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
        ],
      },
      unit: '',
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

local nodemanagerLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + matcher + '} |= `` | (filename=~".*/hadoop/logs/.*-nodemanager.*.log" or log_type="nodemanager")',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'NodeManager logs',
  description: 'The Nodemanager logs.',
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
    'apache-hadoop-nodemanager-overview.json':
      dashboard.new(
        'Apache Hadoop NodeManager overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache Hadoop dashboards',
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
              'label_values(hadoop_nodemanager_availablegb,job)',
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
              'label_values(hadoop_nodemanager_availablegb{%(multiclusterSelector)s}, cluster)' % $._config,
              label='Cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.*',
              hide=if $._config.enableMultiCluster then '' else 'variable',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(hadoop_nodemanager_availablegb{%(hadoopSelector)s}, instance)' % $._config,
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'hadoop_cluster',
              promDatasource,
              'label_values(hadoop_nodemanager_availablegb{%(hadoopSelector)s}, hadoop_cluster)' % $._config,
              label='Hadoop cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            applicationsRunningPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 0, y: 0 } },
            allocatedContainersPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 6, y: 0 } },
            containersLocalizationDurationPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 12, y: 0 } },
            containersLaunchDurationPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 18, y: 0 } },
            jvmRow { gridPos: { h: 1, w: 24, x: 0, y: 6 } },
            memoryUsedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 7 } },
            memoryCommittedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 7 } },
            garbageCollectionCountPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 13 } },
            averageGarbageCollectionTimePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 13 } },
            nodeRow { gridPos: { h: 1, w: 24, x: 0, y: 19 } },
            nodeMemoryUsedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 20 } },
            nodeMemoryCommittedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 20 } },
            nodeCPUUtilizationPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 26 } },
            nodeGPUUtilizationPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 26 } },
            containersRow { gridPos: { h: 1, w: 24, x: 0, y: 32 } },
            containersStatePanel(getMatcher($._config)) { gridPos: { h: 6, w: 8, x: 0, y: 33 } },
            containersUsedMemoryPanel(getMatcher($._config)) { gridPos: { h: 6, w: 8, x: 8, y: 33 } },
            containersUsedVirtualMemoryPanel(getMatcher($._config)) { gridPos: { h: 6, w: 8, x: 16, y: 33 } },
            containersAvailableMemoryPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 39 } },
            containersAvailableVirtualCoresPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 39 } },
          ],
          if $._config.enableLokiLogs then [
            nodemanagerLogsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 45 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
