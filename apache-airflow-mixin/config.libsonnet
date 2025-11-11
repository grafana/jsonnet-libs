{
  local this = self,
  filteringSelector: 'job="integrations/apache-airflow"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  overviewLabels: [],
  dashboardTags: ['apache-airflow-mixin'],
  uid: 'apache-airflow',
  dashboardNamePrefix: 'Apache Airflow',

  // additional params
  dashboardPeriod: 'now-6h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // logs lib related
  enableLokiLogs: true,
  logLabels: ['job', 'instance'],
  extraLogLabels: ['dag_file', 'filename'],  // Required by logs-lib
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

  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
  },
}
