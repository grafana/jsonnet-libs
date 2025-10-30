local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(): {
    local this = self,
    config: config,

    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(
          this.config.signals[sig],
          type=this.config.metricsSource
        )
        for sig in std.objectFields(this.config.signals)
      },

    grafana: {
      variables: commonlib.variables.new(
        filteringSelector=this.config.filteringSelector,
        groupLabels=this.config.groupLabels,
        instanceLabels=this.config.instanceLabels,
        varMetric='ibmmq_qmgr_commit_count',
        customAllValue='.+',
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      annotations: {},
      links: (import './links.libsonnet').new(this),
      panels: (import './panels.libsonnet').new(this),
      rows: (import './rows.libsonnet').new(this),
      dashboards: dashboards.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },

    asMonitoringMixin():: {
      grafanaDashboards+:: {
        [name + '.json']: this.grafana.dashboards[name]
        for name in std.objectFields(this.grafana.dashboards)
      },

      prometheusAlerts+:: this.prometheus.alerts,

      prometheusRules+:: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
