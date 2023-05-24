local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-mesos-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
}; local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local masterUptimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_uptime_seconds{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Master uptime',
  description: 'Uptime of the Mesos master process.',
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
      unit: 's',
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
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
};

local cpusAvailablePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_cpus{job=~"$job", instance=~"$instance", type="total"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'CPUs available',
  description: 'CPUs available in the cluster.',
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
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
};

local memoryAvailablePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_mem{job=~"$job", instance=~"$instance", type="total"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Memory available',
  description: 'Amount of memory available in the cluster.',
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
      unit: 'bytes',
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
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
};

local gpusAvailablePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_gpus{job=~"$job", instance=~"$instance", type="total"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'GPUs available',
  description: 'Total number of GPUs available in the cluster.',
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
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
};

local diskAvailablePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_disk{job=~"$job", instance=~"$instance", type="total"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Disk available',
  description: 'Current amount of bytes inside the cluster.',
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
      unit: 'bytes',
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
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
};

local memoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_mem{job=~"$job", instance=~"$instance", type="percent"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory utilization',
  description: 'The percentage of allocated memory in use by the cluster.',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local diskUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_disk{job=~"$job", instance=~"$instance", type="percent"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Disk utilization',
  description: 'The percentage of allocated disk storage in use by the cluster.',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local eventsInQueuePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster, type) (mesos_master_event_queue_length{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}} - {{type}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Events in queue',
  description: 'The number of events in the event queue.',
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
      unit: 'events',
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

local messagesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster, type) (increase(mesos_master_messages{job=~"$job", instance=~"$instance"}[$__interval:])) > 0',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}} - {{type}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Messages',
  description: 'The rate of messages being processed.',
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
      unit: 'messages',
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

local registrarStatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_registrar_state_store_ms{job=~"$job", instance=~"$instance", type="mean"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}} - store',
      format='time_series',
    ),
    prometheus.target(
      'max by(mesos_cluster) (mesos_registrar_state_fetch_ms{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}} - fetch',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Registrar state',
  description: 'Duration of fetching and storing the Mesos agent registrar state.',
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
      sort: 'none',
    },
  },
};

local registrarLogRecoveredPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_registrar_log_recovered{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Registrar log recovered',
  description: 'Whether or not the registrar log was properly recovered.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [
        {
          options: {
            '0': {
              color: 'red',
              index: 1,
              text: 'Not OK',
            },
            '1': {
              color: 'green',
              index: 0,
              text: 'OK',
            },
          },
          type: 'value',
        },
        {
          options: {
            match: 'null',
            result: {
              color: 'text',
              index: 2,
              text: '-',
            },
          },
          type: 'special',
        },
      ],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
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
    text: {},
    textMode: 'auto',
  },
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
};

local allocatorRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Allocator',
  collapsed: false,
};

local allocationRunsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (rate(mesos_master_allocation_run_ms_count{job=~"$job", instance=~"$instance"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Allocation runs',
  description: 'The rate of how often the allocator is performing allocations.',
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
      unit: 'allocs/s',
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

local allocationDurationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_allocation_run_ms{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Allocation duration',
  description: 'Time spent in the allocation algorithm in ms.',
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
      sort: 'none',
    },
  },
};

local allocationLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_allocation_run_latency_ms{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Allocation latency',
  description: 'Allocation batch latency in ms',
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
      sort: 'none',
    },
  },
};

local eventQueueDispatchesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (mesos_master_event_queue_dispatches{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Event queue dispatches',
  description: 'The number of dispatch events in the allocator mesos event queue.',
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
      unit: 'events',
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

local agentsRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Agents',
  collapsed: false,
};

local agentMemoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (100 * mesos_slave_mem_used_bytes{job=~"$job", instance=~"$instance"} / clamp_min(mesos_slave_mem_bytes{job=~"$job", instance=~"$instance"},1))',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Agent memory utilization',
  description: 'The percentage of allocated memory in use by the agent.',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local agentDiskUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'max by(mesos_cluster) (100 * mesos_slave_disk_used_bytes{job=~"$job", instance=~"$instance"} / clamp_min(mesos_slave_disk_bytes{job=~"$job", instance=~"$instance"},1))',
      datasource=promDatasource,
      legendFormat='{{mesos_cluster}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Agent disk utilization',
  description: 'The percentage of allocated disk storage in use by the agent.',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local logsRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Logs',
  collapsed: false,
};

local masterLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", filename=~"/var/log/mesos/master/.*", mesos_cluster=~"$mesos_cluster"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Master logs',
  description: 'The application logs for the Mesos master node.',
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

local agentLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", filename=~"/var/log/mesos/agent/.*", mesos_cluster=~"$mesos_cluster"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Agent logs',
  description: 'The application logs for the Mesos agent node.',
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
    'apache-mesos-overview.json':
      dashboard.new(
        'Apache Mesos overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addTemplates(
        std.flattenArrays([
          [
            template.datasource(
              promDatasourceName,
              'prometheus',
              null,
              label='Prometheus data source',
              refresh='load'
            ),
          ],
          if $._config.enableLokiLogs then [
            template.datasource(
              lokiDatasourceName,
              'loki',
              null,
              label='Loki data source',
              refresh='load'
            ),
          ] else [],
          [
            template.new(
              'job',
              promDatasource,
              'label_values(mesos_exporter_build_info,job)',
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
              'label_values(mesos_exporter_build_info{job=~"$job", instance=~"$instance"}, instance)',
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'mesos_cluster',
              promDatasource,
              'label_values(mesos_exporter_build_info{job=~"$job", instance=~"$instance"}, mesos_cluster)',
              label='Mesos cluster',
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
            masterUptimePanel { gridPos: { h: 6, w: 4, x: 0, y: 0 } },
            cpusAvailablePanel { gridPos: { h: 6, w: 5, x: 4, y: 0 } },
            memoryAvailablePanel { gridPos: { h: 6, w: 5, x: 9, y: 0 } },
            gpusAvailablePanel { gridPos: { h: 6, w: 5, x: 14, y: 0 } },
            diskAvailablePanel { gridPos: { h: 6, w: 5, x: 19, y: 0 } },
            memoryUtilizationPanel { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
            diskUtilizationPanel { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
            eventsInQueuePanel { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
            messagesPanel { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
            registrarStatePanel { gridPos: { h: 6, w: 18, x: 0, y: 18 } },
            registrarLogRecoveredPanel { gridPos: { h: 6, w: 6, x: 18, y: 18 } },
            allocatorRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
            allocationRunsPanel { gridPos: { h: 6, w: 6, x: 0, y: 25 } },
            allocationDurationPanel { gridPos: { h: 6, w: 6, x: 6, y: 25 } },
            allocationLatencyPanel { gridPos: { h: 6, w: 6, x: 12, y: 25 } },
            eventQueueDispatchesPanel { gridPos: { h: 6, w: 6, x: 18, y: 25 } },
            agentsRow { gridPos: { h: 1, w: 24, x: 0, y: 31 } },
            agentMemoryUtilizationPanel { gridPos: { h: 6, w: 12, x: 0, y: 32 } },
            agentDiskUtilizationPanel { gridPos: { h: 6, w: 12, x: 12, y: 32 } },
          ],
          if $._config.enableLokiLogs then [
            logsRow { gridPos: { h: 1, w: 24, x: 0, y: 38 } },
          ] else [],
          [
          ],
          if $._config.enableLokiLogs then [
            masterLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 39 } },
          ] else [],
          [
          ],
          if $._config.enableLokiLogs then [
            agentLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 47 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
