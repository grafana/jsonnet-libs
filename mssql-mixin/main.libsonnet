local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local g = import './g.libsonnet';
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
        local baseVars = commonlib.variables.new(
          filteringSelector=this.config.filteringSelector,
          groupLabels=this.config.groupLabels,
          instanceLabels=this.config.instanceLabels,
          varMetric='mssql_io_stall_seconds_total',
          customAllValue='.+',
          enableLokiLogs=this.config.enableLokiLogs,
        );

        local dbVariable = {
          label: 'Database',
          name: 'db',
          query: 'label_values(mssql_io_stall_seconds_total{%s}, db)' % this.config.filteringSelector,
          datasource: {
            type: 'prometheus',
            uid: '${prometheus_datasource}',
          },
          refresh: 2,
          sort: 1,
          type: 'query',
          includeAll: true,
          allValue: '.*',
          multi: true,
        };

        baseVars {
          multiInstance+: [dbVariable],
          singleInstance+: [dbVariable],
        },
      annotations: {},
      links: links.new(this),
      panels: panels.new(this),
      dashboards: dashboards.new(this),
      rows: rows.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },
  },
}
