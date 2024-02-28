{
  filteringSelector: 'job="integrations/openstack"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],

  uid: 'openstack',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  alertsWarningPlacementHighMemoryUsage: 80,  // %
  alertsCriticalPlacementHighMemoryUsage: 90,  // %
  alertsWarningNovaHighVMMemoryUsage: 80,  // %
  alertsWarningNovaHighVMVCPUUsage: 80,  // %
  alertsCriticalNeutronHighDisconnectedPortRate: 25,  // %
  alertsCriticalNeutronHighInactiveRouterRate: 15,  // %
  alertsWarningCinderHighBackupMemoryUsage: 80,  // %
  alertsWarningCinderHighVolumeMemoryUsage: 80,  // %
  alertsWarningCinderHighPoolCapacityUsage: 80,  // %

  // logs lib related
  enableLokiLogs: true,
  logsExtraFilters: '',
  extraLogLabels: ['level', 'service'],
  logsVolumeGroupBy: 'level',
  logsFilteringSelector: self.filteringSelector,
  showLogsVolume: true,
}
