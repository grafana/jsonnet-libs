local processlib = import '../process-observ-lib/main.libsonnet';
local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(): {
    local this = self,
    config: import './config.libsonnet',

    //include process lib
    process::
      processlib.new()
      + processlib.withConfigMixin(
        {
          filteringSelector: this.config.filteringSelector,
          groupLabels: this.config.groupLabels,
          instanceLabels: this.config.instanceLabels,
          uid: this.config.uid,
          dashboardNamePrefix: this.config.dashboardNamePrefix,
          dashboardTags: this.config.dashboardTags,
          metricsSource: this.config.metricsSource,
        }
      ),
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(this.config.signals[sig], type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      panels:
        (import './panels.libsonnet').new(this.signals, this.process)
        // add panels from process lib
        + this.process.grafana.panels,
      rows:
        (import './rows.libsonnet').new(this.grafana.panels),
      dashboards: (import './dashboards.libsonnet').new(this),
    },
    prometheus: {
      alerts: (import './alerts.libsonnet').new(this),
      recordingRules: {},
    },
    asMonitoringMixin(): {
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:: this.prometheus.alerts,
      prometheusRules+:: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
