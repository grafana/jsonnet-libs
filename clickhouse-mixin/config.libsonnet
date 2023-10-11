{
  _config+:: {
    enableMultiCluster: false,
    clickhouseSelector: if self.enableMultiCluster then 'job=~"$job", instance=~"$instance", cluster=~"$cluster"' else 'job=~"$job", instance=~"$instance"',

    dashboardTags: ['clickhouse-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    dashboardClickhouseErrorFilename: '/var/log/clickhouse-server/clickhouse-server.err.log',
    logExpression: if self.enableMultiCluster then '{job=~"$job", instance=~"$instance", cluster=~"$cluster"}'
    else '{filename="' + self.dashboardClickhouseErrorFilename + '", job=~"$job", instance=~"$instance"}',

    // for alerts
    alertsReplicasMaxQueueSize: '99',

    filterSelector: 'job=~"clickhouse"',

    enableLokiLogs: true,
  },
}
