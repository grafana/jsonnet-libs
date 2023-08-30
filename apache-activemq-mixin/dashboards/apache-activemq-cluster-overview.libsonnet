local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-activemq-cluster-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local clusterCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count by (activemq_cluster) (activemq_memory_usage_ratio{job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'stat',
  title: 'Cluster count',
  description: 'Number of clusters that are reporting metrics from ActiveMQ.',
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
      unit: 'none',
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
  pluginVersion: '10.2.0-59585pre',
};

local brokerCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count by (instance, activemq_cluster) (activemq_memory_usage_ratio{job=~"$job", activemq_cluster=~"$activemq_cluster"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'stat',
  title: 'Broker count',
  description: 'Number of broker instances across clusters.',
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
      unit: 'none',
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
  pluginVersion: '10.2.0-59585pre',
};

local producerCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (activemq_cluster) (activemq_producer_total{job=~"$job", activemq_cluster="$activemq_cluster"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'stat',
  title: 'Producer count',
  description: 'Number of message producers active on destinations across clusters.',
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
      unit: 'none',
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
  pluginVersion: '10.2.0-59585pre',
};

local consumerCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (activemq_cluster) (activemq_consumer_total{job=~"$job", activemq_cluster=~"$activemq_cluster"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'stat',
  title: 'Consumer count',
  description: 'The number of consumers subscribed to destinations across clusters.',
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
      unit: 'none',
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
  pluginVersion: '10.2.0-59585pre',
};

local enqueueCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (activemq_cluster) (activemq_enqueue_total{job=~"$job", activemq_cluster=~"$activemq_cluster"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Enqueue count',
  description: 'Number of messages that have been sent to destinations in a cluster',
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
        fillOpacity: 25,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
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

local dequeueCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (activemq_cluster) (activemq_dequeue_total{job=~"$job", activemq_cluster=~"$activemq_cluster"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Dequeue count',
  description: 'Number of messages that have been acknowledged (and removed) from destinations in a cluster.',
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
        fillOpacity: 25,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
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

local averageTemporaryMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (activemq_cluster) (activemq_temp_usage_ratio{job=~"$job", activemq_cluster=~"$activemq_cluster"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'bargauge',
  title: 'Average temporary memory usage',
  description: 'Average percentage of temporary memory used across clusters.',
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
          {
            color: 'red',
            value: 70,
          },
        ],
      },
      unit: 'percent',
    },
    overrides: [],
  },
  options: {
    displayMode: 'gradient',
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
    showUnfilled: false,
    text: {},
    valueMode: 'color',
  },
  pluginVersion: '10.2.0-59585pre',
};

local averageStoreMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (activemq_cluster) (activemq_store_usage_ratio{job=~"$job", activemq_cluster=~"$activemq_cluster"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'bargauge',
  title: 'Average store memory usage',
  description: 'Average percentage of store memory used across clusters.',
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
          {
            color: 'red',
            value: 70,
          },
        ],
      },
      unit: 'percent',
    },
    overrides: [],
  },
  options: {
    displayMode: 'gradient',
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
    showUnfilled: false,
    valueMode: 'color',
  },
  pluginVersion: '10.2.0-59585pre',
};

local averageBrokerMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (activemq_cluster) (activemq_memory_usage_ratio{job=~"$job", activemq_cluster=~"$activemq_cluster"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'bargauge',
  title: 'Average broker memory usage',
  description: 'Average percentage of broker memory used across clusters.',
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
          {
            color: 'red',
            value: 70,
          },
        ],
      },
      unit: 'percent',
    },
    overrides: [],
  },
  options: {
    displayMode: 'gradient',
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
    showUnfilled: false,
    valueMode: 'color',
  },
  pluginVersion: '10.2.0-59585pre',
};

{
  grafanaDashboards+:: {
    'apache-activemq-cluster-overview.json':
      dashboard.new(
        'Apache ActiveMQ cluster overview',
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
            'label_values(activemq_topic_producer_count,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'activemq_cluster',
            promDatasource,
            'label_values(activemq_memory_usage_ratio{job=~"$job"},activemq_cluster)',
            label='ActiveMQ cluster',
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
          clusterCountPanel { gridPos: { h: 6, w: 6, x: 0, y: 0 } },
          brokerCountPanel { gridPos: { h: 6, w: 6, x: 6, y: 0 } },
          producerCountPanel { gridPos: { h: 6, w: 6, x: 12, y: 0 } },
          consumerCountPanel { gridPos: { h: 6, w: 6, x: 18, y: 0 } },
          enqueueCountPanel { gridPos: { h: 8, w: 12, x: 0, y: 6 } },
          dequeueCountPanel { gridPos: { h: 8, w: 12, x: 12, y: 6 } },
          averageTemporaryMemoryUsagePanel { gridPos: { h: 10, w: 8, x: 0, y: 14 } },
          averageStoreMemoryUsagePanel { gridPos: { h: 10, w: 8, x: 8, y: 14 } },
          averageBrokerMemoryUsagePanel { gridPos: { h: 10, w: 8, x: 16, y: 14 } },
        ]
      ),
  },
}
