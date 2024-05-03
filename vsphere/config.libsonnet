{
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: 'job=~"integrations/vsphere"',
  // Used to identify 'group' of instances.
  groupLabels: ['job', 'vcenter_datacenter_name'],
  clusterLabels: ['vcenter_cluster_name'],
  hostLabels: ['vcenter_host_name'],
  resourcePoolLabels: ['vcenter_resource_pool_name'],
  virtualMachineLabels: ['vcenter_vm_name'],
  // Prefix all dashboards uids and alert groups
  uid: 'vSphere',
  // Prefix for all Dashboards and (optional) rule groups
  dashboardNamePrefix: 'vSphere',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Alert thresholds

  // Logs lib related
  // Set to false to disable logs dashboard and logs annotations
  enableLokiLogs: true,
  extraLogLabels: ['level'],
  showLogsVolume: true,
}
