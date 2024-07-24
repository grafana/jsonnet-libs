local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(config): {
    local this = self,
    config: config,
    signals:
      {
        blobstore: commonlib.signals.unmarshallJsonMulti(this.config.signals.blobstore, type=this.config.metricsSource),
        azureelasticpool: commonlib.signals.unmarshallJsonMulti(this.config.signals.azureelasticpool, type=this.config.metricsSource),
        azuresqldb: commonlib.signals.unmarshallJsonMulti(this.config.signals.azuresqldb, type=this.config.metricsSource),
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
