local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(): {
    local this = self,
    config: import './config.libsonnet',

    local signalDefs = {
      health: (import './signals/health.libsonnet')(this.config),
      problems: (import './signals/problems.libsonnet')(this.config),
      performance: (import './signals/performance.libsonnet')(this.config),
      maintenance: (import './signals/maintenance.libsonnet')(this.config),
      queries: (import './signals/queries.libsonnet')(this.config),
      cluster: (import './signals/cluster.libsonnet')(this.config),
    },

    signals: {
      [sig]: commonlib.signals.unmarshallJsonMulti(signalDefs[sig], type=this.config.metricsSource)
      for sig in std.objectFields(signalDefs)
      },

    grafana: {
      panels: (import './panels/main.libsonnet').new(this.signals, this.config),
      rows: (import './rows.libsonnet').new(this.grafana.panels, type=this.config.metricsSource),

      links: {
        local link = g.dashboard.link,
        otherDashboards:
          link.dashboards.new('All PostgreSQL dashboards', this.config.dashboardTags)
          + link.dashboards.options.withIncludeVars(true)
          + link.dashboards.options.withKeepTime(true)
          + link.dashboards.options.withAsDropdown(false),
      },

      dashboards: (import './dashboards.libsonnet').new(this),
    },

    prometheus: {
      alerts: (import './alerts.libsonnet').new(this),
      recordingRules: {},
    },

    asMonitoringMixin(): {
      grafanaDashboards: this.grafana.dashboards,
      prometheusAlerts: this.prometheus.alerts,
      prometheusRules: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
