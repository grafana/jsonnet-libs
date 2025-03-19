{
  _config+:: {
    dashboardTags: ['sap-hana-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsCriticalHighCpuUsage: 80,  // percent 0-100
    alertsCriticalHighPhysicalMemoryUsage: 80,  // percent 0-100
    alertsWarningLowMemAllocLimit: 90,  // percent 0-100
    alertsCriticalHighMemoryUsage: 80,  // percent 0-100
    alertsCriticalHighDiskUtilization: 80,  //percent 0-100
    alertsCriticalHighSqlExecutionTime: 1,  // second
    alertsCriticalHighReplicationShippingTime: 1,  //second

    enableLokiLogs: true,
  },
}
