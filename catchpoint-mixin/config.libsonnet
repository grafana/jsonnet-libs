{
  local this = self,
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: '',
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

  // Each dashboard's own template variables, layered onto filteringSelector and
  // consumed by the signal files as their filteringSelector. The overview ranks
  // across every node, so it constrains test_name only; both drilldowns show a
  // single test (or node) broken down by the other label, so they constrain both.
  local scopedSelector(extra) =
    std.join(',', std.filter(function(s) std.length(s) > 0, [this.filteringSelector, extra])),
  overviewSelector: scopedSelector('test_name=~"$test_name"'),
  drilldownSelector: scopedSelector('test_name=~"$test_name",node_name=~"$node_name"'),

  metricsSource: 'prometheus',
  // The drilldown signal files are imported once per pivot label: the "by test"
  // dashboard breaks its single test down by node_name and vice versa, while the
  // content and error breakdowns aggregate by the dashboard's own label.
  signals: {
    overview: (import './signals/overview.libsonnet')(this),
    timingByNode: (import './signals/timing.libsonnet')(this, 'node_name'),
    timingByTest: (import './signals/timing.libsonnet')(this, 'test_name'),
    networkByNode: (import './signals/network.libsonnet')(this, 'node_name'),
    networkByTest: (import './signals/network.libsonnet')(this, 'test_name'),
    contentByTest: (import './signals/content.libsonnet')(this, 'test_name'),
    contentByNode: (import './signals/content.libsonnet')(this, 'node_name'),
    errorsByTest: (import './signals/errors.libsonnet')(this, 'test_name'),
    errorsByNode: (import './signals/errors.libsonnet')(this, 'node_name'),
  },

  // Alert thresholds
  alertsHighServerResponseTime: 1000,  // ms
  alertsHighServerResponseTimePercent: 1.2,  // ratio of the trailing 1h average
  alertsTotalTimeExceeded: 5000,  // ms
  alertsTotalTimeExceededPercent: 1.2,  // ratio of the trailing 1h average
  alertsHighDNSResolutionTime: 500,  // ms
  alertsHighDNSResolutionTimePercent: 1.2,  // ratio of the trailing 1h average
  alertsContentLoadingDelay: 1500,  // ms
  alertsContentLoadingDelayPercent: 1.2,  // ratio of the trailing 1h average
  alertsHighFailedRequestRatioPercent: 0.1,  // ratio, 0-1
}
