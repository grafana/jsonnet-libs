{
  _config+:: {
    filteringSelector: 'job=~".*windows.*"',
    uid: 'windows',
    dashboardNamePrefix: '',
    dashboardTags: ['windows'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    alertsCPUThresholdWarning: '90',
    alertMemoryUsageThresholdCritical: '90',
    alertDiskUsageThresholdCritical: '90',
  },
}
