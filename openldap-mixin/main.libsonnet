local alerts = import './alerts.libsonnet';
local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local link = g.dashboard.link;

{
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
      dashboardPeriod: 'now-1h',
      dashboardTimezone: 'default',
      dashboardRefresh: '1m',

      // Alert thresholds
      alertsWarningConnectionSpike: 100,
      alertsWarningHighSearchOperationRateSpike: 200,
      alertsWarningDialFailureSpike: 10,
      alertsWarningBindFailureRateIncrease: 10,

      // logs lib related
      enableLokiLogs: false,
    },
    grafana: {
      variables: variables.new(this),
      targets: targets.new(this),
      panels: panels.new(this),
      dashboards: dashboards.new(this),

      // Define any common links or annotations if needed
      links: {
               local link = g.dashboard.link,
               backToOverview:
                 link.link.new('Back to OpenLDAP overview', '/d/' + this.grafana.dashboards.overview.uid)
                 + link.link.options.withKeepTime(true),
               otherDashboards:
                 link.dashboards.new('All OpenLDAP dashboards', this.config.dashboardTags)
                 + link.dashboards.options.withIncludeVars(true)
                 + link.dashboards.options.withKeepTime(true)
                 + link.dashboards.options.withAsDropdown(true),
             }
             +
             if this.config.enableLokiLogs then
               {
                 logs:
                   link.link.new('OpenLDAP logs', '/d/' + this.grafana.dashboards.logs.uid)
                   + link.link.options.withKeepTime(true),
               },
      annotations: {/* ... */ },
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {/* ... */ },
    },
  },
}
