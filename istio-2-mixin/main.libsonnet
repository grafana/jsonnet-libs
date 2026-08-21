local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local g = import './g.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
local variables = import './variables.libsonnet';
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
        [category]: commonlib.signals.unmarshallJsonMulti(
          this.config.signals[category],
          type=this.config.metricsSource
        )
        for category in std.objectFields(this.config.signals)
      },

    grafana: {
      variables: variables.new(this),
      annotations: {},
      links: links.new(this),
      panels: panels.new(this),
      dashboards: dashboards.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },
  },
}
