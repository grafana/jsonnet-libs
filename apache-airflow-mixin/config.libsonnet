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
    enableMultiCluster: false,

    multiclusterSelector: 'job=~"$job"',
    airflowSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
  },
}
