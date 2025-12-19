function(this) {
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'ibmmq_queue_depth',
  },
  signals: {

    averageQueueTime: {
      name: 'Average queue time',
      type: 'gauge',
      description: 'The average amount of time a message spends in the queue.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_average_queue_time_seconds{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    expiredMessages: {
      name: 'Expired messages',
      type: 'gauge',
      description: 'The expired messages of the queue.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_expired_messages{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    queueDepth: {
      name: 'Queue depth',
      type: 'gauge',
      description: 'The depth of the queue.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_depth{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    oldestMessageAge: {
      name: 'Oldest message age',
      type: 'gauge',
      description: 'The oldest message age of the queue.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_oldest_message_age{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    inputOutputRate: {
      name: 'Input/output rate',
      type: 'gauge',
      description: 'The input/output rate of the queue.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_input_output_rate{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    timeOnQueue: {
      name: 'Time on queue',
      type: 'gauge',
      description: 'The average time messages spent on the queue.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_time_on_queue_seconds{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    purgedMessages: {
      name: 'Purged messages',
      type: 'gauge',
      description: 'The purged messages from the queue.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_purged_messages{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    inputMessagesBytes: {
      name: 'Input messages - bytes',
      nameShort: 'Input bytes',
      type: 'gauge',
      description: 'The input messages of the queue in bytes.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqput_mqput1_bytes{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    outputMessagesBytes: {
      name: 'Output messages - bytes',
      nameShort: 'Output bytes',
      type: 'gauge',
      description: 'The output messages of the queue in bytes.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_destructive_mqget_bytes{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - {{queue}}',
        },
      },
    },

    mqgetBytes: {
      name: 'MQGET bytes',
      type: 'gauge',
      description: 'The amount of throughput going through the queue via MQGET operations.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqget_bytes{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{qmgr}} - {{queue}} - MQGET',
        },
      },
    },

    mqputBytes: {
      name: 'MQPUT bytes',
      type: 'gauge',
      description: 'The amount of throughput going through the queue via MQPUT operations.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqput_bytes{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{qmgr}} - {{queue}} - MQPUT',
        },
      },
    },

    mqsetCount: {
      name: 'MQSET operations',
      nameShort: 'MQSET',
      type: 'gauge',
      description: 'The number of MQSET queue operations.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqset_count{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{qmgr}} - {{queue}} - MQSET',
        },
      },
    },

    mqinqCount: {
      name: 'MQINQ operations',
      nameShort: 'MQINQ',
      type: 'gauge',
      description: 'The number of MQINQ queue operations.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqinq_count{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{qmgr}} - {{queue}} - MQINQ',
        },
      },
    },

    mqgetCount: {
      name: 'MQGET operations',
      nameShort: 'MQGET',
      type: 'gauge',
      description: 'The number of MQGET queue operations.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqget_count{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{qmgr}} - {{queue}} - MQGET',
        },
      },
    },

    mqopenCount: {
      name: 'MQOPEN operations',
      nameShort: 'MQOPEN',
      type: 'gauge',
      description: 'The number of MQOPEN queue operations.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqopen_count{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{qmgr}} - {{queue}} - MQOPEN',
        },
      },
    },

    mqcloseCount: {
      name: 'MQCLOSE operations',
      nameShort: 'MQCLOSE',
      type: 'gauge',
      description: 'The number of MQCLOSE queue operations.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqclose_count{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{qmgr}} - {{queue}} - MQCLOSE',
        },
      },
    },

    mqputMqput1Count: {
      name: 'MQPUT/MQPUT1 operations',
      nameShort: 'MQPUT/MQPUT1',
      type: 'gauge',
      description: 'The number of MQPUT/MQPUT1 queue operations.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'ibmmq_queue_mqput_mqput1_count{%(queriesSelector)s, queue=~"$queue"}',
          legendCustomTemplate: '{{qmgr}} - {{queue}} - MQPUT/MQPUT1',
        },
      },
    },
  },
}
