local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // Cluster panels

      clustersCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Clusters',
          targets=[signals.clusters.clusterCount.asTarget()],
          description='Number of Apache ActiveMQ clusters.'
        ),

      brokerCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Brokers',
          targets=[signals.clusters.brokerCount.asTarget()],
          description='Number of broker instances across clusters.'
        ),

      producersCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Producers',
          targets=[signals.clusters.producerCount.asTarget()],
          description='Number of message producers active on destinations across clusters.'
        ),

      consumersCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Consumers',
          targets=[signals.clusters.consumerCount.asTarget()],
          description='The number of consumers subscribed to destinations across clusters.'
        ),

      enqueueRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Enqueue / $__interval',
          targets=[signals.clusters.enqueueRate.asTarget()],
          description='Number of messages that have been sent to destinations in a cluster.'
        ),

      dequeueRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Dequeue / $__interval',
          targets=[signals.clusters.dequeueRate.asTarget()],
          description='Number of messages that have been acknowledged (and removed) from destinations in a cluster.'
        ),

      averageTemporaryMemoryUsagePanel:
        commonlib.panels.generic.stat.percentage.new(
          'Average temporary memory usage',
          targets=[signals.clusters.averageTemporaryMemoryUsage.asTarget()],
          description='Average percentage of temporary memory used across clusters.'
        )
        + g.panel.stat.standardOptions.withUnit('percentunit')
        + g.panel.stat.standardOptions.withMax(1)
        + g.panel.stat.standardOptions.withMin(0)
        + { type: 'bargauge' }
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),


      averageStoreMemoryUsagePanel:
        commonlib.panels.generic.stat.percentage.new(
          'Average store memory usage',
          targets=[signals.clusters.averageStoreMemoryUsage.asTarget()],
          description='Average percentage of store memory used across clusters.'
        )
        + g.panel.stat.standardOptions.withUnit('percentunit')
        + g.panel.stat.standardOptions.withMax(1)
        + g.panel.stat.standardOptions.withMin(0)
        + { type: 'bargauge' }
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),


      averageBrokerMemoryUsagePanel:
        commonlib.panels.generic.stat.percentage.new(
          'Average broker memory usage',
          targets=[signals.clusters.averageBrokerMemoryUsage.asTarget()],
          description='Average percentage of broker memory used across clusters.'
        )
        + g.panel.stat.standardOptions.withUnit('percentunit')
        + g.panel.stat.standardOptions.withMax(1)
        + g.panel.stat.standardOptions.withMin(0)
        + { type: 'bargauge' }
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),


      // Broker panels
      memoryUsagePanel:
        g.panel.gauge.new(title='Average broker memory usage')
        + g.panel.gauge.queryOptions.withTargets([
          signals.instance.memoryUsage.asTarget(),
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of memory used by both topics and queues across brokers.')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('green'),
          g.panel.gauge.thresholdStep.withColor('#EAB839') + g.panel.gauge.thresholdStep.withValue(50),
          g.panel.gauge.thresholdStep.withColor('red') + g.panel.gauge.thresholdStep.withValue(70),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),

      storeUsagePanel:
        g.panel.gauge.new(title='Average broker store usage')
        + g.panel.gauge.queryOptions.withTargets([
          signals.instance.storeUsage.asTarget(),
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of store used by both topics and queues across brokers.')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('green'),
          g.panel.gauge.thresholdStep.withColor('#EAB839') + g.panel.gauge.thresholdStep.withValue(50),
          g.panel.gauge.thresholdStep.withColor('red') + g.panel.gauge.thresholdStep.withValue(70),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),

      tempUsagePanel:
        g.panel.gauge.new(title='Average broker temporary usage')
        + g.panel.gauge.queryOptions.withTargets([
          signals.instance.tempUsage.asTarget(),
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of temporary storage used by both topics and queues across brokers.')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('green'),
          g.panel.gauge.thresholdStep.withColor('#EAB839') + g.panel.gauge.thresholdStep.withValue(50),
          g.panel.gauge.thresholdStep.withColor('red') + g.panel.gauge.thresholdStep.withValue(70),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),

      brokersOnlinePanel:
        commonlib.panels.generic.stat.base.new(
          'Brokers online',
          targets=[signals.instance.brokersOnline.asTarget()],
          description='Number of Apache ActiveMQ brokers that are online.'
        ),

      instanceBrokerMemoryUsagePanel:
        g.panel.gauge.new(title='Average broker memory usage')
        + g.panel.gauge.queryOptions.withTargets([
          signals.instance.memoryUsage.asTarget(),
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of memory used by both topics and queues across brokers.')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('green'),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),

      instanceAverageStoreUsagePanel:
        g.panel.gauge.new(title='Average store memory usage')
        + g.panel.gauge.queryOptions.withTargets([
          signals.instance.storeUsage.asTarget(),
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of store memory used by both topics and queues across brokers.')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('green'),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),


      instanceAverageBrokerMemoryUsagePanel:
        g.panel.gauge.new(title='Average temporary memory usage')
        + g.panel.gauge.queryOptions.withTargets([
          signals.instance.tempUsage.asTarget(),
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of temporary memory used by both topics and queues across brokers.')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('green'),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),

      instanceAverageTemporaryMemoryUsagePanel:
        commonlib.panels.generic.stat.base.new(
          'Unacknowledged messages / $__interval',
          targets=[signals.instance.unacknowledgedMessages.asTarget()],
          description='Recent number of unacknowledged messages on the broker.'
        ),

      activeMQAlertsPanel: {
        datasource: {
          uid: 'datasource',
        },
        targets: [],
        type: 'alertlist',
        title: 'ActiveMQ alerts',
        description: 'Firing alerts for Apache ActiveMQ environment.',
        options: {
          alertName: '',
          dashboardAlerts: false,
          alertInstanceLabelFilter: '{%(queriesSelector)s}',
          groupBy: [],
          datasource: {
            type: 'prometheus',
            uid: 'datasource',
          },
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
      },

      producerCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Producers',
          targets=[signals.instance.producerCount.asTarget()],
          description='The number of producers attached to destinations.'
        ),

      consumerCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Consumers',
          targets=[signals.instance.consumerCount.asTarget()],
          description='The number of consumers subscribed to destinations on the broker.'
        ),

      queueSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Queue size',
          targets=[signals.instance.queueSize.asTarget()],
          description='Number of messages on queue destinations, including any that have been dispatched but not yet acknowledged.'
        ),

      destinationMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Destination memory usage',
          targets=[
            signals.instance.queueMemoryUsage.asTarget(),
            signals.instance.topicMemoryUsage.asTarget(),
          ],
          description='The percentage of memory being used by topic and queue destinations.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(25)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),


      averageEnqueueTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average enqueue time',
          targets=[
            signals.instance.queueAverageEnqueueTime.asTarget(),
            signals.instance.topicAverageEnqueueTime.asTarget(),
          ],
          description='Average time a message was held across all destinations.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(25)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      expiredMessagesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Expired messages / $__interval',
          targets=[
            signals.instance.queueExpiredMessages.asTarget(),
            signals.instance.topicExpiredMessages.asTarget(),
          ],
          description='Number of messages across destinations that are expired.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(25)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      garbageCollectionDurationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Garbage collection duration',
          targets=[signals.instance.garbageCollectionDuration.asTarget()],
          description='The time spent performing recent garbage collections'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(25)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      garbageCollectionCountPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Garbage collection count / $__interval',
          targets=[signals.instance.garbageCollectionCount.asTarget()],
          description='The recent increase in the number of garbage collection events for the JVM.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(25)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // Queue panels
      queueCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Queue count',
          targets=[signals.queues.queueCount.asTarget()],
          description='Number of active queues.'
        ),

      totalQueueSizePanel:
        commonlib.panels.generic.stat.base.new(
          'Total queue size',
          targets=[signals.queues.totalQueueSize.asTarget()],
          description='Total number of messages in all queues.'
        ),

      queueProducersPanel:
        commonlib.panels.generic.stat.base.new(
          'Total queue producers',
          targets=[signals.queues.totalProducers.asTarget()],
          description='Total number of queue producers.'
        ),

      queueConsumersPanel:
        commonlib.panels.generic.stat.base.new(
          'Total queue consumers',
          targets=[signals.queues.totalConsumers.asTarget()],
          description='Total number of queue consumers.'
        ),

      queueEnqueueRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Queue enqueue rate',
          targets=[signals.queues.enqueueRate.asTarget() { interval: '1m' }],
          description='Rate of messages being enqueued to queues.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      queueDequeueRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Queue dequeue rate',
          targets=[signals.queues.dequeueRate.asTarget() { interval: '1m' }],
          description='Rate of messages being dequeued from queues.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      queueAverageEnqueueTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Queue average enqueue time',
          targets=[signals.queues.averageEnqueueTime.asTarget()],
          description='Average time to enqueue messages to queues.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      queueExpiredRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Queue expired rate',
          targets=[signals.queues.expiredRate.asTarget() { interval: '1m' }],
          description='Rate of messages expiring in queues.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      queueAverageMessageSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Queue average message size',
          targets=[signals.queues.averageMessageSize.asTarget()],
          description='Average size of messages in queues.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      queueSummaryPanel:
        commonlib.panels.generic.table.base.new(
          'Queue summary',
          targets=[
            signals.queues.queueEnqueueRateSummary.asTableTarget() { interval: '1m' },
            signals.queues.queueDequeueRateSummary.asTableTarget() { interval: '1m' },
            signals.queues.queueAverageEnqueueTimeSummary.asTableTarget(),
            signals.queues.queueAverageMessageSizeSummary.asTableTarget(),
          ],
        )
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Enqueue rate')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'mps'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Dequeue rate')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'mps'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Average enqueue time')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'ms'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Average message size')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'decbytes'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('ActiveMQ cluster')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Cluster link',
              url: 'd/apacheactivemq_cluster_overview?var-activemq_cluster=${__data.fields.activemq_cluster}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Instance')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Instance link',
              url: 'd/apacheactivemq_instance_overview?var-instance=${__data.fields.instance}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.options.withCellHeight('sm')
        + g.panel.table.options.footer.withCountRows(false)
        + g.panel.table.options.footer.withFields('')
        + g.panel.table.options.footer.withReducer(['sum'])
        + g.panel.table.options.footer.withShow(false)
        + g.panel.table.options.withShowHeader(true)

        + g.panel.table.queryOptions.withTransformations([
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
              indexByName: {},
              renameByName: {
                'Value #Queue enqueue rate summary': 'Enqueue rate',
                'Value #Queue dequeue rate summary': 'Dequeue rate',
                'Value #Queue average enqueue time summary': 'Average enqueue time',
                'Value #Queue average message size summary': 'Average message size',
                'activemq_cluster 1': 'ActiveMQ cluster',
                destination: 'Destination',
                'instance 1': 'Instance',
              },
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'Destination',
                  'ActiveMQ cluster',
                  'Instance',
                  'Enqueue rate',
                  'Dequeue rate',
                  'Average enqueue time',
                  'Average message size',
                ],
              },
            },
          },
        ]),


      // Topic panels
      topicCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Topic count',
          targets=[signals.topics.topicCount.asTarget()],
          description='Number of active topics (excluding advisory topics).'
        ),

      topicProducersPanel:
        commonlib.panels.generic.stat.base.new(
          'Producers',
          targets=[signals.topics.totalProducers.asTarget()],
          description='Total number of topic producers.'
        ),

      topicConsumersPanel:
        commonlib.panels.generic.stat.base.new(
          'Consumers',
          targets=[signals.topics.totalConsumers.asTarget()],
          description='Total number of topic consumers.'
        ),

      topicAverageConsumersPanel:
        commonlib.panels.generic.stat.base.new(
          'Average consumers per topic',
          targets=[signals.topics.averageConsumers.asTarget()],
          description='Average number of consumers per topic.'
        ),

      topicEnqueueRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top topics by enqueue rate',
          targets=[signals.topics.enqueueRate.asTarget() { interval: '1m' }],
          description='Rate of messages being enqueued to topics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      topicDequeueRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top topics by dequeue rate',
          targets=[signals.topics.dequeueRate.asTarget() { interval: '1m' }],
          description='Rate of messages being dequeued from topics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      topicAverageEnqueueTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top topics by average enqueue time',
          targets=[signals.topics.averageEnqueueTime.asTarget()],
          description='Average time to enqueue messages to topics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      topicExpiredRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top topics by expired rate',
          targets=[signals.topics.expiredRate.asTarget() { interval: '1m' }],
          description='Rate of messages expiring in topics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      topicAverageMessageSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Topic average message size',
          targets=[signals.topics.averageMessageSize.asTarget()],
          description='Average size of messages in topics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      topicTopicsByConsumers:
        commonlib.panels.generic.timeSeries.base.new(
          'Top topics by consumers',
          targets=[signals.topics.topTopicsByConsumers.asTarget()],
          description='Top topics by consumers.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.withOrientation('horizontal')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),

      topicSummaryPanel:
        commonlib.panels.generic.table.base.new(
          'Topic summary',
          targets=[
            signals.topics.enqueueRateSummary.asTableTarget() { interval: '1m' },
            signals.topics.dequeueRateSummary.asTableTarget() { interval: '1m' },
            signals.topics.averageEnqueueTimeSummary.asTableTarget(),
            signals.topics.averageMessageSizeSummary.asTableTarget(),
          ],
          description='Summary of topics showing topic name, enqueue and dequeue rate, average enqueue time, and average message size.'
        )
        // Field configuration defaults
        + g.panel.table.fieldConfig.defaults.custom.withAlign('left')
        + g.panel.table.fieldConfig.defaults.custom.withCellOptions({
          type: 'auto',
        })
        + g.panel.table.fieldConfig.defaults.custom.withInspect(false)
        + g.panel.table.standardOptions.thresholds.withMode('absolute')
        + g.panel.table.standardOptions.thresholds.withSteps([
          g.panel.table.thresholdStep.withColor('green'),
        ])

        // Field overrides for units and links
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Enqueue rate')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'mps'),

          g.panel.table.fieldOverride.byName.new('Dequeue rate')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'mps'),

          g.panel.table.fieldOverride.byName.new('Average enqueue time')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'ms'),

          g.panel.table.fieldOverride.byName.new('Average message size')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'decbytes'),

          g.panel.table.fieldOverride.byName.new('ActiveMQ cluster')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Cluster link',
              url: 'd/apacheactivemq_cluster_overview?var-activemq_cluster=${__data.fields.activemq_cluster}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),

          g.panel.table.fieldOverride.byName.new('Instance')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Instance link',
              url: 'd/apacheactivemq_instance_overview?var-instance=${__data.fields.instance}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])

        // Table options
        + g.panel.table.options.withCellHeight('sm')
        + g.panel.table.options.footer.withCountRows(false)
        + g.panel.table.options.footer.withFields('')
        + g.panel.table.options.footer.withReducer(['sum'])
        + g.panel.table.options.footer.withShow(false)
        + g.panel.table.options.withShowHeader(true)

        // Transformations
        + g.panel.table.queryOptions.withTransformations([
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
              indexByName: {},
              renameByName: {
                'Value #Enqueue rate': 'Enqueue rate',
                'Value #Dequeue rate': 'Dequeue rate',
                'Value #Average enqueue time': 'Average enqueue time',
                'Value #Average message size': 'Average message size',
                'activemq_cluster 1': 'ActiveMQ cluster',
                destination: 'Destination',
                'instance 1': 'Instance',
              },
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'ActiveMQ cluster',
                  'Instance',
                  'Enqueue rate',
                  'Dequeue rate',
                  'Average enqueue time',
                  'Average message size',
                  'Destination',
                ],
              },
            },
          },
        ]),
    },
}
