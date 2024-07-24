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
      panels: (import './panels/main.libsonnet').new(this.signals),
      rows: (import './rows.libsonnet').new(this.grafana.panels, type=this.config.metricsSource),
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
      prometheusRuless+:: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
