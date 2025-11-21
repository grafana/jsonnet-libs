function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {
      xmitqTimeShort: {
        name: 'Transmission queue time short',
        type: 'gauge',
        description: 'An average, minimum, or maximum time taken to transmit messages over the channel in recent intervals.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'ibmmq_channel_xmitq_time_short{type="SENDER",%(queriesSelector)s}',
            legendCustomTemplate: '{{channel}} - short',
          },
        },
      },
      xmitqTimeLong: {
        name: 'Transmission queue time long',
        type: 'gauge',
        description: 'Total time taken for messages to be transmitted over the channel.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'ibmmq_channel_xmitq_time_long{type=~"SENDER",%(queriesSelector)s}',
            legendCustomTemplate: '{{channel}} - long',
          },
        },
      },
    },
  }
