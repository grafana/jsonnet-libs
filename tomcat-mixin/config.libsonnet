{
  _config+:: {
    dashboardTags: ['apache-tomcat-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    ApacheTomcatAlertsCriticalCpuUsage: 80,  //%
    ApacheTomcatAlertsCriticalMemoryUsage: 80,  //%
    ApacheTomcatAlertsCriticalRequestErrorPercentage: 5,  //%
    ApacheTomcatAlertsWarningProcessingTime: 300,  //ms

    enableLokiLogs: true,
  },
}
