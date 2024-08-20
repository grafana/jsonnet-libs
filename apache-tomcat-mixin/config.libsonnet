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

    // used in alerts:
    filteringSelector: 'job=~"integrations/tomcat"',
    groupLabels: if self.enableMultiCluster then ['job', 'cluster'] else ['job'],
    instanceLabels: ['instance'],


    enableLokiLogs: true,
    enableMultiCluster: false,
    multiclusterSelector: 'job=~"$job"',
    tomcatSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
  },
}
