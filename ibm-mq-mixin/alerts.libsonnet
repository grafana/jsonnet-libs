{
  new(this): {
    groups: [
      {
        name: this.config.uid + '-alerts',
        rules: [
          {
            alert: 'IBMMQExpiredMessages',
            expr: |||
              sum without (description,hostname,instance,job,platform) (ibmmq_qmgr_expired_message_count) > %(alertsExpiredMessages)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are expired messages, which imply that application resilience is failing.',
              description:
                (
                  'The number of expired messages in the {{$labels.qmgr}} is {{$value}} which is above the threshold of %(alertsExpiredMessages)s.'
                ) % this.config,
            },
          },
          {
            alert: 'IBMMQStaleMessages',
            expr: |||
              sum without (description,instance,job,platform) (ibmmq_queue_oldest_message_age) >= %(alertsStaleMessagesSeconds)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Stale messages have been detected.',
              description:
                (
                  'A stale message with an age of {{$value}} has been sitting in the {{$labels.queue}} which is above the threshold of %(alertsStaleMessagesSeconds)s seconds.'
                ) % this.config,
            },
          },
          {
            alert: 'IBMMQLowDiskSpace',
            expr: |||
              sum without (description,hostname,instance,job,platform) (ibmmq_qmgr_queue_manager_file_system_free_space_percentage) <= %(alertsLowDiskSpace)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is limited disk available for a queue manager.',
              description:
                (
                  'The amount of disk space available for {{$labels.qmgr}} is at {{$value}}%% which is below the threshold of %(alertsLowDiskSpace)s%%.'
                ) % this.config,
            },
          },
          {
            alert: 'IBMMQHighQMgrCpuUsage',
            expr: |||
              sum without (description,hostname,instance,job,platform) (ibmmq_qmgr_user_cpu_time_estimate_for_queue_manager_percentage) >= %(alertsHighQueueManagerCpuUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high CPU usage estimate for a queue manager.',
              description:
                (
                  'The amount of CPU usage for the queue manager {{$labels.qmgr}} is at {{$value}}%% which is above the threshold of %(alertsHighQueueManagerCpuUsage)s%%.'
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
