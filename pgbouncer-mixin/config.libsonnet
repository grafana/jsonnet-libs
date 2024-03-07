{
  // any modular library should include as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids
  enableMultiCluster: false,
  filteringSelector: 'job="integrations/pgbouncer"',
  groupLabels: if self.enableMultiCluster then ['job', 'cluster', 'pgbouncer_cluster', 'database'] else ['job', 'pgbouncer_cluster', 'database'],
  logLabels: if self.enableMultiCluster then ['job', 'cluster', 'pgbouncer_cluster', 'instance'] else ['job', 'pgbouncer_cluster', 'instance'],
  mainGroupLabels: if self.enableMultiCluster then ['job', 'cluster', 'pgbouncer_cluster'] else ['job', 'pgbouncer_cluster'],
  legendLabels: ['database'],
  clusterLegendLabel: ['pgbouncer_cluster', 'instance', 'database'],
  instanceLabels: ['instance'],
  dashboardTags: [self.uid],
  uid: 'pgbouncer',
  dashboardNamePrefix: '',

  // additional params can be added if needed
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // alert thresholds
  alertsHighClientWaitingConnections: 20,
  alertsHighClientWaitTime: 15,
  alertsHighServerConnectionSaturationWarning: 80,
  alertsHighServerConnectionSaturationCritical: 90,
  alertsHighNetworkTraffic: 50,

  // logs lib related
  enableLokiLogs: true,
  extraLogLabels: ['level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
}
