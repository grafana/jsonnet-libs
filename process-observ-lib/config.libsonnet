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
  dashboardNamePrefix: '',
  uid: 'proc',

  // additional params can be added if needed
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  metricsSource: ['prometheus'],  // or any combination of: prometheus, otel, java_otel, java_micrometer.
  signals+:
    {
      system: (import './signals/system.libsonnet')(this),
      process: (import './signals/process.libsonnet')(this),
    },
}
