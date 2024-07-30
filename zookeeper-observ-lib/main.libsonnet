local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local jvmlib = import 'jvm-observ-lib/main.libsonnet';

{
  new(): {
    local this = self,
    config: import './config.libsonnet',

    //include jvm lib
    jvm::
      jvmlib.new()
      + jvmlib.withConfigMixin(
        {
          filteringSelector: this.config.filteringSelector,
          groupLabels: this.config.groupLabels,
          instanceLabels: this.config.instanceLabels,
          uid: this.config.uid,
          dashboardNamePrefix: this.config.dashboardNamePrefix,
          dashboardTags: this.config.dashboardTags,
          metricsSource: 'prometheus_old',
        }
      ),
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(this.config.signals[sig], type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      panels: (import './panels/main.libsonnet').new(this.signals)
              { jvm: this.jvm.grafana.panels },
      rows: (import './rows.libsonnet').new(this.grafana.panels, type=this.config.metricsSource)
            { jvm: this.jvm.grafana.rows },
      dashboards: (import './dashboards.libsonnet').new(this),
    },
    prometheus: {
      alerts: (import './alerts.libsonnet').new(this)
              + { groups+: this.jvm.prometheus.alerts.groups },
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
