{
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: 'job=~"integrations/catchpoint"',
  // Used to identify 'group' of instances.
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  testNameLabel: ['test_name'],
  nodeNameLabel: ['node_name'],
  // Prefix all dashboards uids and alert groups
  uid: 'catchpoint',
  // Prefix for all Dashboards and (optional) rule groups
  dashboardNamePrefix: 'Catchpoint',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Alert thresholds
  alertsHighServerResponseTime: 1000,
  alertsHighServerResponseTimePercent: 1.2,
  alertsTotalTimeExceeded: 5000,
  alertsTotalTimeExceededPercent: 1.2,
  alertsHighDNSResolutionTime: 500,
  alertsHighDNSResolutionTimePercent: 1.2,
  alertsContentLoadingDelay: 3000,
  alertsContentLoadingDelayPercent: 1.2,
  alertsHighFailedRequestRatioPercent: 0.1,
}
