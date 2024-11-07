local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(config): {
    local this = self,
    config: config,
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(this.config.signals[sig], type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      panels: (import './panels/main.libsonnet').new(this),
      rows: (import './rows.libsonnet').new(this),
      dashboards: (import './dashboards.libsonnet').new(this),
    },
    asMonitoringMixin(): {
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:: this.config.prometheus.alerts,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
