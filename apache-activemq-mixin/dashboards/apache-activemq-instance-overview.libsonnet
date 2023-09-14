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

local averageBrokerMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (instance, activemq_cluster) (activemq_memory_usage_ratio{' + matcher + ', instance=~"$instance"})',
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
    minVizHeight: 75,
    minVizWidth: 75,
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
  pluginVersion: '10.2.0-60139',
};

local averageStoreMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (instance, activemq_cluster, job) (activemq_store_usage_ratio{' + matcher + ', instance=~"$instance"})',
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
    minVizHeight: 75,
    minVizWidth: 75,
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
  pluginVersion: '10.2.0-60139',
};

local averageTemporaryMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (instance, activemq_cluster, job) (activemq_temp_usage_ratio{' + matcher + ', instance=~"$instance"})',
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
    minVizHeight: 75,
    minVizWidth: 75,
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
  pluginVersion: '10.2.0-60139',
};

local producerCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster, job) (activemq_queue_producer_count{' + matcher + ', instance=~"$instance"}) + sum by(instance, activemq_cluster, job) (activemq_topic_producer_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"})',
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
      'sum by(instance, activemq_cluster, job) (activemq_queue_consumer_count{' + matcher + ', instance=~"$instance"}) + sum by(instance, activemq_cluster, job) (activemq_topic_consumer_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"})',
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

local unacknowledgedMessagesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (instance, activemq_cluster, job) (increase(activemq_message_total{' + matcher + ', instance=~"$instance"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'stat',
  title: 'Unacknowledged messages / $__interval',
  description: 'Recent number of unacknowledged messages on the broker.',
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
      'sum by(instance, activemq_cluster, job) (activemq_queue_queue_size{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
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

local destinationMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster, job) (activemq_queue_memory_percent_usage{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'sum by(instance, activemq_cluster, job) (activemq_topic_memory_percent_usage{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"})',
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
        axisShow: false,
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
      max: 100,
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

local enqueueCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster, job) (increase(activemq_queue_enqueue_count{' + matcher + ', instance=~"$instance"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'sum by(instance, activemq_cluster, job) (increase(activemq_topic_enqueue_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Enqueue count / $__interval',
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
      'sum by(instance, activemq_cluster) (increase(activemq_queue_dequeue_count{' + matcher + ', instance=~"$instance"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'sum by(instance, activemq_cluster) (increase(activemq_topic_dequeue_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Dequeue count / $__interval',
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

local averageEnqueueTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (activemq_cluster, instance, job) (activemq_queue_average_enqueue_time{' + matcher + ', instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'avg by (activemq_cluster, instance, job) (activemq_topic_average_enqueue_time{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"})',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Average enqueue time',
  description: 'Average time a message was held across all destinations.',
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

local expiredMessagesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(instance, activemq_cluster, job) (increase(activemq_queue_expired_count{' + matcher + ', instance=~"$instance"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - queue',
    ),
    prometheus.target(
      'sum by(instance, activemq_cluster, job) (increase(activemq_topic_expired_count{' + matcher + ', instance=~"$instance", destination!~"ActiveMQ.Advisory.*"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}} - topic',
    ),
  ],
  type: 'timeseries',
  title: 'Expired messages / $__interval',
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

local jvmResourcesRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'JVM resources',
  collapsed: false,
};

local garbageCollectionDurationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (instance, activemq_cluster) (increase(jvm_gc_collection_seconds_count{' + matcher + ', instance=~"$instance"}[$__interval:])) / clamp_min(sum by (instance, activemq_cluster ) (increase(java_lang_g1_young_generation_collectioncount{' + matcher + ', instance=~"$instance"}[$__interval:])), 1)',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection duration / $__interval',
  description: 'The average time spent performing recent garbage collections',
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

local garbageCollectionCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(java_lang_g1_young_generation_collectioncount{' + matcher + ', instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{activemq_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection count / $__interval',
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

local activemqAlertsPanel(matcher) = {
  datasource: promDatasource,
  targets: [],
  type: 'alertlist',
  title: 'ActiveMQ alerts',
  description: 'Firing alerts for Apache ActiveMQ environment.',
  options: {
    alertName: '',
    dashboardAlerts: false,
    alertInstanceLabelFilter: '{' + matcher + ', instance=~"${instance:regex}", destination!~"ActiveMQ.Advisory.*"}',
    datasource: promDatasource,
    groupBy: [],
    groupMode: 'default',
    maxItems: 5,
    sortOrder: 1,
    stateFilter: {
      'error': true,
      firing: true,
      noData: true,
      normal: true,
      pending: true,
    },
    viewMode: 'list',
  },
};

local getMatcher(cfg) = '%(activemqSelector)s, activemq_cluster=~"$activemq_cluster"' % cfg;
local getAlertsMatcher(cfg) = '%(activemqAlertsSelector)s, activemq_cluster=~"${activemq_cluster:regex}"' % cfg;

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
          averageBrokerMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 0, y: 0 } },
          averageStoreMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 6, y: 0 } },
          averageTemporaryMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 12, y: 0 } },
          unacknowledgedMessagesPanel(getMatcher($._config)) { gridPos: { h: 4, w: 6, x: 18, y: 0 } },
          activemqAlertsPanel(getAlertsMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 4 } },
          producerCountPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 12, y: 4 } },
          consumerCountPanel(getMatcher($._config)) { gridPos: { h: 6, w: 6, x: 18, y: 4 } },
          queueSizePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 10 } },
          destinationMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 10 } },
          enqueueCountPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 18 } },
          dequeueCountPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 18 } },
          averageEnqueueTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 26 } },
          expiredMessagesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 26 } },
          jvmResourcesRow { gridPos: { h: 1, w: 24, x: 0, y: 34 } },
          garbageCollectionDurationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 35 } },
          garbageCollectionCountPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 35 } },
        ]
      ),
  },
}
