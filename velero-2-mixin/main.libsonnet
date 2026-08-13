local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local g = import './g.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
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
        // legacy panel queries filter by dashboard variables only, so the static
        // filteringSelector is kept out of dashboard queries here; the signal
        // specs retain it for alert expressions
        [sig]: commonlib.signals.unmarshallJsonMulti(
          this.config.signals[sig] { filteringSelector: '' },
          type=this.config.metricsSource
        )
        for sig in std.objectFields(this.config.signals)
      },

    grafana: {
      variables: variables.new(this, varMetric='velero_backup_success_total'),
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
}
