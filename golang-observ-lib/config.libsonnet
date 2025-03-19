{
  // any modular library should include as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  dashboardTags: [self.uid],
  uid: 'golang',
  dashboardNamePrefix: '',

  // additional params can be added if needed
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // otel: https://pkg.go.dev/go.opentelemetry.io/contrib/instrumentation/runtime
  // otel_with_suffixes: when add_metric_suffixes=true in otelcollector
  // or prometheus
  metricsSource: ['prometheus', 'otel', 'otel_with_suffixes'],
  signals: (import './signals/golang.libsonnet')(this),
}
