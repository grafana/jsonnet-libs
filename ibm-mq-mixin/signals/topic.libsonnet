function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {
      messagesReceived: {
        name: 'Topic messages received',
        type: 'counter',
        description: 'Received messages per topic.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_topic_messages_received{%(queriesSelector)s}',
            legendCustomTemplate: '{{topic}}',
          },
        },
      },
      timeSinceMsgReceived: {
        name: 'Time since message received',
        type: 'gauge',
        description: 'The time since the topic last received a message.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'ibmmq_topic_time_since_msg_received{%(queriesSelector)s}',
            legendCustomTemplate: '{{topic}}',
          },
        },
      },
      subscriberCount: {
        name: 'Topic subscriber count',
        type: 'gauge',
        description: 'The number of subscribers per topic.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_topic_subscriber_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{topic}}',
          },
        },
      },
      publisherCount: {
        name: 'Topic publisher count',
        type: 'gauge',
        description: 'The number of publishers per topic.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_topic_publisher_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{topic}}',
          },
        },
      },
    },
  }
