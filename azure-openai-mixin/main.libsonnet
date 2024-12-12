local alerts = import './alerts.libsonnet';
local annotations = import './annotations.libsonnet';
local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';

{
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
      groupLabels: groupLabels,
      instanceLabels: instanceLabels,
      filteringSelector: filteringSelector,
      dashboardTags: dashboardTags,
      uid: uid,
      dashboardNamePrefix: dashboardNamePrefix,

      // additional params can be added if needed
      criticalEvents: '90',
      alertsThresholdLatency: '10',
      alertsThresholdErrorRate: '5',
      dashboardPeriod: 'now-1h',
      dashboardTimezone: 'default',
      dashboardRefresh: '1m',
    },

    grafana: {
      variables: variables.new(this, varMetric='azure_microsoft_cognitiveservices_accounts_totalcalls_total_count'),
      targets: targets.new(this),
      annotations: annotations.new(this),
      // common dashboards links here
      links: {
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
