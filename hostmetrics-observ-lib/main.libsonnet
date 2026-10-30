local alerts = import './alerts.libsonnet';
local annotations = import './annotations.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels/main.libsonnet';
local rows = import './rows.libsonnet';
local common = import './signals/common.libsonnet';
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
        varMetric=[common.discoveryMetric[source] for source in this.config.metricsSource],
        customAllValue=this.config.customAllValue,
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      annotations: annotations.new(this),
      links: links.new(this),
      panels: panels.new(this),
      rows: rows.new(this),
      dashboards: dashboards.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
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
