local alerts = import './alerts.libsonnet';
local annotations = import './annotations.libsonnet';
local links = import './links.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
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
      variables: variables.new(this, varMetric='up{%(filteringSelector)s}' % this.config),
      targets: targets.new(this),
      annotations: annotations.new(this),
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
