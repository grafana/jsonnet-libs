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
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(this.config.signals[sig], type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      annotations: {},
      links: {},
      panels: panels.new(this.signals),
      dashboards: dashboards.new(this),
      rows: rows.new(this.grafana.panels, type=this.config.metricsSource),
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
}
