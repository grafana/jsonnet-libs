local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'ibm-mq-queue-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local averageQueueTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_queue_average_queue_time_seconds{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - {{queue}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Average queue time',
  description: 'The average amount of time a message spends in the queue.',
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

local expiredMessagesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_queue_expired_messages{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - {{queue}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Expired messages',
  description: 'The amount of expired messages in the queue.',
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
      sort: 'desc',
    },
  },
};

local depthPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_queue_depth{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - {{queue}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Depth',
  description: 'The number of active messages in the queue.',
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

local operationThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_queue_mqget_bytes{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{qmgr}} - {{queue}} - MQGET',
      format='time_series',
    ),
    prometheus.target(
      'ibmmq_queue_mqput_bytes{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{qmgr}} - {{queue}} - MQPUT',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Operation throughput',
  description: 'The amount of throughput going through the queue via MQGETs and MQPUTs.',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local operationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_queue_mqset_count{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{qmgr}} - {{queue}} - MQSET',
      format='time_series',
    ),
    prometheus.target(
      'ibmmq_queue_mqinq_count{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{qmgr}} - {{queue}} - MQINQ',
      format='time_series',
    ),
    prometheus.target(
      'ibmmq_queue_mqget_count{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{qmgr}} - {{queue}} - MQGET',
      format='time_series',
    ),
    prometheus.target(
      'ibmmq_queue_mqopen_count{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{qmgr}} - {{queue}} - MQOPEN',
      format='time_series',
    ),
    prometheus.target(
      'ibmmq_queue_mqclose_count{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{qmgr}} - {{queue}} - MQCLOSE',
      format='time_series',
    ),
    prometheus.target(
      'ibmmq_queue_mqput_mqput1_count{job=~"$job", mq_cluster=~"$mq_cluster", qmgr=~"$qmgr", queue=~"$queue"}',
      datasource=promDatasource,
      legendFormat='{{qmgr}} - {{queue}} - MQPUT/MQPUT1',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Operations',
  description: 'The number of queue operations of the queue manager.',
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
      unit: 'operations',
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
      sort: 'desc',
    },
  },
};

{
  grafanaDashboards+:: {
    'ibm-mq-queue-overview.json':
      dashboard.new(
        'IBM MQ queue overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )

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
            'label_values(ibmmq_queue_average_queue_time_seconds,job)',
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
            'label_values(ibmmq_queue_average_queue_time_seconds{job=~"$job"},mq_cluster)',
            label='MQ cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'qmgr',
            promDatasource,
            'label_values(ibmmq_queue_average_queue_time_seconds{mq_cluster=~"$mq_cluster"},qmgr)',
            label='Queue manager',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'queue',
            promDatasource,
            'label_values(ibmmq_queue_average_queue_time_seconds{qmgr=~"$qmgr"},queue)',
            label='Queue',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          averageQueueTimePanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          expiredMessagesPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          depthPanel { gridPos: { h: 8, w: 24, x: 0, y: 8 } },
          operationThroughputPanel { gridPos: { h: 8, w: 9, x: 0, y: 16 } },
          operationsPanel { gridPos: { h: 8, w: 15, x: 9, y: 16 } },
        ]
      ),
  },
}
