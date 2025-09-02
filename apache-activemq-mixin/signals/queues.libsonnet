function(this)
  local groupAggListWithoutInstance = std.join(',', this.groupLabels);
  local groupAggListWithInstance = groupAggListWithoutInstance + (if std.length(this.instanceLabels) > 0 then ', ' + std.join(',', this.instanceLabels) else '');
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: '{{activemq_cluster}} - {{instance}} - {{destination}}',
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
          },
        },
      },
      enqueueRate: {
        name: 'Top queues by enqueue rate',
        nameShort: 'Top queues by enqueue rate',
        type: 'raw',
        description: 'Rate of messages being enqueued to queues.',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'topk by (' + groupAggListWithInstance + ') ($k_selector, rate(activemq_queue_enqueue_count{%(queriesSelector)s, destination=~".*$name.*"}[$__rate_interval]))',
          },
        },
      },
      dequeueRate: {
        name: 'Top queues by dequeue rate',
        nameShort: 'Top queues by dequeue rate',
        type: 'raw',
        description: 'Rate of messages being dequeued from queues.',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'topk by (' + groupAggListWithInstance + ') ($k_selector, rate(activemq_queue_dequeue_count{%(queriesSelector)s, destination=~".*$name.*"}[$__rate_interval]))',
          },
        },
      },
      averageEnqueueTime: {
        name: 'Top queues by average enqueue time',
        nameShort: 'Top queues by average enqueue time',
        type: 'raw',
        description: 'Average time to enqueue messages to queues.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'topk by (' + groupAggListWithInstance + ') ($k_selector, activemq_queue_average_enqueue_time{%(queriesSelector)s, destination=~".*$name.*"})',
          },
        },
      },
      expiredRate: {
        name: 'Top queues by expired rate',
        nameShort: 'Top queues by expired rate',
        type: 'raw',
        description: 'Rate of messages expiring in queues.',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'topk by (' + groupAggListWithInstance + ') ($k_selector, rate(activemq_queue_expired_count{%(queriesSelector)s, destination=~".*$name.*"}[$__rate_interval]))',
          },
        },
      },
      averageMessageSize: {
        name: 'Top queues by average message size',
        nameShort: 'Top queues by average message size',
        type: 'raw',
        description: 'Average size of messages in queues.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk by (' + groupAggListWithInstance + ') ($k_selector, activemq_queue_average_message_size{%(queriesSelector)s, destination=~".*$name.*"})',
          },
        },
      },

      queueEnqueueRateSummary: {
        name: 'Queue enqueue rate summary',
        nameShort: 'Queue enqueue rate summary',
        type: 'counter',
        description: 'Summary of queues showing queue name, enqueue and dequeue rate, average enqueue time, and average message size.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'activemq_queue_enqueue_count{%(queriesSelector)s, destination=~".*$name.*"}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      queueDequeueRateSummary: {
        name: 'Queue dequeue rate summary',
        nameShort: 'Queue dequeue rate summary',
        type: 'counter',
        description: 'Summary of queues showing queue name, enqueue and dequeue rate, average enqueue time, and average message size.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'activemq_queue_dequeue_count{%(queriesSelector)s, destination=~".*$name.*"}',
            rangeFunction: 'rate',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      queueAverageEnqueueTimeSummary: {
        name: 'Queue average enqueue time summary',
        nameShort: 'Queue average enqueue time summary',
        type: 'gauge',
        description: 'Summary of queues showing queue name, enqueue and dequeue rate, average enqueue time, and average message size.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'activemq_queue_average_enqueue_time{%(queriesSelector)s, destination=~".*$name.*"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      queueAverageMessageSizeSummary: {
        name: 'Queue average message size summary',
        nameShort: 'Queue average message size summary',
        type: 'gauge',
        description: 'Summary of queues showing queue name, enqueue and dequeue rate, average enqueue time, and average message size.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'activemq_queue_average_message_size{%(queriesSelector)s, destination=~".*$name.*"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
