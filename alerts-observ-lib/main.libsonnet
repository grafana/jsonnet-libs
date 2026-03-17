local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local g = import './g.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  withConfigMixin(config): {
    config+: config,
  },

  new(): {
    local this = self,
    config: config,
    signals: {
      [sig]: commonlib.signals.unmarshallJsonMulti(
        this.config.signals[sig],
        type=this.config.metricsSource
      )
      for sig in std.objectFields(this.config.signals)
    },
    grafana: {
      annotations: (import './annotations.libsonnet').new(this),
      links: {},
      panels: panels.new(this),
      rows: rows.new(this.grafana.panels),
      dashboards: dashboards.new(this),
    },

    prometheus: {
      alerts: {},
      recordingRules: {},
    },

    asMonitoringMixin(): {
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:: this.prometheus.alerts,
      prometheusRules+:: this.prometheus.recordingRules,
    },
  },
}
