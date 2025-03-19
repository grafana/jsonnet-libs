{
  _config+:: {
    enableMultiCluster: false,
    oracledbSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    dashboardTags: ['oracledb-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    alertsFileDescriptorThreshold: '85',  // %
    alertsProcessThreshold: '85',  // %
    alertsSessionThreshold: '85',  // %
    alertsTablespaceThreshold: '85',  // %

    // enable Loki logs
    enableLokiLogs: true,
  },
}
