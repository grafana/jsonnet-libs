local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local g = import './g.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
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
      links: links.new(this),
      panels: panels.new(this),
      rows: rows.new(this),
      dashboards: dashboards.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
