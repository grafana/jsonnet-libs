local alerts = import './alerts.libsonnet';
local links = import './links.libsonnet';
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
      links: links.new(this),
    },
    prometheus: {
      alerts: alerts.new(this),
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
