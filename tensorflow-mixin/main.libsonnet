local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  withConfigMixin(config): {
    config+: config,
  },

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
        varMetric=':tensorflow:serving:request_count',
        customAllValue='.+',
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      annotations: {},
      panels: panels.new(this),
      dashboards: dashboards.new(this),
      rows: rows.new(panels.new(this)),
      links: links.new(this),
    },

    prometheus: {
      alerts: alerts(this),
      recordingRules: {},
    },
  },
}
