local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'ibm-mq-topics-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local topicsRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Topics',
};

local topicMessagesReceivedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_topic_messages_received{job=~"$job",mq_cluster=~"$mq_cluster",qmgr=~"$qmgr",topic=~"$topic"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - {{topic}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Topic messages received',
  description: 'Received messages per topic.',
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
      decimals: 0,
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

local timeSinceLastMessagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_topic_time_since_msg_received{job=~"$job",mq_cluster=~"$mq_cluster",qmgr=~"$qmgr",topic=~"$topic"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - {{topic}}',
      format='time_series',
    ),
  ],
  type: 'bargauge',
  title: 'Time since last message',
  description: 'The time since the topic last received a message.',
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
    displayMode: 'basic',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'horizontal',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
    valueMode: 'color',
  },
  pluginVersion: '10.0.2',
};

local topicSubscribersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_topic_subscriber_count{job=~"$job",mq_cluster=~"$mq_cluster",qmgr=~"$qmgr",topic=~"$topic"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - {{topic}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Topic subscribers',
  description: 'The number of subscribers per topic.',
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
      decimals: 0,
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

local topicPublishersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_topic_publisher_count{job=~"$job",mq_cluster=~"$mq_cluster",qmgr=~"$qmgr",topic=~"$topic"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - {{topic}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Topic publishers',
  description: 'The number of publishers per topic.',
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
      decimals: 0,
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

local subscriptionsRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Subscriptions',
  collapsed: false,
};

local subscriptionMessagesReceivedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_subscription_messsages_received{job=~"$job",mq_cluster=~"$mq_cluster",qmgr=~"$qmgr",subscription=~"$subscription"}',
      datasource=promDatasource,
      legendFormat='{{mq_cluster}} - {{qmgr}} - {{subscription}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Subscription messages received',
  description: 'The number of messages a subscription receives.',
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
      decimals: 0,
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
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
  transformations: [],
};

local subscriptionStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_subscription_time_since_message_published{job=~"$job",mq_cluster=~"$mq_cluster",qmgr=~"$qmgr",subscription=~"$subscription"}',
      datasource=promDatasource,
      legendFormat='{{label_name}}',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Subscription status',
  description: 'A table for at a glance information about a subscription.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'center',
        cellOptions: {
          type: 'auto',
        },
        filterable: false,
        inspect: false,
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
    showHeader: true,
    sortBy: [
      {
        desc: false,
        displayName: 'subid',
      },
    ],
  },
  pluginVersion: '10.0.2',
  transformations: [
    {
      id: 'organize',
      options: {
        excludeByName: {
          Time: true,
          __name__: true,
          instance: true,
          job: true,
          platform: true,
          subid: true,
          type: false,
        },
        indexByName: {
          Time: 6,
          Value: 5,
          __name__: 7,
          instance: 8,
          job: 9,
          mq_cluster: 1,
          platform: 10,
          qmgr: 0,
          subid: 11,
          subscription: 2,
          topic: 4,
          type: 3,
        },
        renameByName: {},
      },
    },
    {
      id: 'groupBy',
      options: {
        fields: {
          Value: {
            aggregations: [
              'last',
            ],
            operation: 'aggregate',
          },
          mq_cluster: {
            aggregations: [],
            operation: 'groupby',
          },
          qmgr: {
            aggregations: [],
            operation: 'groupby',
          },
          subscription: {
            aggregations: [],
            operation: 'groupby',
          },
          topic: {
            aggregations: [],
            operation: 'groupby',
          },
          type: {
            aggregations: [],
            operation: 'groupby',
          },
        },
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {},
        indexByName: {},
        renameByName: {
          'Value (last)': 'Time since last subscription message',
          'Value (lastNotNull)': 'Time since last subscription message',
        },
      },
    },
  ],
};

{
  grafanaDashboards+:: {
    'ibm-mq-topics-overview.json':
      dashboard.new(
        'IBM MQ topics overview',
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
            'label_values(ibmmq_topic_messages_received,job)',
            label='Job',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'mq_cluster',
            promDatasource,
            'label_values(ibmmq_topic_messages_received{job=~"$job"},mq_cluster)',
            label='MQ cluster',
            refresh=2,
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
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'topic',
            promDatasource,
            'label_values(ibmmq_topic_subscriber_count{qmgr=~"$qmgr",topic!~"SYSTEM.*|\\\\$SYS.*|"},topic)',
            label='Topic',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'subscription',
            promDatasource,
            'label_values(ibmmq_subscription_messsages_received{qmgr=~"$qmgr",subscription!~"SYSTEM.*|"},subscription)',
            label='Subscription',
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
          topicsRow { gridPos: { h: 1, w: 24, x: 0, y: 0 } },
          topicMessagesReceivedPanel { gridPos: { h: 6, w: 16, x: 0, y: 1 } },
          timeSinceLastMessagePanel { gridPos: { h: 6, w: 8, x: 16, y: 1 } },
          topicSubscribersPanel { gridPos: { h: 6, w: 12, x: 0, y: 7 } },
          topicPublishersPanel { gridPos: { h: 6, w: 12, x: 12, y: 7 } },
          subscriptionsRow { gridPos: { h: 1, w: 24, x: 0, y: 13 } },
          subscriptionMessagesReceivedPanel { gridPos: { h: 6, w: 24, x: 0, y: 14 } },
          subscriptionStatusPanel { gridPos: { h: 10, w: 24, x: 0, y: 20 } },
        ]
      ),
  },
}
