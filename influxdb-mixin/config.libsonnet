{
  local this = self,
  filteringSelector: 'job="integrations/influxdb"',
  groupLabels: ['job', 'influxdb_cluster'],
  instanceLabels: ['instance'],
  dashboardTags: ['influxdb-mixin'],
  uid: 'influxdb',
  dashboardNamePrefix: 'InfluxDB',

  // additional params
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // logs lib related
  enableLokiLogs: true,
  logLabels: ['job', 'instance', 'influxdb_cluster', 'level'],
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alert thresholds
  alertsWarningTaskSchedulerHighFailureRate: 25,  // %
  alertsCriticalTaskSchedulerHighFailureRate: 50,  // %
  alertsWarningHighBusyWorkerPercentage: 80,  // %
  alertsWarningHighHeapMemoryUsage: 80,  // %
  alertsWarningHighAverageAPIRequestLatency: 0.3,  // count
  alertsWarningSlowAverageIQLExecutionTime: 0.1,  // count

  // metrics source for signals library
  metricsSource: 'prometheus',

  legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    instance: (import './signals/instance.libsonnet')(this),
  },
}
