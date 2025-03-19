{
  // any modular library should include as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids
  local this = self,
  filteringSelector: 'job="integrations/helloworld"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  dashboardTags: [self.uid],
  uid: 'helloworld',
  dashboardNamePrefix: '',

  // additional params can be added if needed
  criticalEvents: '90',
  alertsThreshold1: '90',
  alertsThreshold2: '75',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // logs lib related
  enableLokiLogs: true,
  logsExtraFilters: '',
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
}
