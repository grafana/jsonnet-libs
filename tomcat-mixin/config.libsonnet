{
  _config+:: {
    dashboardTags: ['apache-tomcat-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    alertsCriticalCpuUsage: 80,  //%
    alertsCriticalMemoryUsage: 80,  //%
    alertsCriticalRequestErrorPercentage: 5,  //%
    alertsWarningProcessingTime: 300,  //ms

    enableLokiLogs: true,
  },
}
