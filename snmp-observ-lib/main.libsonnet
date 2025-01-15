local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(): {
    local this = self,
    config: import './config.libsonnet',
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(this.config.signals[sig], type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      panels: (import './panels/main.libsonnet').new(this.signals, this),
      rows: (import './rows.libsonnet').new(this.grafana.panels, type=this.config.metricsSource),
      annotations: {},
      // common links here
      links: {
        local link = g.dashboard.link,
        backToFleet:
          link.link.new('Back to network fleet', '/d/' + this.grafana.dashboards['snmp-fleet.json'].uid)
          + link.link.options.withKeepTime(true),
        otherDashboards:
          link.dashboards.new('All network dashboards', this.config.dashboardTags)
          + link.dashboards.options.withIncludeVars(true)
          + link.dashboards.options.withKeepTime(true)
          + link.dashboards.options.withAsDropdown(true),
      },
      dashboards: (import './dashboards.libsonnet').new(this),
    },
    prometheus: {
      alerts: (import './alerts.libsonnet').new(this),
      recordingRules: {},
    },
    asMonitoringMixin(): {
      // _config+:: this.config,
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:: this.prometheus.alerts,
      prometheusRules+:: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
