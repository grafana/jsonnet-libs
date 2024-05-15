local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(): {
    local this = self,
    config: (import './config.libsonnet')._config,
    signals:
      {
        container: commonlib.signals.unmarshallJsonMulti(
          this.config.signals.container, type=this.config.metricsSource
        ),
        machine: commonlib.signals.unmarshallJsonMulti(
          this.config.signals.machine, type=this.config.metricsSource
        ),
      },
    grafana: {
      panels: (import './panels.libsonnet').new(this),
      rows: (import './rows.libsonnet').new(this),
      dashboards: (import './dashboards.libsonnet').new(this),
      // common links here
      links: {
        local link = g.dashboard.link,
        otherDashboards:
          link.dashboards.new('All Docker dashboards', this.config.dashboardTags)
          + link.dashboards.options.withIncludeVars(true)
          + link.dashboards.options.withKeepTime(true)
          + link.dashboards.options.withAsDropdown(false),
      },
    },
    prometheus: {
      alerts: {},
      recordingRules: {},
    },
    asMonitoringMixin(): {
      // _config+:: this.config,
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:: this.prometheus.alerts,
      prometheusRuless+:: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
