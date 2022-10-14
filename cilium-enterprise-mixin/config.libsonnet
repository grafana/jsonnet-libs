{
  local makeGroupsBy(groups) = std.join(', ', groups),

  _config+:: {
    dashboardTags: ['cilium-enterprise'],
    dashboardPeriod: 'now-15m',
    dashboardRefresh: '10s',
    dashboardTimezone: 'default',
  }
}