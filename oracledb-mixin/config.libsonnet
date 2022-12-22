{
  _config+:: {
    dashboardTags: ['oracledb-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // enable Loki logs
    enableLokiLogs: true,
  },
}
