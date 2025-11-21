function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {
      activeListeners: {
        name: 'Active listeners',
        type: 'gauge',
        description: 'The number of active listeners for the queue manager.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_active_listeners{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      connectionCount: {
        name: 'Connection count',
        type: 'gauge',
        description: 'The number of active connections for the queue manager.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_connection_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      status: {
        name: 'Queue manager status',
        type: 'gauge',
        description: 'The status of the queue manager (-1=N/A, 0=Stopped, 1=Starting, 2=Running, 3=Quiescing, 4=Stopping, 5=Standby).',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_status{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      uptime: {
        name: 'Queue manager uptime',
        type: 'gauge',
        description: 'The uptime of the queue manager.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_uptime{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      userCpuTimePercentage: {
        name: 'User CPU time percentage',
        type: 'gauge',
        description: 'The user CPU usage percentage of the queue manager.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_user_cpu_time_percentage{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}} - user',
          },
        },
      },
      systemCpuTimePercentage: {
        name: 'System CPU time percentage',
        type: 'gauge',
        description: 'The system CPU usage percentage of the queue manager.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_system_cpu_time_percentage{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}} - system',
          },
        },
      },
      userCpuTimeEstimatePercentage: {
        name: 'User CPU time estimate percentage',
        type: 'gauge',
        description: 'The estimated user CPU usage percentage for the queue manager.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_user_cpu_time_estimate_for_queue_manager_percentage{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      ramTotalBytes: {
        name: 'RAM total bytes',
        type: 'gauge',
        description: 'The total RAM available to the queue manager.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_ram_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      ramTotalEstimateBytes: {
        name: 'RAM total estimate bytes',
        type: 'gauge',
        description: 'The estimated total RAM usage of the queue manager.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_ram_total_estimate_for_queue_manager_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      memoryUtilization: {
        name: 'Memory utilization',
        type: 'raw',
        description: 'The estimated memory utilization of the queue manager as a ratio.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: '(ibmmq_qmgr_ram_total_estimate_for_queue_manager_bytes{%(queriesSelector)s}/ibmmq_qmgr_ram_total_bytes{%(queriesSelector)s})',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      queueManagerFileSystemInUseBytes: {
        name: 'Queue manager file system in use bytes',
        type: 'gauge',
        description: 'The disk allocated to the queue manager that is being used.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_queue_manager_file_system_in_use_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      queueManagerFileSystemFreeSpacePercentage: {
        name: 'Queue manager file system free space percentage',
        type: 'gauge',
        description: 'The percentage of free disk space available for the queue manager.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_queue_manager_file_system_free_space_percentage{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      commitCount: {
        name: 'Commit count',
        type: 'counter',
        description: 'The number of commits by the queue manager.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_commit_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      publishedToSubscribersBytes: {
        name: 'Published to subscribers bytes',
        type: 'counter',
        description: 'The amount of data being pushed from the queue manager to subscribers.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_published_to_subscribers_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      publishedToSubscribersMessageCount: {
        name: 'Published to subscribers message count',
        type: 'counter',
        description: 'The number of messages being published by the queue manager.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_published_to_subscribers_message_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      expiredMessageCount: {
        name: 'Expired message count',
        type: 'counter',
        description: 'The number of expired messages for the queue manager.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_expired_message_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      logWriteLatencySeconds: {
        name: 'Log write latency seconds',
        type: 'gauge',
        description: 'The recent latency of log writes.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_log_write_latency_seconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
      logInUseBytes: {
        name: 'Log in use bytes',
        type: 'gauge',
        description: 'The amount of data on the filesystem occupied by queue manager logs.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'ibmmq_qmgr_log_in_use_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{qmgr}}',
          },
        },
      },
    },
  }
