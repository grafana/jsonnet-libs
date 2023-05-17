{
  _config+:: {
    dashboardTags: ['apache-airflow-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    //alert thresholds
    alertsCriticalPoolStarvingTasks: 0,
    alertsWarningDAGScheduleDelayLevel: 10,  //s
    alertsCriticalDAGScheduleDelayLevel: 60,  //s
    alertsCriticalFailedDAGs: 0,

    enableLokiLogs: true,
  },
}
