local alerts = import './alerts.libsonnet';
local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

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
      alertsWarningHighSearchOperationRateSpike: 100,
      alertsCriticalDialFailureRateIncrease: 50,
      alertsCriticalBindFailureRateIncrease: 50,

      // logs lib related
      enableLokiLogs: false,
      extraLogLabels: ['channel', 'source', 'keywords', 'level'],
      logsVolumeGroupBy: 'level',
      showLogsVolume: true,
      logsExtraFilters:
        |||
          | label_format timestamp="{{__timestamp__}}"
          | drop channel_extracted,source_extracted,computer_extracted,level_extracted,keywords_extracted
          | line_format `{{ if eq "[[instance]]" ".*" }}{{ alignLeft 25 .instance}}|{{end}}{{alignLeft 12 .channel }}| {{ alignLeft 25 .source}}| {{ .message }}`
        |||,
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
      },
      annotations: {/* ... */ },
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {/* ... */ },
    },
  },
}
