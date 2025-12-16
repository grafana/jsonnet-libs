function(this) {
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'ibmmq_topic_messages_received',
  },
  signals: {

    topicMessagesReceived: {
      name: 'Topic messages received',
      type: 'gauge',
      description: 'Received messages per topic.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_topic_messages_received{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{topic}}',
        },
      },
    },

    topicMessagesPut: {
      name: 'Topic messages put',
      type: 'gauge',
      description: 'Put messages per topic.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_topic_messages_put{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{topic}}',
        },
      },
    },

    topicBytesReceived: {
      name: 'Topic bytes received',
      type: 'gauge',
      description: 'Received bytes per topic.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_topic_bytes_received{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{topic}}',
        },
      },
    },

    topicBytesPut: {
      name: 'Topic bytes put',
      type: 'gauge',
      description: 'Put bytes per topic.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_topic_bytes_put{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{topic}}',
        },
      },
    },

    timeSinceLastMessage: {
      name: 'Time since last message',
      type: 'gauge',
      description: 'The time since the topic last received a message.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'ibmmq_topic_time_since_msg_received{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{topic}}',
        },
      },
    },

    subscribers: {
      name: 'Topic subscribers',
      type: 'gauge',
      description: 'The number of subscribers per topic.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_topic_subscriber_count{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{topic}}',
        },
      },
    },

    publishers: {
      name: 'Topic publishers',
      type: 'gauge',
      description: 'The number of publishers per topic.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_topic_publisher_count{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{topic}}',
        },
      },
    },

    subscriptionMessagesReceived: {
      name: 'Subscription messages received',
      type: 'gauge',
      description: 'The number of messages a subscription receives.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_subscription_messages_received{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{subscription}}',
        },
      },
    },

    subscriptionTimeSinceMessagePublished: {
      name: 'Subscription time since message published',
      type: 'gauge',
      description: 'Time since last subscription message.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'ibmmq_subscription_time_since_message_published{%(queriesSelector)s}',
          legendCustomTemplate: '{{label_name}}',
        },
      },
    },
  },
}
