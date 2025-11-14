{
  local this = self,

  filteringSelector: 'job="integrations/iis"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  logLabels: ['job', 'instance'],


  // Dashboard settings
  dashboardTags: [this.uid + '-mixin'],
  uid: 'microsoft-iis',
  dashboardNamePrefix: 'Microsoft IIS',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Logs configuration
  enableLokiLogs: true,
  extraLogLabels: ['level'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alert thresholds
  alertsWarningHighRejectedAsyncIORequests: 20,  // count
  alertsCriticalHigh5xxRequests: 5,  // %
  alertsCriticalLowWebsocketConnectionSuccessRate: 80,  // %
  alertsCriticalHighThreadPoolUtilization: 90,  // %
  alertsWarningHighWorkerProcessFailures: 10,  // count

  // Metrics source
  metricsSource: 'prometheus',

  // Signal definitions grouped by dashboard
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    applications: (import './signals/applications.libsonnet')(this),
  },
}
