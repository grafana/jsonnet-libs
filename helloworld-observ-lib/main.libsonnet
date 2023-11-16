local alerts = import './alerts.libsonnet';
local annotations = import './annotations.libsonnet';
local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';

{
  // any lib should have have configurable params:
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'uid' - UID to prefix all dashboards original uids
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.

  withConfigMixin(config): {
    config+: config,
  },
  new(
    filteringSelector,
    groupLabels=['job'],
    instanceLabels=['instance'],
    dashboardNamePrefix='',
    dashboardTags=[uid],
    uid,
  ): {

    local this = self,
    config: {
      // any modular library should inlcude as inputs:
      // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
      // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
      // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
      // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
      // 'uid' - UID to prefix all dashboards original uids
      groupLabels: groupLabels,
      instanceLabels: instanceLabels,
      filteringSelector: filteringSelector,
      dashboardTags: dashboardTags,
      uid: uid,
      dashboardNamePrefix: dashboardNamePrefix,

      // additional params can be added if needed
      criticalEvents: '90',
      alertsThreshold1: '90',
      alertsThreshold2: '75',
      dashboardPeriod: 'now-1h',
      dashboardTimezone: 'default',
      dashboardRefresh: '1m',

      // logs lib related
      enableLokiLogs: true,
      logsExtraFilters: '',
      extraLogLabels: ['level'],
      logsVolumeGroupBy: 'level',
      showLogsVolume: true,
    },

    grafana: {
      variables: variables.new(this, varMetric='up{%(filteringSelector)s}' % this.config),
      targets: targets.new(this),
      annotations: annotations.new(this),
      // common dashboards links here
      links: {
        local link = g.dashboard.link,
        backToFleet:
          link.link.new('Back to Helloworld fleet', '/d/' + this.grafana.dashboards.fleet.uid)
          + link.link.options.withKeepTime(true),
        backToOverview:
          link.link.new('Back to Helloworld overview', '/d/' + this.grafana.dashboards.overview.uid)
          + link.link.options.withKeepTime(true),
        otherDashboards:
          link.dashboards.new('All Helloworld dashboards', this.config.dashboardTags)
          + link.dashboards.options.withIncludeVars(true)
          + link.dashboards.options.withKeepTime(true)
          + link.dashboards.options.withAsDropdown(true),
      },

      panels: panels.new(this),
      dashboards: dashboards.new(this),

    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },

  },

}
