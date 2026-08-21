local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
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

    // Cluster-overview has no base_url variable, so its signals are scoped to
    // solr_cluster only (queriesSelector is frozen at unmarshall time).
    signalsCluster:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(
          this.config.signals[sig] { instanceLabels: ['solr_cluster'] },
          type=this.config.metricsSource
        )
        for sig in std.objectFields(this.config.signals)
      },

    grafana: {
      variables: commonlib.variables.new(
        filteringSelector=this.config.filteringSelector,
        groupLabels=this.config.groupLabels,
        instanceLabels=this.config.instanceLabels,
        varMetric='solr_metrics_core_errors_total',
        customAllValue=this.config.customAllValue,
        enableLokiLogs=this.config.enableLokiLogs,
      ),
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
