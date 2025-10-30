function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {
      messagesReceived: {
        name: 'Subscription messages received',
        type: 'counter',
        description: 'The number of messages a subscription receives.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_subscription_messsages_received{%(queriesSelector)s}',
            legendCustomTemplate: '{{subscription}}',
          },
        },
      },
      timeSinceMessagePublished: {
        name: 'Time since message published',
        type: 'gauge',
        description: 'The time since a message was published to the subscription.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'ibmmq_subscription_time_since_message_published{%(queriesSelector)s}',
            legendCustomTemplate: '{{subscription}}',
          },
        },
      },
    },
  }
