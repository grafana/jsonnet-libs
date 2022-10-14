{
  _config+:: {
    dashboardTags: ['clickhouse-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // enable Loki logs
    enableLokiLogs: true,
  },
}
