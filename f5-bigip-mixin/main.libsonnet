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
        varMetric='bigip_node_status_availability_state',
        customAllValue='.+',
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      annotations: {},
      links: links.new(this),
      panels: panels.new(this),
      rows: rows.new(this),
      dashboards: dashboards.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
