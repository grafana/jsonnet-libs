{
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['job'],
  groupMode: 'default',  // 'default' or 'custom'
  instanceLabels: ['instance'],
  uid: 'alerts',
  dashboardNamePrefix: '',
  dashboardTags: ['alerts'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: ['prometheus'],
  signals: {
    alerts: (import './signals/alerts.libsonnet')(this),
  },
}
