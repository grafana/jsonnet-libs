{
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: 'job=~"integrations/vsphere"',
  // Used to identify 'group' of instances.
  groupLabels: ['job'],
  instanceLabel: ['instance'],
  testNameLabel: ['test_name'],
  nodeNameLabel: ['node_name'],
  // Prefix all dashboards uids and alert groups
  uid: 'catchpoint',
  // Prefix for all Dashboards and (optional) rule groups
  dashboardNamePrefix: 'Catchpoint',
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
