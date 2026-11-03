local commonlib = import 'common-lib/common/main.libsonnet';

{
  local this = self,
  filteringSelector: '',
  groupLabels: ['job'],
  // instance of openstack cluster
  instanceLabels: ['instance'],
  nodeLabel: 'hostname',
  uid: 'openstack',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: commonlib.dashboards.defaultTimezone,
  dashboardRefresh: '1m',
  metricsSource: ['prometheus'],

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

  // The `query` template function is only supported by Prometheus/Mimir (datasource-managed) rule evaluation.
  // Set to false when alerts are installed as Grafana-managed rules, which do not support it.
  alertsQueryTemplateEnabled: true,

  // logs lib related
  enableLokiLogs: true,
  customAllValue: '.*',  // Override this as desired. '.+' is a good option if you want to ensure a label is present.
  logsExtraFilters: '',
  extraLogLabels: ['level', 'service'],
  logsVolumeGroupBy: 'level',
  logsFilteringSelector: self.filteringSelector,
  showLogsVolume: true,

  // Signals configuration
  signals+: {
    placement: (import './signals/placement.libsonnet')(this),
    identity: (import './signals/identity.libsonnet')(this),
    nova: (import './signals/nova.libsonnet')(this),
    neutron: (import './signals/neutron.libsonnet')(this),
    cinder: (import './signals/cinder.libsonnet')(this),
    glance: (import './signals/glance.libsonnet')(this),
  },
}
