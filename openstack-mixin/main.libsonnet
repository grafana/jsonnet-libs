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
      variables:
        commonlib.variables.new(
          filteringSelector=this.config.filteringSelector,
          groupLabels=this.config.groupLabels,
          instanceLabels=this.config.instanceLabels,
          varMetric='openstack_identity_up',
          enableLokiLogs=this.config.enableLokiLogs,
        )
        + {
          // Group-scoped selector in Grafana's advanced variable syntax, consumed by the
          // alert list panel. commonlib only exposes the group+instance form.
          queriesGroupSelectorAdvanced:
            commonlib.utils.labelsToPromQLSelectorAdvanced(this.config.groupLabels),
        },
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
