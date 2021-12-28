{
  _config+:: {
    local c = self,
    dashboardNamePrefix: 'NSQ',
    dashboardTags: ['nsq'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

  },
}
