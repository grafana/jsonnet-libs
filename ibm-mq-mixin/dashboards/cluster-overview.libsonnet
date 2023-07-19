local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'ibm-mq-cluster-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};


local clustersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count(ibmmq_qmgr_commit_count{job=~"$job"}) by (mq_cluster))',
      datasource=promDatasource,
      legendFormat='{{job}} - {{mq_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Clusters',
  description: 'The unique number of clusters being reported.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
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
            value: 0,
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
};

local queueManagersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count(ibmmq_qmgr_commit_count{job=~"$job"}) by (qmgr, mq_cluster))',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Queue managers',
  description: 'The unique number of queue managers in the cluster being reported.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
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
            value: 0,
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
};

local topicsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count(ibmmq_topic_messages_received{job=~"$job"}) by (topic, mq_cluster))',
      datasource=promDatasource,
      legendFormat='{{job}} - {{mq_cluster}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Topics',
  description: 'The unique number of topics in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
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
            value: 0,
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
};

local queuesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count(count(ibmmq_queue_depth{job=~"$job"}) by (queue, mq_cluster))',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Queues',
  description: 'The unique number of queues in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
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
            value: 0,
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
  pluginVersion: '10.0.3-cloud.2.14737d80',
};

local queueOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (mq_cluster) (ibmmq_queue_mqset_count{mq_cluster=~"$mq_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='MQSET',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster) (ibmmq_queue_mqinq_count{mq_cluster=~"$mq_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='MQINQ',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster) (ibmmq_queue_mqget_count{mq_cluster=~"$mq_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='MQGET',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster) (ibmmq_queue_mqopen_count{mq_cluster=~"$mq_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='MQOPEN',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster) (ibmmq_queue_mqclose_count{mq_cluster=~"$mq_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='MQCLOSE',
      format='time_series',
    ),
    prometheus.target(
      'sum by (mq_cluster) (ibmmq_queue_mqput_mqput1_count{mq_cluster=~"$mq_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='MQPUT/MQPUT1',
      format='time_series',
    ),
  ],
  type: 'piechart',
  title: 'Queue operations',
  description: 'The number of queue operations of the cluster. ',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
      },
      mappings: [],
      unit: 'operations',
    },
    overrides: [
      {
        __systemRef: 'hideSeriesFrom',
        matcher: {
          id: 'byNames',
          options: {
            mode: 'exclude',
            names: [
              'MQINQ',
              'MQGET',
              'MQOPEN',
              'MQPUT/MQPUT1',
            ],
            prefix: 'All except:',
            readOnly: true,
          },
        },
        properties: [
          {
            id: 'custom.hideFrom',
            value: {
              legend: false,
              tooltip: false,
              viz: true,
            },
          },
        ],
      },
    ],
  },
  options: {
    legend: {
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    pieType: 'pie',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    tooltip: {
      mode: 'multi',
      sort: 'none',
    },
  },
};

local clusterStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_cluster_suspend{mq_cluster=~"$mq_cluster", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{job}} - {{mq_cluster}}',
      format='time_series',
    ),
  ],
  type: 'table',
  title: 'Cluster status',
  description: 'The status of the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
      },
      custom: {
        align: 'center',
        cellOptions: {
          type: 'color-text',
        },
        inspect: false,
      },
      mappings: [
        {
          options: {
            '0': {
              color: 'green',
              index: 0,
              text: 'Not suspended',
            },
            '1': {
              color: 'red',
              index: 1,
              text: 'Suspended',
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
  },
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transformations: [
    {
      id: 'joinByLabels',
      options: {
        join: [
          'cluster',
          'mq_cluster',
          'qmgr',
        ],
        value: '__name__',
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {},
        indexByName: {},
        renameByName: {
          cluster: 'Cluster',
          ibmmq_cluster_suspend: 'Status',
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
          'last',
        ],
      },
    },
  ],
};

local queueManagerStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_qmgr_status{mq_cluster=~"$mq_cluster", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'table',
  title: 'Queue manager status',
  description: 'The queue managers of the cluster displayed in a table.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
      },
      custom: {
        align: 'center',
        cellOptions: {
          type: 'color-text',
        },
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
    cellHeight: 'sm',
    footer: {
      countRows: false,
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
        displayName: 'ibmmq_qmgr_status{description="-", hostname="keith-ibm-mq-1804-2-test", instance="localhost:9157", job="integrations/ibm_mq", mq_cluster="<mq_cluster>", platform="UNIX", qmgr="QM1"}',
      },
    ],
  },
  pluginVersion: '10.0.3-cloud.2.14737d80',
  transformations: [
    {
      id: 'joinByLabels',
      options: {
        join: [
          'mq_cluster',
          'qmgr',
          'instance',
        ],
        value: '__name__',
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {},
        indexByName: {},
        renameByName: {
          ibmmq_qmgr_status: 'Status',
          instance: 'Instance',
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
          'last',
        ],
      },
    },
  ],
};

local transmissionQueueTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'ibmmq_channel_xmitq_time_short{type="SENDER",job=~"$job", mq_cluster=~"$mq_cluster"}',
      datasource=promDatasource,
      legendFormat='{{channel}} - short',
      format='time_series',
    ),
    prometheus.target(
      'ibmmq_channel_xmitq_time_long{type=~"SENDER", job=~"$job", mq_cluster=~"$mq_cluster"}',
      datasource=promDatasource,
      legendFormat='{{channel}} - long',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Transmission queue time',
  description: 'The time it takes for the messages to get through the transmission queue. (Long) - total time taken for messages to be transmitted over the channel, (Short) - an average, minimum, or maximum time taken to transmit messages over the channel in recent intervals.  ',
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
      unit: 'µs',
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


{
  grafanaDashboards+:: {
    'ibm-mq-cluster-overview.json':
      dashboard.new(
        'IBM MQ cluster overview',
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
            'label_values(ibmmq_qmgr_commit_count,job)',
            label='Job',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'mq_cluster',
            promDatasource,
            'label_values(ibmmq_qmgr_commit_count,mq_cluster)',
            label='MQ cluster',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
        ]
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other IBM MQ dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addPanels(
        [
          clustersPanel { gridPos: { h: 7, w: 4, x: 0, y: 0 } },
          queueManagersPanel { gridPos: { h: 7, w: 4, x: 4, y: 0 } },
          topicsPanel { gridPos: { h: 7, w: 4, x: 8, y: 0 } },
          queuesPanel { gridPos: { h: 7, w: 4, x: 12, y: 0 } },
          queueOperationsPanel { gridPos: { h: 15, w: 8, x: 16, y: 0 } },
          clusterStatusPanel { gridPos: { h: 4, w: 16, x: 0, y: 7 } },
          queueManagerStatusPanel { gridPos: { h: 4, w: 16, x: 0, y: 11 } },
          transmissionQueueTimePanel { gridPos: { h: 8, w: 24, x: 0, y: 15 } },
        ]
      ),

  },
}
