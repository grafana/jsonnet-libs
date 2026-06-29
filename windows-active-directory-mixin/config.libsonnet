{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="windows"
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'active-directory',

  dashboardTags: [this.uid + '-mixin'],
  dashboardNamePrefix: 'Windows Active Directory',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  enableLokiLogs: true,

  alertsMetricsDownJobName: 'integrations/windows_exporter',
  alertsHighPendingReplicationOperations: '50',  // count
  alertsHighReplicationSyncRequestFailures: '0',  // count
  alertsHighPasswordChanges: '25',  // count

  // Use 'prometheus' for windows_exporter v0.31.0+.
  metricsSource: ['prometheus'],

  signals+: {
    replication: (import './signals/replication.libsonnet')(this),
    ldap: (import './signals/ldap.libsonnet')(this),
    directoryService: (import './signals/directoryService.libsonnet')(this),
  },
}
