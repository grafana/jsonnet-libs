{
  _config+:: {
    enableMultiCluster: false,
    ibmmqSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    dashboardTags: ['ibm-mq-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    logExpression: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster", qmgr=~"$qmgr"'
    else 'job=~"$job", qmgr=~"$qmgr"',

    //alerts thresholds
    alertsExpiredMessages: 2,  //count
    alertsStaleMessagesSeconds: 300,  //seconds
    alertsLowDiskSpace: 5,  //percentage: 0-100
    alertsHighQueueManagerCpuUsage: 85,  //percentage: 0-100

    enableLokiLogs: true,
  },
}
