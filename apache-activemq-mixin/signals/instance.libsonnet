local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'activemq_memory_usage_ratio',
    },
    signals: {
      memoryUsage: {
        name: 'Average broker memory usage',
        nameShort: 'Memory usage',
        type: 'gauge',
        description: 'The percentage of memory used by both topics and queues across brokers.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'avg(activemq_memory_usage_ratio{%(queriesSelector)s})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}}',
          },
        },
      },
      storeUsage: {
        name: 'Average broker store usage',
        nameShort: 'Store usage',
        type: 'gauge',
        description: 'The percentage of store used by both topics and queues across brokers.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'avg(activemq_store_usage_ratio{%(queriesSelector)s})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}}',
          },
        },
      },
      tempUsage: {
        name: 'Broker temporary usage',
        nameShort: 'Temp usage',
        type: 'gauge',
        description: 'The percentage of temporary storage used by both topics and queues across brokers.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'avg(activemq_temp_usage_ratio{%(queriesSelector)s})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}}',
          },
        },
      },

      producerCount: {
        name: 'Producers',
        nameShort: 'Producers',
        type: 'raw',
        description: 'The number of producers attached to destinations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum(activemq_queue_producer_count{%(queriesSelector)s}) + sum(activemq_topic_producer_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },

      consumerCount: {
        name: 'Consumers',
        nameShort: 'Consumers',
        type: 'raw',
        description: 'The number of consumers attached to destinations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum(activemq_queue_consumer_count{%(queriesSelector)s}) + sum(activemq_topic_consumer_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },

      unacknowledgedMessages: {
        name: 'Unacknowledged messages',
        nameShort: 'Unacknowledged messages',
        type: 'raw',
        description: 'The number of unacknowledged messages in the broker.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum (increase(activemq_message_total{%(queriesSelector)s}[$__interval:]))',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },


      queueSize: {
        name: 'Queue size',
        nameShort: 'Queue size',
        type: 'raw',
        description: 'Number of messages on queue destinations, including any that hve been dispatched but not yet acknowledged.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (activemq_queue_queue_size{%(queriesSelector)s})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },

      queueMemoryUsage: {
        name: 'Queue memory usage',
        nameShort: 'Queue memory usage',
        type: 'raw',
        description: 'The percentage of memory used by both topics and queues across brokers.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (activemq_queue_memory_percent_usage{%(queriesSelector)s, destination!~"^ActiveMQ.Advisory.+"})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },

      topicMemoryUsage: {
        name: 'Topic memory usage',
        nameShort: 'Topic memory usage',
        type: 'gauge',
        description: 'The percentage of memory used by both topics and queues across brokers.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (activemq_topic_memory_percent_usage{%(queriesSelector)s, destination!~"^ActiveMQ.Advisory.+"})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - topic',
          },
        },
      },


      queueEnqueueCount: {
        name: 'Queue enqueue count',
        nameShort: 'Queue enqueue count',
        type: 'raw',
        description: 'The number of messages that have been sent to destinations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (increase(activemq_queue_enqueue_count{%(queriesSelector)s})[$__interval:])',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },

      queueDequeueCount: {
        name: 'Queue dequeue count',
        nameShort: 'Queue dequeue count',
        type: 'raw',
        description: 'The number of messages that have been acknowledged (and removed) from destinations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (increase(activemq_queue_dequeue_count{%(queriesSelector)s, destination!~"^ActiveMQ.Advisory.+"})[$__interval:])',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },

      queueAverageEnqueueTime: {
        name: 'Queue average enqueue time',
        nameShort: 'Queue average enqueue time',
        type: 'raw',
        description: 'The average time it takes to enqueue a message to a queue.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (activemq_queue_average_enqueue_time{%(queriesSelector)s})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },

      topicEnqueueCount: {
        name: 'Topic enqueue count',
        nameShort: 'Topic enqueue count',
        type: 'raw',
        description: 'The number of messages that have been sent to destinations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (increase(activemq_topic_enqueue_count{%(queriesSelector)s})[$__interval:])',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - topic',
          },
        },
      },

      topicDequeueCount: {
        name: 'Topic dequeue count',
        nameShort: 'Topic dequeue count',
        type: 'raw',
        description: 'The number of messages that have been acknowledged (and removed) from destinations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (increase(activemq_topic_dequeue_count{%(queriesSelector)s, destination!~"^ActiveMQ.Advisory.+"})[$__interval:])',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - topic',
          },
        },
      },

      topicAverageEnqueueTime: {
        name: 'Topic average enqueue time',
        nameShort: 'Topic average enqueue time',
        type: 'raw',
        description: 'The average time it takes to enqueue a message to a topic.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (activemq_topic_average_enqueue_time{%(queriesSelector)s, destination!~"^ActiveMQ.Advisory.+"})',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - topic',
          },
        },
      },

      queueExpiredMessages: {
        name: 'Queue expired messages',
        nameShort: 'Queue expired messages',
        type: 'raw',
        description: 'The number of messages that have been expired from destinations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (increase(activemq_queue_expired_count{%(queriesSelector)s}[$__interval:]))',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - queue',
          },
        },
      },

      topicExpiredMessages: {
        name: 'Topic expired messages',
        nameShort: 'Topic expired messages',
        type: 'raw',
        description: 'The number of messages that have been expired from destinations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (instance, activemq_cluster, job) (increase(activemq_topic_expired_count{%(queriesSelector)s, destination!~"^ActiveMQ.Advisory.+"}[$__interval:]))',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - topic',
          },
        },
      },


      garbageCollectionDuration: {
        name: 'Garbage collection duration',
        nameShort: 'Garbage collection duration',
        type: 'gauge',
        description: 'The number of messages that have been garbage collected from destinations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'jvm_gc_duration_seconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}}',
          },
        },
      },

      garbageCollectionCount: {
        name: 'Garbage collection count',
        nameShort: 'Garbage collection count',
        type: 'raw',
        description: 'The number of times garbage collection has been performed.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'increase(jvm_gc_collection_count{%(queriesSelector)s, name="G1 Young Generation"}[$__interval:])',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}}',
          },
        },
      },


      brokersOnline: {
        name: 'Brokers online',
        nameShort: 'Brokers online',
        type: 'gauge',
        description: 'Number of Apache ActiveMQ brokers that are online.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'count by (%(agg)s) (activemq_memory_usage_ratio{%(queriesSelector)s})',
            legendCustomTemplate: '__auto',
          },
        },
      },
    },
  }
