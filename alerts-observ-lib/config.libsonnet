local commonlib = import 'common-lib/common/main.libsonnet';

{
  local this = self,
  filteringSelector: '',
  groupLabels: ['job'],
  groupMode: 'default',  // 'default' or 'custom'
  instanceLabels: ['instance'],
  uid: 'alerts',
  dashboardNamePrefix: '',
  dashboardTags: ['alerts'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: commonlib.dashboards.defaultTimezone,
  dashboardRefresh: '1m',
  metricsSource: ['prometheus'],
  signals: {
    alerts: (import './signals/alerts.libsonnet')(this),
  },
}
