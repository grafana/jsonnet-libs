local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-hadoop-nodemanager-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local applicationsRunningPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_applicationsrunning{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local allocatedContainersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_allocatedcontainers{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local containersLocalizationDurationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_localizationdurationmillisavgtime{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local containersLaunchDurationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_containerlaunchdurationavgtime{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local memoryUsedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_memheapusedm{name="JvmMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_memnonheapusedm{name="JvmMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local memoryCommittedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_memheapcommittedm{name="JvmMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_memnonheapcommittedm{name="JvmMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local garbageCollectionCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_nodemanager_gccount{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}[$__interval:])',
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

local averageGarbageCollectionTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_nodemanager_gctimemillis{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}[$__interval:]) / clamp_min(increase(hadoop_nodemanager_gccount{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}[$__interval:]), 1)',
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

local nodeMemoryUsedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_memheapusedm{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_memnonheapusedm{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local nodeMemoryCommittedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_memheapcommittedm{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_memnonheapcommittedm{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local nodeCPUUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * hadoop_nodemanager_nodecpuutilization{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local nodeGPUUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * hadoop_nodemanager_nodegpuutilization{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local containersStatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_containerspaused{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - paused',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containerslaunched{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - launched',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containerscompleted{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - completed',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containersfailed{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - failed',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containerskilled{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - killed',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containersiniting{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"} > 0',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - initing',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_containersreiniting{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"} > 0',
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

local containersUsedMemoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_containerusedmemgb{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local containersUsedVirtualMemoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_containerusedvmemgb{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local containersAvailableMemoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_availablegb{name="NodeManagerMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - available',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_allocatedgb{name="NodeManagerMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local containersAvailableVirtualCoresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_nodemanager_availablevcores{name="NodeManagerMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - available',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_nodemanager_allocatedvcores{name="NodeManagerMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local nodemanagerLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", hadoop_cluster=~"$hadoop_cluster", instance=~"$instance", filename=~".*/hadoop/logs/.*-nodemanager.*\\.log"} |= ``',
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
              'instance',
              promDatasource,
              'label_values(hadoop_nodemanager_availablegb{job=~"$job"}, instance)',
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
              'label_values(hadoop_nodemanager_availablegb{job=~"$job"}, hadoop_cluster)',
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
            applicationsRunningPanel { gridPos: { h: 6, w: 6, x: 0, y: 0 } },
            allocatedContainersPanel { gridPos: { h: 6, w: 6, x: 6, y: 0 } },
            containersLocalizationDurationPanel { gridPos: { h: 6, w: 6, x: 12, y: 0 } },
            containersLaunchDurationPanel { gridPos: { h: 6, w: 6, x: 18, y: 0 } },
            jvmRow { gridPos: { h: 1, w: 24, x: 0, y: 6 } },
            memoryUsedPanel { gridPos: { h: 6, w: 12, x: 0, y: 7 } },
            memoryCommittedPanel { gridPos: { h: 6, w: 12, x: 12, y: 7 } },
            garbageCollectionCountPanel { gridPos: { h: 6, w: 12, x: 0, y: 13 } },
            averageGarbageCollectionTimePanel { gridPos: { h: 6, w: 12, x: 12, y: 13 } },
            nodeRow { gridPos: { h: 1, w: 24, x: 0, y: 19 } },
            nodeMemoryUsedPanel { gridPos: { h: 6, w: 12, x: 0, y: 20 } },
            nodeMemoryCommittedPanel { gridPos: { h: 6, w: 12, x: 12, y: 20 } },
            nodeCPUUtilizationPanel { gridPos: { h: 6, w: 12, x: 0, y: 26 } },
            nodeGPUUtilizationPanel { gridPos: { h: 6, w: 12, x: 12, y: 26 } },
            containersRow { gridPos: { h: 1, w: 24, x: 0, y: 32 } },
            containersStatePanel { gridPos: { h: 6, w: 8, x: 0, y: 33 } },
            containersUsedMemoryPanel { gridPos: { h: 6, w: 8, x: 8, y: 33 } },
            containersUsedVirtualMemoryPanel { gridPos: { h: 6, w: 8, x: 16, y: 33 } },
            containersAvailableMemoryPanel { gridPos: { h: 6, w: 12, x: 0, y: 39 } },
            containersAvailableVirtualCoresPanel { gridPos: { h: 6, w: 12, x: 12, y: 39 } },
          ],
          if $._config.enableLokiLogs then [
            nodemanagerLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 45 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
