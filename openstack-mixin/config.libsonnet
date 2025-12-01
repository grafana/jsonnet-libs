{
  filteringSelector: 'job="integrations/openstack"',
  groupLabels: ['job'],
  // instance of openstack cluster
  instanceLabels: ['instance'],
  nodeLabel: 'hostname',
  uid: 'openstack',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  alertsWarningPlacementHighMemoryUsage: 80,  // %
  alertsCriticalPlacementHighMemoryUsage: 90,  // %
  alertsWarningPlacementHighVCPUUsage: 80,  // %
  alertsCriticalPlacementHighVCPUUsage: 90,  // %
  alertsWarningNeutronHighIPsUsage: 80,  // %
  alertsCriticalNeutronHighIPsUsage: 90,  // %
  alertsWarningNovaHighVMMemoryUsage: 80,  // %
  alertsWarningNovaHighVMVCPUUsage: 80,  // %
  alertsCriticalNeutronHighDisconnectedPortRate: 25,  // %
  alertsCriticalNeutronHighInactiveRouterRate: 15,  // %
  alertsWarningCinderHighBackupMemoryUsage: 80,  // %
  alertsWarningCinderHighVolumeMemoryUsage: 80,  // %
  alertsWarningCinderHighPoolCapacityUsage: 80,  // %
  // alert when this percent of VMs not running on the single host,
  // while there is at least this total number of instances overall.
  alertsCriticalVMsNotRunningPercent: 75,  // %
  alertsCriticalVMsNotRunningInstanceMin: 10,

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
