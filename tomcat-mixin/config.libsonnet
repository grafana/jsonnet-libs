{
  _config+:: {
    enableMultiCluster: false,
    tomcatSelector: if self.enableMultiCluster then 'job=~"$job", instance=~"$instance", cluster=~"$cluster"'
    else 'job=~"$job", instance=~"$instance"',

    dashboardTags: ['apache-tomcat-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    ApacheTomcatAlertsCriticalCpuUsage: 80,  //%
    ApacheTomcatAlertsCriticalMemoryUsage: 80,  //%
    ApacheTomcatAlertsCriticalRequestErrorPercentage: 5,  //%
    ApacheTomcatAlertsWarningProcessingTime: 300,  //ms
    dashboardCatalinaFilename: '/var/log/tomcat.*/catalina.out|/opt/tomcat/logs/catalina.out',
    logExpression: if self.enableMultiCluster then '{job=~"$job", instance=~"$instance", cluster=~"$cluster"}'
    else '{filename="' + self.dashboardCatalinaFilename + '", job=~"$job", instance=~"$instance"}',

    enableLokiLogs: true,
  },
}
