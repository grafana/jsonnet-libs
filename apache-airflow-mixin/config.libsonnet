{
  local this = self,
  filteringSelector: 'job=~"$job", instance=~"$instance"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  dashboardTags: ['apache-airflow-mixin'],
  uid: 'apache-airflow',
  dashboardNamePrefix: 'Apache Airflow',

  // additional params
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // logs lib related
  enableLokiLogs: true,
  logLabels: ['job', 'instance', 'filename'],
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alert thresholds
  alertsCriticalPoolStarvingTasks: 0,  // count
  alertsWarningDAGScheduleDelayLevel: 10,  // s
  alertsCriticalDAGScheduleDelayLevel: 60,  // s
  alertsCriticalFailedDAGs: 0,  // count

  // multi-cluster support
  enableMultiCluster: false,

  // metrics source for signals library
  metricsSource: 'prometheus',

  legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
  signals+: {
    dags: (import './signals/dags.libsonnet')(this),
    tasks: (import './signals/tasks.libsonnet')(this),
    scheduler: (import './signals/scheduler.libsonnet')(this),
    executor: (import './signals/executor.libsonnet')(this),
    pools: (import './signals/pools.libsonnet')(this),
  },
}
