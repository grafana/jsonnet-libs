local alerts = import './alerts/alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(): {
    local this = self,
    config: config,

    signals:
      {
        operations: commonlib.signals.unmarshallJsonMulti(
          this.config.signals.operations,
          type=this.config.metricsSource
        ),
        overview: commonlib.signals.unmarshallJsonMulti(
          this.config.signals.overview,
          type=this.config.metricsSource
        ),
      },

    grafana: {
      variables: commonlib.variables.new(
        filteringSelector=this.config.filteringSelector,
        groupLabels=this.config.groupLabels,
        instanceLabels=this.config.instanceLabels,
        varMetric='pinecone_db_record_total',
        customAllValue='.+',
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      annotations: {},
      links: {},
      panels: panels.new(this),
      dashboards: dashboards.new(this),
      rows: rows.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },

    asMonitoringMixin(): {
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:: this.prometheus.alerts,
      prometheusRules+:: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
