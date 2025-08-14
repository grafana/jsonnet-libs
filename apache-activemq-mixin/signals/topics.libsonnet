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
      prometheus: 'activemq_topic_producer_count',
    },
    signals: {
      topicCount: {
        name: 'Topic count',
        nameShort: 'Topic count',
        type: 'gauge',
        description: 'Number of active topics (excluding advisory topics).',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'count (activemq_topic_queue_size{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"})',
            legendCustomTemplate: '__auto',
          },
        },
      },
      totalProducers: {
        name: 'Total producers',
        nameShort: 'Total producers',
        type: 'gauge',
        description: 'Total number of topic producers.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum (activemq_topic_producer_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"})',
            legendCustomTemplate: '__auto',
          },
        },
      },
      totalConsumers: {
        name: 'Total consumers',
        nameShort: 'Total consumers',
        type: 'gauge',
        description: 'Total number of topic consumers.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum (activemq_topic_consumer_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"})',
            legendCustomTemplate: '__auto',
          },
        },
      },
      averageConsumers: {
        name: 'Average consumers per topic',
        nameShort: 'Avg consumers',
        type: 'gauge',
        description: 'Average number of consumers per topic.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'avg (activemq_topic_consumer_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"})',
            legendCustomTemplate: '__auto',
          },
        },
      },
      enqueueRate: {
        name: 'Enqueue rate',
        nameShort: 'Enqueue rate',
        type: 'counter',
        description: 'Rate of messages being enqueued to topics.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'activemq_topic_enqueue_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
      dequeueRate: {
        name: 'Dequeue rate',
        nameShort: 'Dequeue rate',
        type: 'counter',
        description: 'Rate of messages being dequeued from topics.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'activemq_topic_dequeue_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
      averageEnqueueTime: {
        name: 'Average enqueue time',
        nameShort: 'Avg enqueue time',
        type: 'gauge',
        description: 'Average time to enqueue messages to topics.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'activemq_topic_average_enqueue_time{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
      expiredRate: {
        name: 'Expired rate',
        nameShort: 'Expired rate',
        type: 'counter',
        description: 'Rate of messages expiring in topics.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'activemq_topic_expired_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
      averageMessageSize: {
        name: 'Average message size',
        nameShort: 'Avg message size',
        type: 'gauge',
        description: 'Average size of messages in topics.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'activemq_topic_average_message_size{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
          },
        },
      },
    },
  }
