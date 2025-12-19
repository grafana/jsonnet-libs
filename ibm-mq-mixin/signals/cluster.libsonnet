function(this) {
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'ibmmq_qmgr_commit_count',
  },
  signals: {

    clusters: {
      name: 'Clusters',
      type: 'raw',
      description: 'The unique number of clusters being reported.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'count(count(ibmmq_qmgr_commit_count{%(queriesSelector)s}) by (mq_cluster))',
          legendCustomTemplate: '{{job}} - {{mq_cluster}}',
        },
      },
    },

    queueManagers: {
      name: 'Queue managers',
      type: 'raw',
      description: 'The unique number of queue managers in the cluster being reported.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'count(count(ibmmq_qmgr_commit_count{%(queriesSelector)s}) by (qmgr, mq_cluster))',
          legendCustomTemplate: '{{}}',
        },
      },
    },

    topics: {
      name: 'Topics',
      type: 'raw',
      description: 'The unique number of topics in the cluster.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'count(count(ibmmq_topic_messages_received{%(queriesSelector)s}) by (topic, mq_cluster))',
          legendCustomTemplate: '{{job}} - {{mq_cluster}}',
        },
      },
    },

    queues: {
      name: 'Queues',
      type: 'raw',
      description: 'The unique number of queues in the cluster.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'count(count(ibmmq_queue_depth{%(queriesSelector)s}) by (queue, mq_cluster))',
          legendCustomTemplate: '',
        },
      },
    },

    queueOperationsMqset: {
      name: 'Queue operations - MQSET',
      nameShort: 'MQSET',
      type: 'raw',
      description: 'The number of MQSET queue operations of the cluster.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster) (ibmmq_queue_mqset_count{%(queriesSelector)s})',
          legendCustomTemplate: 'MQSET',
        },
      },
    },

    queueOperationsMqinq: {
      name: 'Queue operations - MQINQ',
      nameShort: 'MQINQ',
      type: 'raw',
      description: 'The number of MQINQ queue operations of the cluster.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster) (ibmmq_queue_mqinq_count{%(queriesSelector)s})',
          legendCustomTemplate: 'MQINQ',
        },
      },
    },

    queueOperationsMqget: {
      name: 'Queue operations - MQGET',
      nameShort: 'MQGET',
      type: 'raw',
      description: 'The number of MQGET queue operations of the cluster.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster) (ibmmq_queue_mqget_count{%(queriesSelector)s})',
          legendCustomTemplate: 'MQGET',
        },
      },
    },

    queueOperationsMqopen: {
      name: 'Queue operations - MQOPEN',
      nameShort: 'MQOPEN',
      type: 'raw',
      description: 'The number of MQOPEN queue operations of the cluster.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster) (ibmmq_queue_mqopen_count{%(queriesSelector)s})',
          legendCustomTemplate: 'MQOPEN',
        },
      },
    },

    queueOperationsMqclose: {
      name: 'Queue operations - MQCLOSE',
      nameShort: 'MQCLOSE',
      type: 'raw',
      description: 'The number of MQCLOSE queue operations of the cluster.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster) (ibmmq_queue_mqclose_count{%(queriesSelector)s})',
          legendCustomTemplate: 'MQCLOSE',
        },
      },
    },

    queueOperationsMqput: {
      name: 'Queue operations - MQPUT/MQPUT1',
      nameShort: 'MQPUT/MQPUT1',
      type: 'raw',
      description: 'The number of MQPUT/MQPUT1 queue operations of the cluster.',
      unit: 'operations',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster) (ibmmq_queue_mqput_mqput1_count{%(queriesSelector)s})',
          legendCustomTemplate: 'MQPUT/MQPUT1',
        },
      },
    },

    clusterStatus: {
      name: 'Cluster status',
      type: 'gauge',
      description: 'The status of the cluster.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_cluster_suspend{%(queriesSelector)s}',
          legendCustomTemplate: '{{job}} - {{mq_cluster}}',
          valueMappings: [
            {
              type: 'value',
              options: {
                '0': {
                  text: 'Not suspended',
                  color: 'green',
                  index: 0,
                },
                '1': {
                  text: 'Suspended',
                  color: 'red',
                  index: 1,
                },
              },
            },
          ],
        },
      },
    },

    queueManagerStatus: {
      name: 'Queue manager status',
      type: 'gauge',
      description: 'The queue managers of the cluster displayed in a table.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_status{%(queriesSelector)s}',
          legendCustomTemplate: '',
          valueMappings: [
            {
              type: 'value',
              options: {
                '-1': {
                  text: 'N/A',
                  color: 'dark-red',
                  index: 0,
                },
                '0': {
                  text: 'Stopped',
                  color: 'red',
                  index: 1,
                },
                '1': {
                  text: 'Starting',
                  color: 'light-green',
                  index: 2,
                },
                '2': {
                  text: 'Running',
                  color: 'green',
                  index: 3,
                },
                '3': {
                  text: 'Quiescing',
                  color: 'yellow',
                  index: 4,
                },
                '4': {
                  text: 'Stopping',
                  color: 'light-red',
                  index: 5,
                },
                '5': {
                  text: 'Standby',
                  color: 'yellow',
                  index: 6,
                },
              },
            },
          ],
        },
      },
    },

    transmissionQueueTimeShort: {
      name: 'Transmission queue time - short',
      nameShort: 'Short',
      type: 'gauge',
      description: 'The time it takes for the messages to get through the transmission queue. (Long) - total time taken for messages to be transmitted over the channel, (Short) - an average, minimum, or maximum time taken to transmit messages over the channel in recent intervals.',
      unit: 'µs',
      sources: {
        prometheus: {
          expr: 'ibmmq_channel_xmitq_time_short{type="SENDER", %(queriesSelector)s}',
          legendCustomTemplate: '{{channel}} - short',
        },
      },
    },

    transmissionQueueTimeLong: {
      name: 'Transmission queue time - long',
      nameShort: 'Long',
      type: 'gauge',
      description: 'The time it takes for the messages to get through the transmission queue. (Long) - total time taken for messages to be transmitted over the channel, (Short) - an average, minimum, or maximum time taken to transmit messages over the channel in recent intervals.',
      unit: 'µs',
      sources: {
        prometheus: {
          expr: 'ibmmq_channel_xmitq_time_long{type=~"SENDER", %(queriesSelector)s}',
          legendCustomTemplate: '{{channel}} - long',
        },
      },
    },
  },
}
