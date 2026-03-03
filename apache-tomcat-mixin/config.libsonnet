{
  local this = self,
  filteringSelector: 'job="integrations/tomcat"',
  groupLabels: ['job', 'cluster'],
  logLabels: [],
  instanceLabels: ['instance'],

  uid: 'apache-tomcat',
  dashboardTags: [self.uid + '-mixin'],
  dashboardNamePrefix: 'Apache Tomcat',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: ['prometheus'],  // metrics source for signals


  // Logging configuration
  enableLokiLogs: true,
  customAllValue: '.*',  // Override this as desired. '.+' is a good option if you want to ensure a label is present.
  extraLogLabels: ['level'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alert thresholds
  alertsCriticalCpuUsage: 80,  //%
  alertsCriticalMemoryUsage: 80,  //%
  alertsCriticalRequestErrorPercentage: 5,  //%
  alertsWarningProcessingTime: 300,  //ms

  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    hosts: (import './signals/hosts.libsonnet')(this),
  },
}
