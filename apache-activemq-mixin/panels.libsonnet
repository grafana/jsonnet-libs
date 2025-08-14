local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // Broker panels
      memoryUsagePanel:
        g.panel.gauge.new(title='Average broker memory usage')
        + g.panel.gauge.queryOptions.withTargets([
          signals.broker.memoryUsage.asTarget(),
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
          signals.broker.storeUsage.asTarget(),
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
          signals.broker.tempUsage.asTarget(),
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
          targets=[signals.broker.brokersOnline.asTarget()],
          description='Number of Apache ActiveMQ brokers that are online.'
        ),

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

      // Topic panels
      topicCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Topic count',
          targets=[signals.topics.topicCount.asTarget()],
          description='Number of active topics (excluding advisory topics).'
        ),

      topicProducersPanel:
        commonlib.panels.generic.stat.base.new(
          'Total topic producers',
          targets=[signals.topics.totalProducers.asTarget()],
          description='Total number of topic producers.'
        ),

      topicConsumersPanel:
        commonlib.panels.generic.stat.base.new(
          'Total topic consumers',
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
          'Topic enqueue rate',
          targets=[signals.topics.enqueueRate.asTarget() { interval: '1m' }],
          description='Rate of messages being enqueued to topics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      topicDequeueRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Topic dequeue rate',
          targets=[signals.topics.dequeueRate.asTarget() { interval: '1m' }],
          description='Rate of messages being dequeued from topics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      topicAverageEnqueueTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Topic average enqueue time',
          targets=[signals.topics.averageEnqueueTime.asTarget()],
          description='Average time to enqueue messages to topics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      topicExpiredRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Topic expired rate',
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
    },
}
