{
  _config+:: {
    enableMultiCluster: true,
    ibmmqSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job", instance=~"$instance"',
    dashboardTags: ['ibm-mq-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    logExpression: if self.enableMultiCluster then '{job=~"$job", cluster=~"$cluster"'
    else '{job=~"$job"',

    //alerts thresholds
    alertsExpiredMessages: 2,  //count
    alertsStaleMessagesSeconds: 300,  //seconds
    alertsLowDiskSpace: 5,  //percentage: 0-100
    alertsHighQueueManagerCpuUsage: 85,  //percentage: 0-100

    enableLokiLogs: true,
  },
}
