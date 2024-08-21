local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;
local getMatcher(cfg) = '%(ibmmqSelector)s' % cfg;
local logExpr(cfg) = '%(logExpr)s' % cfg;

local dashboardUid = 'ibm-mq-queue-manager-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local activeListenersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_active_listeners{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
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
};

local activeConnectionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_connection_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
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
};

local queuesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count(ibmmq_queue_depth{' + matcher + '}) by (queue, mq_cluster, qmgr))',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
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
};

local estimatedMemoryUtilizationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '(ibmmq_qmgr_ram_total_estimate_for_queue_manager_bytes{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}/ibmmq_qmgr_ram_total_bytes{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
      format='time_series',
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
        fillOpacity: 10,
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
      unit: 'percentunit',
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

local queueManagerStatusPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_uptime{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='Uptime',
      format='table',
    ),
    prometheus.target(
      'ibmmq_qmgr_status{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='Status',
      format='time_series',
    ),
  ],
  type: 'table',
  title: 'Queue manager status',
  description: 'A table showing the status and uptime of the queue manager.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'color-text',
        },
        filterable: false,
        inspect: false,
      },
      mappings: [
        {
          options: {
            '-1': {
              color: 'dark-red',
              index: 0,
              text: 'N/A',
            },
            '0': {
              color: 'red',
              index: 1,
              text: 'Stopped',
            },
            '1': {
              color: 'light-green',
              index: 2,
              text: 'Starting',
            },
            '2': {
              color: 'green',
              index: 3,
              text: 'Running',
            },
            '3': {
              index: 4,
              text: 'Quiescing',
            },
            '4': {
              color: 'light-red',
              index: 5,
              text: 'Stopping',
            },
            '5': {
              color: 'yellow',
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
            value: 149,
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
      {
        matcher: {
          id: 'byName',
          options: 'Queue manager',
        },
        properties: [
          {
            id: 'custom.width',
            value: 168,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'MQ cluster',
        },
        properties: [
          {
            id: 'custom.width',
            value: 129,
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

local cpuUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_user_cpu_time_percentage{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - user',
      format='time_series',
    ),
    prometheus.target(
      'ibmmq_qmgr_system_cpu_time_percentage{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - system',
      format='time_series',
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
        fillOpacity: 10,
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

local diskUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_queue_manager_file_system_in_use_bytes{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
      format='time_series',
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
        fillOpacity: 10,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local commitsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_commit_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
      format='time_series',
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
        fillOpacity: 10,
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

local publishThroughputPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_published_to_subscribers_bytes{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
      format='time_series',
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
        fillOpacity: 10,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local publishedMessagesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_published_to_subscribers_message_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
      format='time_series',
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
        fillOpacity: 10,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local expiredMessagesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_expired_message_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
      format='time_series',
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
        fillOpacity: 10,
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

local queueOperationsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqset_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQSET',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqinq_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQINQ',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqget_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQGET',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqopen_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQOPEN',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqclose_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQCLOSE',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqput_mqput1_count{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"})',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - MQPUT/MQPUT1',
      format='time_series',
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
        fillOpacity: 10,
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
      unit: 'operations',
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

local logLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_log_write_latency_seconds{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
      format='time_series',
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
        fillOpacity: 10,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local logUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_log_in_use_bytes{' + matcher + ', mq_cluster=~"$mq_cluster", qmgr=~"$qmgr"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}}',
      format='time_series',
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
        fillOpacity: 10,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local errorLogsPanel(cfg) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + logExpr(cfg.logExpression) + '} |= `` | (filename=~"/var/mqm/qmgrs/.*/errors/.*LOG" or log_type="mq-qmgr-error")',
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
            template.new(
              'cluster',
              promDatasource,
              'label_values(ibmmq_qmgr_commit_count{job=~"$job"}, cluster)',
              label='Cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='',
              hide=if $._config.enableMultiCluster then '' else 'variable',
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
            activeListenersPanel(getMatcher($._config)) { gridPos: { h: 7, w: 4, x: 0, y: 0 } },
            activeConnectionsPanel(getMatcher($._config)) { gridPos: { h: 7, w: 4, x: 4, y: 0 } },
            queuesPanel(getMatcher($._config)) { gridPos: { h: 7, w: 4, x: 8, y: 0 } },
            estimatedMemoryUtilizationPanel(getMatcher($._config)) { gridPos: { h: 7, w: 12, x: 12, y: 0 } },
            queueManagerStatusPanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 0, y: 7 } },
            cpuUsagePanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 8, y: 7 } },
            diskUsagePanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 16, y: 7 } },
            commitsPanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 0, y: 14 } },
            publishThroughputPanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 8, y: 14 } },
            publishedMessagesPanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 16, y: 14 } },
            expiredMessagesPanel(getMatcher($._config)) { gridPos: { h: 7, w: 8, x: 0, y: 21 } },
            queueOperationsPanel(getMatcher($._config)) { gridPos: { h: 7, w: 16, x: 8, y: 21 } },
            logsRow { gridPos: { h: 1, w: 24, x: 0, y: 28 } },
            logLatencyPanel(getMatcher($._config)) { gridPos: { h: 7, w: 12, x: 0, y: 29 } },
            logUsagePanel(getMatcher($._config)) { gridPos: { h: 7, w: 12, x: 12, y: 29 } },
          ],
          if $._config.enableLokiLogs then [
            errorLogsPanel($._config) { gridPos: { h: 8, w: 24, x: 0, y: 36 } },
          ] else [],
          [
          ],
        ])
      ),

  },
}
