local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(): {
    local this = self,
    config: (import './config.libsonnet')._config,
    signals:
      {
        blobstore: commonlib.signals.unmarshallJsonMulti(this.config.signals.blobstore, type=this.config.metricsSource),
      },
    grafana: {
      panels: (import './panels.libsonnet').new(this),
      rows: (import './rows.libsonnet').new(this),
      dashboards: (import './dashboards.libsonnet').new(this),
    },
    prometheus: {
      alerts: {},
      recordingRules: {},
    },
    asMonitoringMixin(): {
      grafanaDashboards+:: this.grafana.dashboards,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
