local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-activemq-queue-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local numberOfQueuesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count by(instance, activemq_cluster, job) (activemq_queue_queue_size{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Queues',
  description: 'Number of queues connected with the broker instance.',
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

local queueSizePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (instance, activemq_cluster, job) (activemq_queue_queue_size{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Queue size',
  description: 'Number of messages in queue destinations.',
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
      'sum by(instance, activemq_cluster, job) (activemq_queue_producer_count{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Producers',
  description: 'The number of producers attached to queue destinations.',
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
      'sum by(instance,activemq_cluster, job) (activemq_queue_consumer_count{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Consumers',
  description: 'The number of consumers subscribed to queue destinations.',
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

local topQueuesByEnqueueRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, rate(activemq_queue_enqueue_count{' + matcher + ', instance=~"$instance", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by enqueue rate',
  description: 'The rate messages sent to queue destinations.',
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

local topQueuesByDequeueRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster) ($k_selector, rate(activemq_queue_dequeue_count{' + matcher + ',instance=~"$instance", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by dequeue rate',
  description: 'The rate messages have been acknowledged (and removed) from queue destinations.',
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

local topQueuesByAverageEnqueueTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster) ($k_selector, activemq_queue_average_enqueue_time{' + matcher + ', instance=~"$instance", destination=~".*$name.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by average enqueue time',
  description: 'Average time a message was held on queue destinations.',
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

local topQueuesByExpiredMessageRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, rate(activemq_queue_expired_count{' + matcher + ', instance=~"$instance", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by expired message rate',
  description: 'The rate messages have expired on queue destinations.',
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

local topQueuesByAverageMessageSizePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster, job) ($k_selector, activemq_queue_average_message_size{' + matcher + ', instance=~"$instance", destination=~".*$name.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by average message size',
  description: 'Average message size on queue destinations.',
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
          mode: 'none',
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

local queueSummaryPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(activemq_queue_enqueue_count{' + matcher + ', instance=~"$instance", destination=~".*$name.*"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'rate(activemq_queue_dequeue_count{' + matcher + ', instance=~"$instance", destination=~".*$name.*"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'activemq_queue_average_enqueue_time{' + matcher + ', instance=~"$instance", destination=~".*$name.*"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'activemq_queue_average_message_size{' + matcher + ', instance=~"$instance", destination=~".*$name.*"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Queue summary',
  description: 'Summary of queues showing queue name, enqueue and dequeue rate, average enqueue time, and average message size.',
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
    sortBy: [
      {
        desc: false,
        displayName: '{activemq_cluster="cluster-a", destination="TEST", instance="localhost:12345", job="integrations/activemq"}',
      },
    ],
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
          'activemq_cluster 1': true,
          'activemq_cluster 2': true,
          'activemq_cluster 3': true,
          'activemq_cluster 4': true,
          'instance 1': true,
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
          'Time 1': '',
          'Value #A': 'Enqueue rate',
          'Value #B': 'Dequeue rate',
          'Value #C': 'Average enqueue time',
          'Value #D': 'Average message size',
          'activemq_cluster 1': '',
          destination: 'Destination',
        },
      },
    },
  ],
};

local getMatcher(cfg) = '%(activemqSelector)s, activemq_cluster=~"$activemq_cluster"' % cfg;

{
  grafanaDashboards+:: {
    'apache-activemq-queue-overview.json':
      dashboard.new(
        'Apache ActiveMQ queue overview',
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
            'cluster',
            promDatasource,
            'label_values(activemq_memory_usage_ratio{job=~"$job"},cluster)',
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
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
            allValues='',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(activemq_topic_producer_count{%(activemqSelector)s, activemq_cluster=~"$activemq_cluster"},instance)' % $._config,
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.custom(
            'k_selector',
            query='2,4,6,8,10',
            current='4',
            label='Top queue count',
            refresh='never',
            includeAll=false,
            multi=false,
            allValues=''
          ),
          template.text(
            'name',
            label='Queue by name',
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
          numberOfQueuesPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 0, y: 0 } },
          queueSizePanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 6, y: 0 } },
          producerCountPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 12, y: 0 } },
          consumerCountPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 18, y: 0 } },
          topQueuesByEnqueueRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 4 } },
          topQueuesByDequeueRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 4 } },
          topQueuesByAverageEnqueueTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 12 } },
          topQueuesByExpiredMessageRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 12 } },
          topQueuesByAverageMessageSizePanel(getMatcher($._config)) { gridPos: { h: 7, w: 24, x: 0, y: 20 } },
          queueSummaryPanel(getMatcher($._config)) { gridPos: { h: 7, w: 24, x: 0, y: 27 } },
        ]
      ),
  },
}
