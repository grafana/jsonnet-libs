function(this) {
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
    clusterCount: {
      name: 'Clusters',
      nameShort: 'Count',
      type: 'gauge',
      description: 'Number of Apache ActiveMQ clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'count(activemq_memory_usage_ratio{%(queriesSelector)s})',
        },
      },
    },

    brokerCount: {
      name: 'Brokers',
      nameShort: 'Brokers',
      type: 'gauge',
      description: 'Number of Apache ActiveMQ brokers.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'count(activemq_memory_usage_ratio{%(queriesSelector)s})',
        },
      },
    },

    consumerCount: {
      name: 'Consumers',
      nameShort: 'Consumers',
      type: 'raw',
      description: 'Number of Apache ActiveMQ consumers.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum (activemq_queue_consumer_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"})',
        },
      },
    },

    producerCount: {
      name: 'Producers',
      nameShort: 'Producers',
      type: 'raw',
      description: 'Number of Apache ActiveMQ producers.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum (activemq_queue_producer_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"})',
        },
      },
    },

    enqueueRate: {
      name: 'Enqueue / $__interval',
      type: 'raw',
      description: 'Number of messages that have been sent to destinations in a cluster.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by (activemq_cluster, job) (increase(activemq_queue_enqueue_count{%(queriesSelector)s}[$__interval:])) + sum by (activemq_cluster, job) (increase(activemq_topic_enqueue_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}[$__interval:]))',
          legendCustomTemplate: '{{activemq_cluster}}',
        },
      },
    },

    dequeueRate: {
      name: 'Dequeue / $__interval',
      type: 'raw',
      description: 'Number of messages that have been received from destinations in a cluster.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by (activemq_cluster, job) (increase(activemq_queue_dequeue_count{%(queriesSelector)s}[$__interval:])) + sum by (activemq_cluster, job) (increase(activemq_topic_dequeue_count{%(queriesSelector)s, destination!~"ActiveMQ.Advisory.*"}[$__interval:]))',
          legendCustomTemplate: '{{activemq_cluster}}',
        },
      },
    },

    averageTemporaryMemoryUsage: {
      name: 'Average temporary memory usage',
      type: 'raw',
      description: 'Average percentage of temporary memory used across clusters.',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'avg by (activemq_cluster, job) (activemq_temp_usage_ratio{%(queriesSelector)s})',
          legendCustomTemplate: '{{activemq_cluster}}',
        },
      },
    },

    averageStoreMemoryUsage: {
      name: 'Average store memory usage',
      description: 'Average percentage of store memory used across clusters.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'avg by (activemq_cluster, job) (activemq_store_usage_ratio{%(queriesSelector)s})',
          legendCustomTemplate: '{{activemq_cluster}}',
        },
      },
    },

    averageBrokerMemoryUsage: {
      name: 'Average broker memory usage',
      description: 'Average percentage of broker memory used across clusters.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'avg by (activemq_cluster, job) (activemq_memory_usage_ratio{%(queriesSelector)s})',
          legendCustomTemplate: '{{activemq_cluster}}',
        },
      },
    },
  },
}
