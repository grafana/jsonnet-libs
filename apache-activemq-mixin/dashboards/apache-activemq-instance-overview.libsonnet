local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-activemq-instance-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local averageBrokerMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (instance, activemq_cluster) (activemq_memory_usage_ratio{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'gauge',
  title: 'Average broker memory usage',
  description: 'The percentage of memory used by both topics and queues across brokers.',
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
      unit: 'percentunit',
    },
    overrides: [],
  },
  options: {
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showThresholdLabels: false,
    showThresholdMarkers: true,
  },
  pluginVersion: '10.2.0-59585pre',
};

local averageStoreMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (instance, activemq_cluster) (activemq_store_usage_ratio{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'gauge',
  title: 'Average store memory usage',
  description: 'The percentage of store memory used by both topics and queues across brokers.',
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
      unit: 'percentunit',
    },
    overrides: [],
  },
  options: {
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showThresholdLabels: false,
    showThresholdMarkers: true,
  },
  pluginVersion: '10.2.0-59585pre',
};

local averageTemporaryMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (instance, activemq_cluster) (activemq_temp_usage_ratio{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'gauge',
  title: 'Average temporary memory usage',
  description: 'The percentage of temporary memory used by both topics and queues across brokers.',
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
      unit: 'percentunit',
    },
    overrides: [],
  },
  options: {
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showThresholdLabels: false,
    showThresholdMarkers: true,
  },
  pluginVersion: '10.2.0-59585pre',
};

local producerCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance) (activemq_producer_total{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Producer count',
  description: 'The number of producers attached to destinations.',
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
      'sum by(instance) (activemq_consumer_total{instance=~"$instance",activemq_cluster=~"$activemq_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Consumer count',
  description: 'The number of consumers subscribed to destinations on the broker.',
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

local averageUnacknowledgedMessagesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (instance) (activemq_message_total{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Average unacknowledged messages',
  description: 'Average number of unacknowledged messages on the broker.',
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

local queueSizePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_queue_queue_size{instance=~"$instance", activemq_cluster=~"$activemq_cluster", job=~"$job"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
  ],
  type: 'timeseries',
  title: 'Queue size',
  description: 'Number of messages on queue destinations, including any that have been dispatched but not acknowledged.',
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

local destinationMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_queue_memory_percent_usage{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_topic_memory_percent_usage{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Destination memory usage',
  description: 'The percentage of memory being used by topic and queue destinations.',
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
        gradientMode: 'opacity',
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
      unit: 'percent',
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

local enqueueCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_queue_enqueue_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_topic_enqueue_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Enqueue count',
  description: 'Number of messages that have been sent to the destination.',
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
      'sum by(instance, activemq_cluster) (activemq_queue_dequeue_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_topic_dequeue_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Dequeue count',
  description: 'Number of messages that have been acknowledged (and removed) from the destinations.',
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

local averageEnqueueTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (activemq_cluster, instance) (activemq_queue_average_enqueue_time{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'avg by (activemq_cluster, instance) (activemq_topic_average_enqueue_time{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Average enqueue time',
  description: 'Average time a message was held on all destinations.',
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
      unit: 's',
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

local expiredMessagesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_queue_expired_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'sum by(instance, activemq_cluster) (activemq_topic_expired_count{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Expired messages',
  description: 'Number of messages across destinations that are expired.',
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

local jvmResourcesRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'JVM resources',
  collapsed: false,
};

local garbageCollectionDurationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (instance, activemq_cluster) (increase(jvm_gc_collection_seconds_count{job=~"$job", instance=~"$instance", activemq_cluster=~"$activemq_cluster"}[$__interval:])) / clamp_min(sum by (instance, activemq_cluster ) (increase(java_lang_g1_young_generation_collectioncount{job=~"$job", instance=~"$instance", activemq_cluster=~"$activemq_cluster"}[$__interval:])), 1)',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection duration',
  description: 'The amount of time spent performing the most recent garbage collection.',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local garbageCollectionCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(java_lang_g1_young_generation_collectioncount{job=~"$job", activemq_cluster=~"$activemq_cluster", instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection count',
  description: 'The recent increase in the number of garbage collection events for the JVM.',
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

{
  grafanaDashboards+:: {
    'apache-activemq-instance-overview.json':
      dashboard.new(
        'Apache ActiveMQ instance overview',
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
            includeAll=false,
            multi=false,
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
        ]
      )
      .addPanels(
        [
          averageBrokerMemoryUsagePanel { gridPos: { h: 4, w: 4, x: 0, y: 0 } },
          averageStoreMemoryUsagePanel { gridPos: { h: 4, w: 4, x: 4, y: 0 } },
          averageTemporaryMemoryUsagePanel { gridPos: { h: 4, w: 4, x: 8, y: 0 } },
          producerCountPanel { gridPos: { h: 4, w: 4, x: 12, y: 0 } },
          consumerCountPanel { gridPos: { h: 4, w: 4, x: 16, y: 0 } },
          averageUnacknowledgedMessagesPanel { gridPos: { h: 4, w: 4, x: 20, y: 0 } },
          queueSizePanel { gridPos: { h: 8, w: 12, x: 0, y: 4 } },
          destinationMemoryUsagePanel { gridPos: { h: 8, w: 12, x: 12, y: 4 } },
          enqueueCountPanel { gridPos: { h: 8, w: 12, x: 0, y: 12 } },
          dequeueCountPanel { gridPos: { h: 8, w: 12, x: 12, y: 12 } },
          averageEnqueueTimePanel { gridPos: { h: 8, w: 12, x: 0, y: 20 } },
          expiredMessagesPanel { gridPos: { h: 8, w: 12, x: 12, y: 20 } },
          jvmResourcesRow { gridPos: { h: 1, w: 24, x: 0, y: 28 } },
          garbageCollectionDurationPanel { gridPos: { h: 8, w: 12, x: 0, y: 29 } },
          garbageCollectionCountPanel { gridPos: { h: 8, w: 12, x: 12, y: 29 } },
        ]
      ),
  },
}
