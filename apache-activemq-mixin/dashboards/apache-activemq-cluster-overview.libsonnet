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

local clusterCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count by (activemq_cluster, job) (activemq_memory_usage_ratio{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'stat',
  title: 'Clusters',
  description: 'Number of clusters that are reporting metrics from ActiveMQ.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
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
    colorMode: 'none',
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
  pluginVersion: '10.2.0-60139',
};

local brokerCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count by (instance, activemq_cluster, job) (activemq_memory_usage_ratio{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'stat',
  title: 'Brokers',
  description: 'Number of broker instances across clusters.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
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
    colorMode: 'none',
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
  pluginVersion: '10.2.0-60139',
};

local producerCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (activemq_cluster, job) (activemq_queue_producer_count{' + matcher + '}) + sum by (activemq_cluster, job) (activemq_topic_producer_count{' + matcher + ',destination!~"ActiveMQ.Advisory.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'stat',
  title: 'Producers',
  description: 'Number of message producers active on destinations across clusters.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
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
    colorMode: 'none',
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
  pluginVersion: '10.2.0-60139',
};

local consumerCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (activemq_cluster, job) (activemq_queue_consumer_count{' + matcher + '}) + sum by (activemq_cluster, job) (activemq_topic_consumer_count{' + matcher + ',destination!~"ActiveMQ.Advisory.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
    ),
  ],
  type: 'stat',
  title: 'Consumers',
  description: 'The number of consumers subscribed to destinations across clusters.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
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
    colorMode: 'none',
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
  pluginVersion: '10.2.0-60139',
};

local enqueueCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (activemq_cluster, job) (increase(activemq_queue_enqueue_count{' + matcher + '}[$__interval:])) + sum by (activemq_cluster, job) (increase(activemq_topic_enqueue_count{' + matcher + ', destination!~"ActiveMQ.Advisory.*"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Enqueue / $__interval',
  description: 'Number of messages that have been sent to destinations in a cluster',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: '#C8F2C2',
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        axisShow: false,
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
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

local dequeueCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (activemq_cluster, job) (increase(activemq_queue_dequeue_count{' + matcher + '}[$__interval:])) + sum by (activemq_cluster, job) (increase(activemq_topic_dequeue_count{' + matcher + ', destination!~"ActiveMQ.Advisory.*"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Dequeue / $__interval',
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
        axisShow: false,
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
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

local averageTemporaryMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (activemq_cluster, job) (activemq_temp_usage_ratio{' + matcher + '})',
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
      max: 1,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: '#EAB839',
            value: 50,
          },
          {
            color: 'red',
            value: 70,
          },
        ],
      },
      unit: 'percentunit',
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
  pluginVersion: '10.2.0-60139',
};

local averageStoreMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (activemq_cluster, job) (activemq_store_usage_ratio{' + matcher + '})',
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
      max: 1,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: '#EAB839',
            value: 50,
          },
          {
            color: 'red',
            value: 70,
          },
        ],
      },
      unit: 'percentunit',
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
  pluginVersion: '10.2.0-60139',
};

local averageBrokerMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (activemq_cluster, job) (activemq_memory_usage_ratio{' + matcher + '})',
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
      max: 1,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: '#EAB839',
            value: 50,
          },
          {
            color: 'red',
            value: 70,
          },
        ],
      },
      unit: 'percentunit',
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
  pluginVersion: '10.2.0-60139',
};

local getMatcher(cfg) = '%(activemqSelector)s, activemq_cluster=~"$activemq_cluster"' % cfg;

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
            label='Data source',
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
            allValues='.+',
            sort=0
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(activemq_memory_usage_ratio{job=~"$job", cluster=~"$cluster"},cluster)',
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'activemq_cluster',
            promDatasource,
            'label_values(activemq_memory_usage_ratio{%(activemqSelector)s},activemq_cluster)' % $._config,
            label='ActiveMQ cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
        ]
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache ActiveMQ dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addPanels(
        [
          clusterCountPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 0, y: 0 } },
          brokerCountPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 6, y: 0 } },
          producerCountPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 12, y: 0 } },
          consumerCountPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 18, y: 0 } },
          enqueueCountPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 6 } },
          dequeueCountPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 6 } },
          averageTemporaryMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 10, w: 8, x: 0, y: 14 } },
          averageStoreMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 10, w: 8, x: 8, y: 14 } },
          averageBrokerMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 10, w: 8, x: 16, y: 14 } },
        ]
      ),
  },
}
