local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'ibm-mq-queue-manager-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local activeListenersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_active_listeners{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
    ),
  ],
  type: 'stat',
  title: 'Active listeners',
  description: 'The number of active listeners for the queue manager.',
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
            color: 'red',
            value: null,
          },
          {
            color: 'green',
            value: 1,
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
  pluginVersion: '10.0.1-cloud.3.f250259e',
};

local activeConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_connection_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
    ),
  ],
  type: 'stat',
  title: 'Active connections',
  description: 'The number of active connections for the queue manager.',
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
            color: 'red',
            value: null,
          },
          {
            color: 'green',
            value: 1,
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
  pluginVersion: '10.0.1-cloud.3.f250259e',
};

local queuesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count(ibmmq_queue_depth{job=~"$job"}) by (queue, mq_cluster, qmgr))',
      datasource=promDatasource,
    ),
  ],
  type: 'stat',
  title: 'Queues',
  description: 'The unique number of queues being managed by the queue manager.',
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
            color: 'red',
            value: null,
          },
          {
            color: 'green',
            value: 1,
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
  pluginVersion: '10.0.1-cloud.3.f250259e',
};

local cpuUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_user_cpu_time_percentage{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - user',
    ),
    prometheus.target(
      'ibmmq_qmgr_system_cpu_time_percentage{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - system',
    ),
  ],
  type: 'timeseries',
  title: 'CPU usage',
  description: 'The system/user CPU usage of the queue manager.',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local estimatedMemoryUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '(ibmmq_qmgr_ram_total_estimate_for_queue_manager_bytes{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}/ibmmq_qmgr_ram_total_bytes{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}) * 100',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
    ),
  ],
  type: 'timeseries',
  title: 'Estimated memory utilization',
  description: 'The estimated memory usage of the queue managers.',
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

local queueManagerStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_uptime{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='Uptime',
      format='table',
    ),
    prometheus.target(
      'ibmmq_qmgr_status{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='Status',
    ),
  ],
  type: 'table',
  title: 'Queue manager status',
  description: 'A table showing the status and uptime of the queue manager.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'auto',
        cellOptions: {
          type: 'auto',
        },
        filterable: false,
        inspect: false,
      },
      mappings: [
        {
          options: {
            '-1': {
              index: 0,
              text: 'N/A',
            },
            '0': {
              index: 1,
              text: 'Stopped',
            },
            '1': {
              index: 2,
              text: 'Starting',
            },
            '2': {
              index: 3,
              text: 'Running',
            },
            '3': {
              index: 4,
              text: 'Quiescing',
            },
            '4': {
              index: 5,
              text: 'Stopping',
            },
            '5': {
              index: 6,
              text: 'Standby',
            },
          },
          type: 'value',
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
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'Uptime',
        },
        properties: [
          {
            id: 'custom.width',
            value: 280,
          },
          {
            id: 'unit',
            value: 's',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: '__name__',
        },
        properties: [
          {
            id: 'custom.width',
            value: 318,
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      enablePagination: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    frameIndex: 1,
    showHeader: true,
    sortBy: [],
  },
  pluginVersion: '10.0.1-cloud.3.f250259e',
  transformations: [
    {
      id: 'joinByField',
      options: {
        byField: 'Time',
        mode: 'inner',
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {
          Time: true,
          __name__: true,
          description: true,
          hostname: true,
          instance: true,
          job: true,
          platform: true,
        },
        indexByName: {
          Time: 0,
          Value: 10,
          __name__: 1,
          description: 2,
          hostname: 3,
          'ibmmq_qmgr_status{job="$job", mq_cluster=~"$mq_cluster", qmgr="$qmgr"}': 9,
          instance: 4,
          job: 5,
          mq_cluster: 6,
          platform: 7,
          qmgr: 8,
        },
        renameByName: {
          Time: '',
          Value: 'Uptime',
          'ibmmq_qmgr_status{job="$job", mq_cluster=~"$mq_cluster", qmgr="$qmgr"}': 'Status',
          mq_cluster: 'MQ cluster',
          qmgr: 'Queue manager',
        },
      },
    },
    {
      id: 'reduce',
      options: {
        includeTimeField: false,
        mode: 'reduceFields',
        reducers: [
          'lastNotNull',
        ],
      },
    },
  ],
};

local diskUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_queue_manager_file_system_in_use_bytes{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
    ),
  ],
  type: 'timeseries',
  title: 'Disk usage',
  description: 'The disk allocated to the queue manager that is being used.',
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

local publishThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_published_to_subscribers_bytes{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
    ),
  ],
  type: 'timeseries',
  title: 'Publish throughput',
  description: 'The amount of data being pushed from the queue manager to subscribers.',
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

local publishedMessagesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_published_to_subscribers_message_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
    ),
  ],
  type: 'timeseries',
  title: 'Published messages',
  description: 'The number of messages being published by the queue manager.',
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

local commitsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_commit_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
    ),
  ],
  type: 'timeseries',
  title: 'Commits',
  description: 'The commits of the queue manager.',
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

local expiredMessagesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_expired_message_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
    ),
  ],
  type: 'timeseries',
  title: 'Expired messages',
  description: 'The expired messages of the queue manager.',
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

local queueOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqset_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQSET',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqinq_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQINQ',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqget_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQGET',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqopen_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQOPEN',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqclose_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQCLOSE',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqput_mqput1_count{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQPUT/MQPUT1',
    ),
  ],
  type: 'timeseries',
  title: 'Queue operations',
  description: 'The number of queue operations of the queue manager. ',
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
      mode: 'multi',
      sort: 'none',
    },
  },
};

local logsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Logs',
  collapsed: false,
};

local logLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_log_write_latency_seconds{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
    ),
  ],
  type: 'timeseries',
  title: 'Log latency',
  description: 'The recent latency of log writes.',
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

local logUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_log_in_use_bytes{mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
    ),
  ],
  type: 'timeseries',
  title: 'Log usage',
  description: 'The amount of data on the filesystem occupied by queue manager logs.',
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

local errorLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", filename=~"/var/mqm/qmgrs/.*/errors/.*LOG", qmgr=~"$qmgr"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Error logs',
  description: 'Recent error logs from the queue manager.',
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
    'ibm-mq-queue-manager-overview.json':
      dashboard.new(
        'IBM MQ queue manager overview',
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
              'label_values(ibmmq_topic_messages_received,job)',
              label='Job',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'mq_cluster',
              promDatasource,
              'label_values(ibmmq_topic_messages_received,mq_cluster)',
              label='MQ cluster',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'qmgr',
              promDatasource,
              'label_values(ibmmq_topic_messages_received{mq_cluster=~"$mq_cluster"},qmgr)',
              label='Queue manager',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
          ],
        ])
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other IBM MQ dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addPanels(
        std.flattenArrays([
          [
            activeListenersPanel { gridPos: { h: 7, w: 8, x: 0, y: 0 } },
            activeConnectionsPanel { gridPos: { h: 7, w: 8, x: 8, y: 0 } },
            queuesPanel { gridPos: { h: 7, w: 8, x: 16, y: 0 } },
            cpuUsagePanel { gridPos: { h: 8, w: 12, x: 0, y: 7 } },
            estimatedMemoryUtilizationPanel { gridPos: { h: 8, w: 12, x: 12, y: 7 } },
            queueManagerStatusPanel { gridPos: { h: 9, w: 24, x: 0, y: 15 } },
            diskUsagePanel { gridPos: { h: 8, w: 8, x: 0, y: 24 } },
            publishThroughputPanel { gridPos: { h: 8, w: 8, x: 8, y: 24 } },
            publishedMessagesPanel { gridPos: { h: 8, w: 8, x: 16, y: 24 } },
            commitsPanel { gridPos: { h: 8, w: 8, x: 0, y: 32 } },
            expiredMessagesPanel { gridPos: { h: 8, w: 8, x: 8, y: 32 } },
            queueOperationsPanel { gridPos: { h: 8, w: 8, x: 16, y: 32 } },
            logsRow { gridPos: { h: 1, w: 24, x: 0, y: 40 } },
            logLatencyPanel { gridPos: { h: 8, w: 12, x: 0, y: 41 } },
            logUsagePanel { gridPos: { h: 8, w: 12, x: 12, y: 41 } },
          ],
          if $._config.enableLokiLogs then [
            errorLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 49 } },
          ] else [],
          [
          ],
        ])
      ),

  },
}
