{
  _config+:: {
    enableMultiCluster: false,
    mssqlSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    dashboardTags: ['mssql-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alert thresholds
    alertsWarningDeadlocks5m: 10,
    alertsWarningModerateReadStallTimeMS: 200,
    alertsCriticalHighReadStallTimeMS: 400,
    alertsWarningModerateWriteStallTimeMS: 200,
    alertsCriticalHighWriteStallTimeMS: 400,

    // enable Loki logs
    enableLokiLogs: true,
  },
}
