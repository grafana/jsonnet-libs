local commonlib = import 'common-lib/common/main.libsonnet';
local topicLegendTemplate = '{{activemq_cluster}} - {{instance}} - {{destination}}';

function(this)
  {
    topicLegendTemplate: topicLegendTemplate,
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
            legendCustomTemplate: topicLegendTemplate,
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
            legendCustomTemplate: topicLegendTemplate,
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
            legendCustomTemplate: topicLegendTemplate,
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
            legendCustomTemplate: topicLegendTemplate,
          },
        },
      },
      enqueueRate: {
        name: 'Top topics by enqueue rate',
        nameShort: 'Top topics by enqueue rate',
        type: 'raw',
        description: 'Rate of messages being enqueued to topics.',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'topk by (instance, activemq_cluster, job) ($k_selector, rate(activemq_topic_enqueue_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}[$__rate_interval]))',
            legendCustomTemplate: topicLegendTemplate,
          },
        },
      },
      dequeueRate: {
        name: 'Top topics by dequeue rate',
        nameShort: 'Top topics by dequeue rate',
        type: 'raw',
        description: 'Rate of messages being dequeued from topics.',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'topk by (instance, activemq_cluster, job) ($k_selector, rate(activemq_topic_dequeue_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}[$__rate_interval]))',
            legendCustomTemplate: topicLegendTemplate,
          },
        },
      },
      averageEnqueueTime: {
        name: 'Top topics by average enqueue time',
        nameShort: 'Top topics by average enqueue time',
        type: 'raw',
        description: 'Average time to enqueue messages to topics.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'topk by (instance, activemq_cluster, job) ($k_selector, activemq_topic_average_enqueue_time{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"})',
            legendCustomTemplate: topicLegendTemplate,
          },
        },
      },
      expiredRate: {
        name: 'Top topics by expired rate',
        nameShort: 'Top topics by expired rate',
        type: 'raw',
        description: 'Rate of messages expiring in topics.',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'topk by (instance, activemq_cluster, job) ($k_selector, activemq_topic_expired_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"})',
            legendCustomTemplate: topicLegendTemplate,
          },
        },
      },

      topTopicsByConsumers: {
        name: 'Top topics by consumers',
        nameShort: 'Top topics by consumers',
        type: 'raw',
        description: 'Top topics by consumers.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk by (instance, activemq_cluster, job) ($k_selector, activemq_topic_consumer_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"})',
            legendCustomTemplate: topicLegendTemplate,
          },
        },
      },
      averageMessageSize: {
        name: 'Average message size',
        nameShort: 'Avg message size',
        type: 'gauge',
        description: 'Average size of messages in topics.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'activemq_topic_average_message_size{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}',
            legendCustomTemplate: topicLegendTemplate,
          },
        },
      },
      enqueueRateSummary: {
        name: 'Enqueue rate',
        nameShort: 'Enqueue rate',
        type: 'counter',
        description: 'Summary of topics.',
        sources: {
          prometheus: {
            expr: 'activemq_topic_enqueue_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}',
          },
        },
      },
      dequeueRateSummary: {
        name: 'Dequeue rate',
        nameShort: 'Dequeue rate',
        type: 'counter',
        description: 'Summary of topics.',
        sources: {
          prometheus: {
            expr: 'activemq_topic_dequeue_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}',
          },
        },
      },
      averageEnqueueTimeSummary: {
        name: 'Average enqueue time',
        nameShort: 'Average enqueue time',
        type: 'gauge',
        description: 'Summary of topics.',
        sources: {
          prometheus: {
            expr: 'activemq_topic_average_enqueue_time{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}',
          },
        },
      },
      averageMessageSizeSummary: {
        name: 'Average message size',
        nameShort: 'Average message size',
        type: 'gauge',
        description: 'Summary of topics.',
        sources: {
          prometheus: {
            expr: 'activemq_topic_average_message_size{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*", destination=~".*$name.*"}',
          },
        },
      },
    },
  }
