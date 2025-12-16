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

    activeListeners: {
      name: 'Active listeners',
      type: 'gauge',
      description: 'The number of active listeners for the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_active_listeners{%(queriesSelector)s}',
          legendCustomTemplate: '',
        },
      },
    },

    averageQueueTime: {
      name: 'Average queue time',
      type: 'gauge',
      description: 'The average amount of time a message spends in the queue.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_average_queue_time{%(queriesSelector)s}',
          legendCustomTemplate: '',
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
          expr: 'ibmmq_qmgr_queue_depth{%(queriesSelector)s}',
          legendCustomTemplate: '',
        },
      },
    },

    activeConnections: {
      name: 'Active connections',
      type: 'gauge',
      description: 'The number of active connections for the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_connection_count{%(queriesSelector)s}',
          legendCustomTemplate: '',
        },
      },
    },

    queues: {
      name: 'Queues',
      type: 'raw',
      description: 'The unique number of queues being managed by the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'count(count(ibmmq_queue_depth{%(queriesSelector)s}) by (queue, mq_cluster, qmgr))',
          legendCustomTemplate: '',
        },
      },
    },

    estimatedMemoryUtilization: {
      name: 'Estimated memory utilization',
      type: 'raw',
      description: 'The estimated memory usage of the queue managers.',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: '(ibmmq_qmgr_ram_total_estimate_for_queue_manager_bytes{%(queriesSelector)s}/ibmmq_qmgr_ram_total_bytes{%(queriesSelector)s})',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}}',
        },
      },
    },

    queueManagerStatusUptime: {
      name: 'Queue manager uptime',
      nameShort: 'Uptime',
      type: 'gauge',
      description: 'The uptime of the queue manager.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_uptime{%(queriesSelector)s}',
          legendCustomTemplate: 'Uptime',
        },
      },
    },

    queueManagerStatus: {
      name: 'Queue manager status',
      type: 'gauge',
      description: 'A table showing the status and uptime of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_status{%(queriesSelector)s}',
          legendCustomTemplate: 'Status',
        },
      },
    },

    cpuUsageUser: {
      name: 'CPU usage - user',
      nameShort: 'User',
      type: 'gauge',
      description: 'The user CPU usage of the queue manager.',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_user_cpu_time_percentage{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - user',
        },
      },
    },

    cpuUsageSystem: {
      name: 'CPU usage - system',
      nameShort: 'System',
      type: 'gauge',
      description: 'The system CPU usage of the queue manager.',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_system_cpu_time_percentage{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - system',
        },
      },
    },

    diskUsage: {
      name: 'Disk usage',
      type: 'gauge',
      description: 'The disk allocated to the queue manager that is being used.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_queue_manager_file_system_in_use_bytes{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}}',
        },
      },
    },

    commits: {
      name: 'Commits',
      type: 'gauge',
      description: 'The commits of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_commit_count{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}}',
        },
      },
    },

    publishThroughput: {
      name: 'Publish throughput',
      type: 'gauge',
      description: 'The amount of data being pushed from the queue manager to subscribers.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_published_to_subscribers_bytes{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}}',
        },
      },
    },

    publishedMessages: {
      name: 'Published messages',
      type: 'gauge',
      description: 'The number of messages being published by the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_published_to_subscribers_message_count{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}}',
        },
      },
    },

    expiredMessages: {
      name: 'Expired messages',
      type: 'gauge',
      description: 'The expired messages of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_expired_message_count{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}}',
        },
      },
    },

    queueOperationsMqset: {
      name: 'Queue operations - MQSET',
      nameShort: 'MQSET',
      type: 'raw',
      description: 'The number of MQSET queue operations of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqset_count{%(queriesSelector)s})',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - MQSET',
        },
      },
    },

    queueOperationsMqinq: {
      name: 'Queue operations - MQINQ',
      nameShort: 'MQINQ',
      type: 'raw',
      description: 'The number of MQINQ queue operations of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqinq_count{%(queriesSelector)s})',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - MQINQ',
        },
      },
    },

    queueOperationsMqget: {
      name: 'Queue operations - MQGET',
      nameShort: 'MQGET',
      type: 'raw',
      description: 'The number of MQGET queue operations of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqget_count{%(queriesSelector)s})',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - MQGET',
        },
      },
    },

    queueOperationsMqopen: {
      name: 'Queue operations - MQOPEN',
      nameShort: 'MQOPEN',
      type: 'raw',
      description: 'The number of MQOPEN queue operations of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqopen_count{%(queriesSelector)s})',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - MQOPEN',
        },
      },
    },

    queueOperationsMqclose: {
      name: 'Queue operations - MQCLOSE',
      nameShort: 'MQCLOSE',
      type: 'raw',
      description: 'The number of MQCLOSE queue operations of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqclose_count{%(queriesSelector)s})',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - MQCLOSE',
        },
      },
    },

    queueOperationsMqput: {
      name: 'Queue operations - MQPUT/MQPUT1',
      nameShort: 'MQPUT/MQPUT1',
      type: 'raw',
      description: 'The number of MQPUT/MQPUT1 queue operations of the queue manager.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (mq_cluster, qmgr, job) (ibmmq_queue_mqput_mqput1_count{%(queriesSelector)s})',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}} - MQPUT/MQPUT1',
        },
      },
    },

    logLatency: {
      name: 'Log latency',
      type: 'gauge',
      description: 'The recent latency of log writes.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_log_write_latency_seconds{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}}',
        },
      },
    },

    logUsage: {
      name: 'Log usage',
      type: 'gauge',
      description: 'The amount of data on the filesystem occupied by queue manager logs.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'ibmmq_qmgr_log_in_use_bytes{%(queriesSelector)s}',
          legendCustomTemplate: '{{mq_cluster}} - {{qmgr}}',
        },
      },
    },
  },
}
