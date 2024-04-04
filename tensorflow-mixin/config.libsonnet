{
  _config+:: {
    enableMultiCluster: false,
    tensorflowSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    multiclusterSelector: 'job=~"$job"',
    dashboardTags: ['tensorflow-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // enable Loki logs
    enableLokiLogs: true,

    // for alerts
    alertsModelRequestErrorRate: '30',  // %
    alertsBatchQueuingLatency: '5000000',  // µs
  },
}
