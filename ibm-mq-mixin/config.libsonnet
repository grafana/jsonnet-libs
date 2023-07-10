{
  _config+:: {
    dashboardTags: ['ibm-mq-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alerts thresholds
    alertsExpiredMessages: 2,  //count
    alertsStaleMessagesSeconds: 300,  //seconds
    alertsLowDiskSpace: 5,  //percentage: 0-100
    alertsHighQueueManagerCpuUsage: 85,  //percentage: 0-100
    enableLokiLogs: true,
  },
}
