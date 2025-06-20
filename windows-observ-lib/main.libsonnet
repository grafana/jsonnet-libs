local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(): {

    local this = self,
    config: config,
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(
          this.config.signals[sig],
           type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      variables: commonlib.variables.new(
        filteringSelector=this.config.filteringSelector,
        groupLabels=this.config.groupLabels,
        instanceLabels=this.config.instanceLabels,
        varMetric='windows_os_info',
        customAllValue='.+',
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      annotations: (import './annotations.libsonnet').new(this),
      links: {
        local link = g.dashboard.link,
        backToFleet:
          link.link.new('Back to Windows fleet', '/d/' + this.grafana.dashboards.fleet.uid)
          + link.link.options.withKeepTime(true),
        backToOverview:
          link.link.new('Back to Windows overview', '/d/' + this.grafana.dashboards.overview.uid)
          + link.link.options.withKeepTime(true),
        otherDashboards:
          link.dashboards.new('All Windows dashboards', this.config.dashboardTags)
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
  withConfigMixin(config): {
    config+: config,
  },

}
