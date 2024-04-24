local alerts = import './alerts.libsonnet';
local annotations = import './annotations.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local signals = import './signals.libsonnet';
local variables = import './variables.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{

  withConfigMixin(config): {
    config+: config,
  },

  new(): {

    local this = self,
    config: config,
    signals: signals.new(this),
    grafana: {
      variables: commonlib.variables.new(
        filteringSelector=this.config.filteringSelector,
        groupLabels=this.config.groupLabels,
        instanceLabels=this.config.instanceLabels,
        varMetric='up',
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      annotations: annotations.new(this),
      links: links.new(this),
      panels: panels.new(this),
      rows: rows.new(this.grafana.panels),
      dashboards: dashboards.new(this),
    },
    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },

    asMonitoringMixin(): {
      // _config+:: this.config,
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:: this.prometheus.alerts,
      prometheusRuless+:: this.prometheus.recordingRules,
    },

  },

}
