{
  filteringSelector: 'job="integrations/openstack"',
  groupLabels: ['job'],
  // instance of openstack cluster
  // instance of openstack cluster
  instanceLabels: ['instance'],

  uid: 'openstack',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  alertsWarningPlacementHighMemoryUsage: 80,  // %
  alertsCriticalPlacementHighMemoryUsage: 90,  // %
  alertsWarningPlacementHighVcpuUsage: 80,  // %
  alertsCriticalPlacementHighVcpuUsage: 90,  // %
  alertsWarningNeutronHighIPsUsage: 80,  // %
  alertsCriticalNeutronHighIPSUsage: 90,  // %
  alertsWarningNovaHighVMMemoryUsage: 80,  // %
  alertsWarningNovaHighVMVCPUUsage: 80,  // %
  alertsCriticalNeutronHighDisconnectedPortRate: 25,  // %
  alertsCriticalNeutronHighInactiveRouterRate: 15,  // %
  alertsWarningCinderHighBackupMemoryUsage: 80,  // %
  alertsWarningCinderHighVolumeMemoryUsage: 80,  // %
  alertsWarningCinderHighPoolCapacityUsage: 80,  // %

  // legend is used by panels 'Users', 'VMs', 'Networks', 'Subnets', 'Security Groups', 'Volumes', 'Snapshots', 'Image count'
  legendTemplate: '{{instance}}',

  // regex to match network names where we should track IP address utilization:
  alertsIPutilizationNetworksMatcher: '.+',

  // logs lib related
  enableLokiLogs: true,
  logsExtraFilters: '',
  extraLogLabels: ['level', 'service'],
  logsVolumeGroupBy: 'level',
  logsFilteringSelector: self.filteringSelector,
  showLogsVolume: true,
}
