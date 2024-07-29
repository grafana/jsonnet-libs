local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local processlib = import 'process-observ-lib/main.libsonnet';

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
          dashboardNamePrefix: this.cofnig.dashboardNamePrefix,
          dashboardTags: this.cofnig.dashboardTags,
          metricsSource:
            if this.config.metricsSource == 'otel' then 'java_otel'
            else if this.config.metricsSource == 'prometheus' then 'prometheus'
            else if this.config.metricsSource == 'java_micrometer' then 'java_micrometer'
            else error 'no such metricsSource for processlib',
        }
      ),
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(this.config.signals[sig], type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      panels:
        (import './panels.libsonnet').new(this.signals)
        // add panels from process lib
        + this.process.grafana.panels,
      rows:
        (import './rows.libsonnet').new(this.grafana.panels, type=this.config.metricSource)
        // add rows from process lib
        + this.process.grafana.rows,
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
