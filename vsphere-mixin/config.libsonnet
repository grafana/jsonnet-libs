{
  local this = self,
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: '',
  // Used to identify 'group' of instances.
  groupLabels: ['job'],
  datacenterLabels: ['vcenter_datacenter_name'],
  clusterLabels: ['vcenter_cluster_name'],
  hostLabels: ['vcenter_cluster_name', 'vcenter_host_name'],
  virtualMachineLabels: ['vcenter_cluster_name', 'vcenter_host_name', 'vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path', 'vcenter_vm_name'],
  // Prefix all dashboards uids and alert groups
  uid: 'vsphere',
  // Prefix for all Dashboards and (optional) rule groups
  dashboardNamePrefix: 'vSphere',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  customAllValue: '.*',  // Override this as desired. '.+' is a good option if you want to ensure a label is present.

  // Alert thresholds
  alertsHighCPUUtilization: 90,  // Percent. Fires VSphereHostInfoCpuUtilization when an ESXi host's CPU utilization stays above this for 15m.
  alertsHighMemoryUtilization: 90,  // Percent. Fires VSphereHostWarningMemoryUtilization when an ESXi host's memory utilization stays above this for 15m.
  alertsWarningDiskUtilization: 75,  // Percent. Fires VSphereDatastoreWarningDiskUtilization when a datastore's disk utilization stays above this for 5m.
  alertsCriticalDiskUtilization: 90,  // Percent. Fires VSphereDatastoreCriticalDiskUtilization when a datastore's disk utilization stays above this for 5m.
  alertsHighPacketErrors: 20,  // Percent of total packets. Fires VSphereHostWarningHighPacketErrors when an ESXi host's packet error ratio stays above this for 5m.
  // Logs lib related
  // Set to false to disable logs dashboard and logs annotations
  enableLokiLogs: true,
  extraLogLabels: ['instance', 'log_type', 'level'],
  showLogsVolume: true,

  // Source(s) used when unmarshalling signals into panel targets.
  metricsSource: ['prometheus'],

  // Signal definitions, grouped by domain. Pass `this` (the config) so the
  // signal files can read the config's label lists. Passing `self` would
  // resolve to the inner `signals` object and fail at unmarshal time.
  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    datastore: (import './signals/datastore.libsonnet')(this),
    cluster: (import './signals/cluster.libsonnet')(this),
    host: (import './signals/host.libsonnet')(this),
    vm: (import './signals/vm.libsonnet')(this),
  },
}
