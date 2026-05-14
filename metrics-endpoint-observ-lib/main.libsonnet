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
    signals: commonlib.signals.unmarshallJsonMulti(this.config.signals, type=this.config.metricsSource),
    grafana: {
      annotations: {},
      links: {},
      panels: panels.new(this.signals, this.config.parentIntegration),
      dashboards: dashboards.new(this),
      rows: rows.new(this.grafana.panels),
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
