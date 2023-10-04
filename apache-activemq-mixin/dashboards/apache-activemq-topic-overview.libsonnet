local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-activemq-topic-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local numberOfTopicsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count (activemq_topic_queue_size{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"})',
      datasource=promDatasource,
      legendFormat='__auto',
    ),
  ],
  type: 'stat',
  title: 'Topics',
  description: 'Number of topics connected with the broker instance.',
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
      'sum (activemq_topic_producer_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"})',
      datasource=promDatasource,
      legendFormat='__auto',
    ),
  ],
  type: 'stat',
  title: 'Producers',
  description: 'The number of producers attached to topic destinations.',
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
      'sum (activemq_topic_consumer_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"})',
      datasource=promDatasource,
      legendFormat='__auto',
    ),
  ],
  type: 'stat',
  title: 'Consumers',
  description: 'The number of consumers subscribed to topic destinations.',
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

local averageConsumersPerTopicPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg (activemq_topic_consumer_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"})',
      datasource=promDatasource,
      legendFormat='__auto',
    ),
  ],
  type: 'stat',
  title: 'Average consumers per topic',
  description: 'Average number of consumers per topic.',
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

local topTopicsByEnqueueRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, rate(activemq_topic_enqueue_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top topics by enqueue rate',
  description: 'The rate messages are sent to topic destinations.',
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
      unit: 'mps',
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

local topTopicsByDequeueRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, rate(activemq_topic_dequeue_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top topics by dequeue rate',
  description: 'The rate messages have been acknowledged (and removed) from topic destinations',
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
      unit: 'mps',
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

local topTopicsByAverageEnqueueTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, activemq_topic_average_enqueue_time{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top topics by average enqueue time',
  description: 'Average time a message was held across all topic destinations.',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topTopicsByExpiredMessageRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, rate(activemq_topic_expired_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top topics by expired message rate',
  description: 'The rate messages have expired on topic destinations.',
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
      unit: 'mps',
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

local topTopicsByConsumersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, activemq_topic_consumer_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'bargauge',
  title: 'Top topics by consumers',
  description: 'The number of consumers subscribed to the most active/used topics.',
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
    showUnfilled: true,
    valueMode: 'color',
  },
  pluginVersion: '10.2.0-60139',
};

local topTopicsByAverageMessageSizePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, activemq_topic_average_message_size{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top topics by average message size',
  description: 'Average message size on topic destinations.',
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
        axisSoftMin: 0,
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
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
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

local topicSummaryPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(activemq_topic_enqueue_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'rate(activemq_topic_dequeue_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'activemq_topic_average_enqueue_time{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'activemq_topic_average_message_size{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Topic summary',
  description: 'Summary of topics showing topic name, enqueue and dequeue rate, average enqueue time, and average message size.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        inspect: false,
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
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'Enqueue rate',
        },
        properties: [
          {
            id: 'unit',
            value: 'mps',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Dequeue rate',
        },
        properties: [
          {
            id: 'unit',
            value: 'mps',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Average enqueue time',
        },
        properties: [
          {
            id: 'unit',
            value: 'ms',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Average message size',
        },
        properties: [
          {
            id: 'unit',
            value: 'decbytes',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'ActiveMQ Cluster',
        },
        properties: [
          {
            id: 'links',
            value: [
              {
                title: 'Cluster link',
                url: 'd/apache-activemq-cluster-overview?var-activemq_cluster=${__data.fields.activemq_cluster}&${__url_time_range}&var-datasource=${datasource}',
              },
            ],
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Instance',
        },
        properties: [
          {
            id: 'links',
            value: [
              {
                title: 'Instance link',
                url: 'd/apache-activemq-instance-overview?var-instance=${__data.fields.instance}&${__url_time_range}&var-datasource=${datasource}',
              },
            ],
          },
        ],
      },
    ],
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
  },
  pluginVersion: '10.2.0-60139',
  transformations: [
    {
      id: 'joinByField',
      options: {
        byField: 'destination',
        mode: 'outer',
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {
          'Time 1': true,
          'Time 2': true,
          'Time 3': true,
          'Time 4': true,
          '__name__ 1': true,
          '__name__ 2': true,
          '__replica__ 1': true,
          '__replica__ 2': true,
          '__replica__ 3': true,
          '__replica__ 4': true,
          'container 1': true,
          'container 2': true,
          'container 3': true,
          'container 4': true,
          'endpoint 1': true,
          'endpoint 2': true,
          'endpoint 3': true,
          'endpoint 4': true,
          'namespace 1': true,
          'namespace 2': true,
          'namespace 3': true,
          'namespace 4': true,
          'pod 1': true,
          'pod 2': true,
          'pod 3': true,
          'pod 4': true,
          'service 1': true,
          'service 2': true,
          'service 3': true,
          'service 4': true,
          'activemq_cluster 1': false,
          'activemq_cluster 2': true,
          'activemq_cluster 3': true,
          'activemq_cluster 4': true,
          'cluster 1': true,
          'cluster 2': true,
          'cluster 3': true,
          'cluster 4': true,
          'instance 1': false,
          'instance 2': true,
          'instance 3': true,
          'instance 4': true,
          'job 1': true,
          'job 2': true,
          'job 3': true,
          'job 4': true,
        },
        indexByName: {},
        renameByName: {
          'Time 3': '',
          'Value #A': 'Enqueue rate',
          'Value #B': 'Dequeue rate',
          'Value #C': 'Average enqueue time',
          'Value #D': 'Average message size',
          'activemq_cluster 1': 'ActiveMQ Cluster',
          destination: 'Destination',
          'instance 1': 'Instance',
        },
      },
    },
  ],
};

local getMatcher(cfg) = '%(activemqSelector)s, activemq_cluster=~"$activemq_cluster"' % cfg;

{
  grafanaDashboards+:: {
    'apache-activemq-topic-overview.json':
      dashboard.new(
        'Apache ActiveMQ topic overview',
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
            'label_values(activemq_memory_usage_ratio{job=~"$job"},cluster)',
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
          template.new(
            'instance',
            promDatasource,
            'label_values(activemq_topic_producer_count{%(activemqSelector)s,activemq_cluster=~"$activemq_cluster"},instance)' % $._config,
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.custom(
            'k_selector',
            query='2,4,6,8,10',
            current='4',
            label='Top topic count',
            refresh='never',
            includeAll=false,
            multi=false,
            allValues='',
          ),
          template.text(
            'name',
            label='Topic by name',
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
          numberOfTopicsPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 0, y: 0 } },
          producerCountPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 6, y: 0 } },
          consumerCountPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 12, y: 0 } },
          averageConsumersPerTopicPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 18, y: 0 } },
          topTopicsByEnqueueRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 4 } },
          topTopicsByDequeueRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 4 } },
          topTopicsByAverageEnqueueTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 12 } },
          topTopicsByExpiredMessageRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 12 } },
          topTopicsByConsumersPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 20 } },
          topTopicsByAverageMessageSizePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 20 } },
          topicSummaryPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 28 } },
        ]
      ),
  },
}
