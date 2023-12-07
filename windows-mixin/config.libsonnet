{
  _config+:: {
    // labels to group windows hosts:
    groupLabels: ['job'],
    // labels to identify single windows host:
    instanceLabels: ['instance'],
    // selector to include in all queries(including alerts)
    filteringSelector: 'job=~".*windows.*"',
    // prefix all dashboards uids and alert groups
    uid: 'windows',
    // prefix dashboards titles
    dashboardNamePrefix: '',
    dashboardTags: ['windows'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    alertsCPUThresholdWarning: '90',
    alertMemoryUsageThresholdCritical: '90',
    alertDiskUsageThresholdCritical: '90',
    // set to false to disable logs dashboard and logs annotations
    enableLokiLogs: true,
  },
}
