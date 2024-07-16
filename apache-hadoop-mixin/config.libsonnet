{
  _config+:: {
    dashboardTags: ['apache-hadoop-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsWarningHDFSCapacity: 20,  // %
    alertsCriticalHDFSMissingBlocks: 0,  // count
    alertsCriticalHDFSVolumeFailures: 0,  // count
    alertsCriticalDeadDataNodes: 0,  // count
    alertsCriticalNodeManagerCPUUsage: 80,  // %
    alertsCriticalNodeManagerMemoryUsage: 80,  // %
    alertsCriticalResourceManagerVCoreCPUUsage: 80,  // %
    alertsCriticalResourceManagerMemoryUsage: 80,  // %

    enableLokiLogs: true,
    enableMultiCluster: false,
    hadoopSelector: if self.enableMultiCluster then 'job=~"$job", cluster=~"$cluster", hadoop_cluster=~"$hadoop_cluster"' else 'job=~"$job", hadoop_cluster=~"$hadoop_cluster"',
  },
}
