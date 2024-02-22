{
  _config+:: {
    // labels to group openldap hosts:
    groupLabels: ['job'],
    // labels to identify single openldap host:
    instanceLabels: ['instance'],
    // selector to include in all queries(including alerts)
    filteringSelector: 'job=~".*openldap.*"',
    // prefix all dashboards uids and alert groups
    uid: 'openldap',
    // prefix dashboards titles
    dashboardNamePrefix: '',
    dashboardTags: ['openldap-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    alertsWarningConnectionSpike: 100,
    alertsWarningHighSearchOperationRateSpike: 200,
    alertsWarningDialFailureSpike: 10,
    alertsWarningBindFailureRateIncrease: 10,

    enableLokiLogs: true,
    showLogsVolume: true,
  },
}
