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

local numberOfQueuesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'count by(instance, activemq_cluster) (activemq_queue_queue_size{activemq_cluster=~"$activemq_cluster", instance=~"$instance", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Number of queues',
  description: 'Number of queues connected with the broker instance.',
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
    colorMode: 'none',
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
  pluginVersion: '10.2.0-59981',
};

local queueSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (instance, activemq_cluster) (activemq_queue_queue_size{job=~"$job",activemq_cluster=~"$activemq_cluster",instance=~"$instance"})',
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
    },
    overrides: [],
  },
  options: {
    colorMode: 'none',
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
  pluginVersion: '10.2.0-59981',
};

local producerCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_queue_producer_count{activemq_cluster=~"$activemq_cluster", job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Producer count',
  description: 'The number of producers attached to queue destinations.',
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
    colorMode: 'none',
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
  pluginVersion: '10.2.0-59981',
};

local consumerCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance,activemq_cluster) (activemq_queue_consumer_count{activemq_cluster=~"$activemq_cluster", instance=~"$instance", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Consumer count',
  description: 'The number of consumers subscribed to queue destinations.',
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
    colorMode: 'none',
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
  pluginVersion: '10.2.0-59981',
};

local topQueuesByEnqueueRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster) ($k_selector, rate(activemq_queue_enqueue_count{job=~"$job", activemq_cluster=~"$activemq_cluster",instance=~"$instance", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by enqueue rate',
  description: 'The rate messages sent to the top k queue destinations.',
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

local topQueuesByDequeueRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster) ($k_selector, rate(activemq_queue_dequeue_count{job=~"$job", instance=~"$instance", activemq_cluster=~"$activemq_cluster", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by dequeue rate',
  description: 'The rate messages have been acknowledged (and removed) from the top k queue destinations.',
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

local topQueuesByAverageEnqueueTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster) ($k_selector, activemq_queue_average_enqueue_time{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance", destination=~".*$name.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by average enqueue time',
  description: 'Average time a message was held on top k queue destinations.',
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

local topQueuesByExpiredMessageRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster) ($k_selector, rate(activemq_queue_expired_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance", destination=~".*$name.*"}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - {{destination}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top queues by expired message rate',
  description: 'The rate messages have expired on the top k queue destinations.',
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

local topQueuesByAverageMessageSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk by(instance, activemq_cluster) ($k_selector, activemq_queue_average_message_size{job=~"$job",activemq_cluster=~"$activemq_cluster", instance=~"$instance", destination=~".*$name.*"})',
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

local queueSummaryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(activemq_queue_enqueue_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance", destination=~".*$name.*"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'rate(activemq_queue_dequeue_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance", destination=~".*$name.*"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'activemq_queue_average_enqueue_time{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance", destination=~".*$name.*"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='table',
    ),
    prometheus.target(
      'activemq_queue_average_message_size{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance", destination=~".*$name.*"}',
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
            value: null,
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
  pluginVersion: '10.2.0-59981',
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
          template.new(
            'instance',
            promDatasource,
            'label_values(activemq_topic_producer_count{activemq_cluster=~"$activemq_cluster"},instance)',
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'k_selector',
            promDatasource,
            '2,4,6,8,10',
            label='Top k count',
            refresh=0,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'name',
            promDatasource,
            '.*',
            label='Queue by name',
            refresh=0,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          numberOfQueuesPanel { gridPos: { h: 4, w: 6, x: 0, y: 0 } },
          queueSizePanel { gridPos: { h: 4, w: 6, x: 6, y: 0 } },
          producerCountPanel { gridPos: { h: 4, w: 6, x: 12, y: 0 } },
          consumerCountPanel { gridPos: { h: 4, w: 6, x: 18, y: 0 } },
          topQueuesByEnqueueRatePanel { gridPos: { h: 8, w: 12, x: 0, y: 4 } },
          topQueuesByDequeueRatePanel { gridPos: { h: 8, w: 12, x: 12, y: 4 } },
          topQueuesByAverageEnqueueTimePanel { gridPos: { h: 8, w: 12, x: 0, y: 12 } },
          topQueuesByExpiredMessageRatePanel { gridPos: { h: 8, w: 12, x: 12, y: 12 } },
          topQueuesByAverageMessageSizePanel { gridPos: { h: 7, w: 24, x: 0, y: 20 } },
          queueSummaryPanel { gridPos: { h: 7, w: 24, x: 0, y: 27 } },
        ]
      ),
  },
}
