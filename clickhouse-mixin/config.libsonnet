{
  _config+:: {
    dashboardTags: ['clickhouse-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // for alerts
    alertsReplicasMaxQueueSize: '99',

    filterSelector: 'job=~"clickhouse"',

    enableLokiLogs: true,
  },
}
