local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local g = import './g.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';

{

  withConfigMixin(config): {
    config+: config,
  },

  new(): {

    local this = self,
    config: config,

    grafana: {
      variables: variables.new(this, varMetric='pgbouncer_databases_current_connections'),
      targets: targets.new(this),
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
