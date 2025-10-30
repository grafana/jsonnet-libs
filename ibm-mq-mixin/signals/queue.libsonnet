function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {
      depth: {
        name: 'Queue depth',
        type: 'gauge',
        description: 'The number of active messages in the queue.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_depth{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}}',
          },
        },
      },
      averageQueueTimeSeconds: {
        name: 'Average queue time seconds',
        type: 'gauge',
        description: 'The average amount of time a message spends in the queue.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_average_queue_time_seconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}}',
          },
        },
      },
      expiredMessages: {
        name: 'Expired messages',
        type: 'counter',
        description: 'The number of expired messages in the queue.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_expired_messages{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}}',
          },
        },
      },
      oldestMessageAge: {
        name: 'Oldest message age',
        type: 'gauge',
        description: 'The age of the oldest message in the queue.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_oldest_message_age{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}}',
          },
        },
      },
      mqsetCount: {
        name: 'MQSET count',
        type: 'counter',
        description: 'The number of MQSET operations on the queue.',
        unit: 'operations',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_mqset_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}} - MQSET',
          },
        },
      },
      mqinqCount: {
        name: 'MQINQ count',
        type: 'counter',
        description: 'The number of MQINQ operations on the queue.',
        unit: 'operations',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_mqinq_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}} - MQINQ',
          },
        },
      },
      mqgetCount: {
        name: 'MQGET count',
        type: 'counter',
        description: 'The number of MQGET operations on the queue.',
        unit: 'operations',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_mqget_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}} - MQGET',
          },
        },
      },
      mqopenCount: {
        name: 'MQOPEN count',
        type: 'counter',
        description: 'The number of MQOPEN operations on the queue.',
        unit: 'operations',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_mqopen_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}} - MQOPEN',
          },
        },
      },
      mqcloseCount: {
        name: 'MQCLOSE count',
        type: 'counter',
        description: 'The number of MQCLOSE operations on the queue.',
        unit: 'operations',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_mqclose_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}} - MQCLOSE',
          },
        },
      },
      mqputMqput1Count: {
        name: 'MQPUT/MQPUT1 count',
        type: 'counter',
        description: 'The number of MQPUT/MQPUT1 operations on the queue.',
        unit: 'operations',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_mqput_mqput1_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}} - MQPUT/MQPUT1',
          },
        },
      },
      mqgetBytes: {
        name: 'MQGET bytes',
        type: 'counter',
        description: 'The throughput via MQGET operations.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_mqget_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}} - MQGET',
          },
        },
      },
      mqputBytes: {
        name: 'MQPUT bytes',
        type: 'counter',
        description: 'The throughput via MQPUT operations.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'ibmmq_queue_mqput_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{queue}} - MQPUT',
          },
        },
      },
    },
  }
