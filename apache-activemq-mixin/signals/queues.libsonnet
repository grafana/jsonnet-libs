local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'activemq_queue_queue_size',
    },
    signals: {
      queueCount: {
        name: 'Queue count',
        nameShort: 'Queue count',
        type: 'gauge',
        description: 'Number of active queues.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'count (activemq_queue_queue_size{%(queriesSelector)s})',
            legendCustomTemplate: '__auto',
          },
        },
      },
      totalQueueSize: {
        name: 'Total queue size',
        nameShort: 'Total queue size',
        type: 'gauge',
        description: 'Total number of messages in all queues.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum (activemq_queue_queue_size{%(queriesSelector)s})',
            legendCustomTemplate: '__auto',
          },
        },
      },
      totalProducers: {
        name: 'Total producers',
        nameShort: 'Total producers',
        type: 'gauge',
        description: 'Total number of queue producers.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum (activemq_queue_producer_count{%(queriesSelector)s})',
            legendCustomTemplate: '__auto',
          },
        },
      },
      totalConsumers: {
        name: 'Total consumers',
        nameShort: 'Total consumers',
        type: 'gauge',
        description: 'Total number of queue consumers.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum (activemq_queue_consumer_count{%(queriesSelector)s})',
            legendCustomTemplate: '__auto',
          },
        },
      },
      enqueueRate: {
        name: 'Enqueue rate',
        nameShort: 'Enqueue rate',
        type: 'counter',
        description: 'Rate of messages being enqueued to queues.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'activemq_queue_enqueue_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
      dequeueRate: {
        name: 'Dequeue rate',
        nameShort: 'Dequeue rate',
        type: 'counter',
        description: 'Rate of messages being dequeued from queues.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'activemq_queue_dequeue_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
      averageEnqueueTime: {
        name: 'Average enqueue time',
        nameShort: 'Avg enqueue time',
        type: 'gauge',
        description: 'Average time to enqueue messages to queues.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'activemq_queue_average_enqueue_time{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
      expiredRate: {
        name: 'Expired rate',
        nameShort: 'Expired rate',
        type: 'counter',
        description: 'Rate of messages expiring in queues.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'activemq_queue_expired_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
      averageMessageSize: {
        name: 'Average message size',
        nameShort: 'Avg message size',
        type: 'gauge',
        description: 'Average size of messages in queues.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'activemq_queue_average_message_size{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
    },
  }
