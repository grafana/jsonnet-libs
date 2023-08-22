{
  _config+:: {
    enableMultiCluster: false,
    aerospikeSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster"' else 'job=~"$job"',
    multiclusterSelector: 'job=~"$job"',

    dashboardTags: ['aerospike-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsCriticalNodeHighMemoryUsage: 80,  // %
    alertsCriticalNamespaceHighDiskUsage: 80,  // %
    alertsCriticalUnavailablePartitions: 0,  // count
    alertsCriticalDeadPartitions: 0,  // count
    alertsCriticalSystemRejectingWrites: 0,  // count
    alertsWarningHighClientReadErrorRate: 25,  // %
    alertsWarningHighClientWriteErrorRate: 25,  // %
    alertsWarningHighClientUDFErrorRate: 25,  // %

    enableLokiLogs: true,
  },
}
